#!/usr/bin/env python3
"""Configuration manager for homelab.

Creates config/*.sops.yaml files from the schemas, and renders values
into their runtime locations. Each schema directory under schemas/
mirrors one config file: schema.yaml holds keys with their defaults in
the same shape as the config itself; render.yaml (optional) maps dotted
key paths to render directives. Day-2 value edits happen via 'sops
edit', not here.
"""

import argparse
import json
import os
import subprocess
import sys
from pathlib import Path

import yaml


def flatten_defaults(data: dict, prefix: str = "") -> dict:
    fields = {}
    for key, value in data.items():
        dotted = f"{prefix}{key}"
        if isinstance(value, dict):
            fields.update(flatten_defaults(value, f"{dotted}."))
        else:
            fields[dotted] = "" if value is None else value
    return fields


def load_schemas(schema_dir: str) -> list[dict]:
    schemas = []
    for schema_path in sorted(Path(schema_dir).glob("*/schema.yaml")):
        name = schema_path.parent.name
        with open(schema_path) as f:
            defaults = flatten_defaults(yaml.safe_load(f) or {})
        render_path = schema_path.parent / "render.yaml"
        render = {}
        if render_path.exists():
            with open(render_path) as f:
                render = yaml.safe_load(f) or {}
            for dotted in render:
                if dotted not in defaults:
                    sys.exit(f"Render directive for unknown key '{dotted}' in {name} schema")
        schemas.append({"name": name, "fields": defaults, "render": render})
    if not schemas:
        sys.exit(f"No schemas found in {schema_dir}")
    return schemas


def get_nested(data: dict, dotted_key: str) -> object:
    node = data
    for part in dotted_key.split("."):
        if not isinstance(node, dict) or part not in node:
            return None
        node = node[part]
    return node


def set_nested(data: dict, dotted_key: str, value: object) -> None:
    parts = dotted_key.split(".")
    node = data
    for part in parts[:-1]:
        if not isinstance(node.get(part), dict):
            node[part] = {}
        node = node[part]
    node[parts[-1]] = value


UNDECRYPTABLE = object()


def read_existing(config_path: Path) -> dict | None:
    if not config_path.exists():
        return None
    result = subprocess.run(
        ["sops", "-d", str(config_path)],
        capture_output=True,
        text=True,
    )
    if result.returncode == 0:
        return yaml.safe_load(result.stdout)
    return UNDECRYPTABLE  # type: ignore[return-value]


def write_config(config_dir: Path, name: str, values: dict) -> None:
    output_path = config_dir / f"{name}.sops.yaml"

    with open(output_path, "w") as f:
        yaml.dump(values, f, default_flow_style=False, sort_keys=False)

    result = subprocess.run(
        ["sops", "-e", "-i", "--input-type", "yaml", "--output-type", "yaml", str(output_path)],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        print(f"  ERROR: sops encryption failed: {result.stderr}", file=sys.stderr)
        output_path.unlink(missing_ok=True)
        sys.exit(1)

    print(f"  Written: {output_path}")


def cmd_create(schema_dir: str, config_dir: str) -> list[str]:
    """Create or repair config files from the schemas.

    Missing files are created and missing fields are re-added with their
    schema defaults; existing values are always preserved. Files that
    need no changes are left untouched. Returns the added field keys.
    """
    schemas = load_schemas(schema_dir)
    config_path = Path(config_dir)
    config_path.mkdir(parents=True, exist_ok=True)
    added = []

    for schema in schemas:
        name = schema["name"]
        existing = read_existing(config_path / f"{name}.sops.yaml")
        if existing is UNDECRYPTABLE:
            print(
                f"  ERROR: config/{name}.sops.yaml exists but cannot be decrypted. "
                "Left untouched - fix access (AWS credentials / KMS keys) before re-running.",
                file=sys.stderr,
            )
            sys.exit(1)
        values = existing if isinstance(existing, dict) else {}
        file_added = [
            dotted
            for dotted in schema["fields"]
            if get_nested(values, dotted) is None
        ]
        if file_added:
            for dotted, default in schema["fields"].items():
                if get_nested(values, dotted) is None:
                    set_nested(values, dotted, default)
            write_config(config_path, name, values)
        added.extend(f"{key} (config/{name}.sops.yaml)" for key in file_added)

    return added


def expand_path(path: str) -> Path:
    return Path(path).expanduser()


def set_git_config(path: Path, config_key: str, value: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if not path.exists():
        path.write_text("[safe]\n\tdirectory = /workspace\n")
    subprocess.run(["git", "config", "--file", str(path), config_key, value], check=True)


def write_key_file(path: Path, value: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(value)
    os.chmod(path, 0o600)


def write_opencode_auth(path: Path, provider: str, value: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    auth = {}
    if path.exists():
        try:
            auth = json.loads(path.read_text())
        except json.JSONDecodeError:
            auth = {}
    auth[provider] = {"type": "api", "key": value}
    path.write_text(json.dumps(auth, indent=2) + "\n")
    os.chmod(path, 0o600)


def cmd_render(schema_dir: str, config_dir: str) -> list[str]:
    schemas = load_schemas(schema_dir)
    config_path = Path(config_dir)
    missing = []

    for schema in schemas:
        name = schema["name"]
        existing = read_existing(config_path / f"{name}.sops.yaml")
        if not isinstance(existing, dict):
            continue

        for dotted, render in schema["render"].items():
            value = str(get_nested(existing, dotted) or "")

            if render["type"] == "git_config":
                target = expand_path(render["path"])
                if value:
                    set_git_config(target, render["config_key"], value)
                else:
                    set_git_config(target, render["config_key"], "")
                    missing.append(f"{dotted} (config/{name}.sops.yaml)")
            elif render["type"] == "key_file":
                target = expand_path(render["path"])
                if value:
                    write_key_file(target, value)
                elif not target.exists() or not target.read_text().strip():
                    write_key_file(target, "")
                    missing.append(f"{dotted} (config/{name}.sops.yaml)")
            elif render["type"] == "opencode_auth":
                target = expand_path(render["path"])
                if value:
                    write_opencode_auth(target, render["provider"], value)
                else:
                    has_key = False
                    if target.exists():
                        try:
                            has_key = render["provider"] in json.loads(target.read_text())
                        except json.JSONDecodeError:
                            pass
                    if not has_key:
                        missing.append(f"{dotted} (config/{name}.sops.yaml)")
    return missing


def main() -> None:
    parser = argparse.ArgumentParser(description="Homelab configuration manager")
    parser.add_argument("--schema-dir", required=True, help="Path to schemas/ directory")
    parser.add_argument("--config-dir", required=True, help="Path to config/ directory")

    subparsers = parser.add_subparsers(dest="command", required=True)
    subparsers.add_parser("create", help="Create or update config files from schema (existing values preserved)")
    subparsers.add_parser("render", help="Render config values into their runtime locations")

    args = parser.parse_args()

    if args.command == "create":
        added = cmd_create(args.schema_dir, args.config_dir)
        if added:
            print("Added missing config fields with schema defaults:")
            for item in added:
                print(f"  - {item}")
            print("Edit values with 'sops edit'.")
        else:
            print("Config files complete; nothing added.")
    elif args.command == "render":
        missing = cmd_render(args.schema_dir, args.config_dir)
        if missing:
            print("Some values are still blank:")
            for item in missing:
                print(f"  - {item}")
        else:
            print("Rendered all values; none blank.")


if __name__ == "__main__":
    main()
