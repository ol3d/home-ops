#!/usr/bin/env python3
"""Configuration manager for homelab.

Creates config/*.sops.yaml files from the schema, validates them, and
renders values into their runtime locations. The schema is the single
source of truth: every field, default, and render target is declared
there. Day-2 value edits happen via 'sops edit', not here.
"""

import argparse
import json
import os
import subprocess
import sys
from pathlib import Path

import yaml


def load_schema(schema_path: str) -> dict:
    with open(schema_path) as f:
        return yaml.safe_load(f)


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


def cmd_create(schema_path: str, config_dir: str) -> list[str]:
    """Create or repair config files from the schema.

    Missing files are created and missing fields are re-added with their
    schema defaults; existing values are always preserved. Files that
    need no changes are left untouched. Returns the added field keys.
    """
    schema = load_schema(schema_path)
    config_path = Path(config_dir)
    config_path.mkdir(parents=True, exist_ok=True)
    added = []

    for file_def in schema["files"]:
        name = file_def["name"]
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
            field["key"]
            for field in file_def["fields"]
            if get_nested(values, field["key"]) is None
        ]
        if file_added:
            for field in file_def["fields"]:
                if get_nested(values, field["key"]) is None:
                    set_nested(values, field["key"], field.get("default", ""))
            write_config(config_path, name, values)
        added.extend(f"{key} (config/{name}.sops.yaml)" for key in file_added)

    return added


def cmd_validate(schema_path: str, config_dir: str) -> None:
    schema = load_schema(schema_path)
    config_path = Path(config_dir)
    errors = []

    for file_def in schema["files"]:
        name = file_def["name"]
        file_path = config_path / f"{name}.sops.yaml"

        if not file_path.exists():
            errors.append(f"{name}.sops.yaml: missing (run 'task bootstrap')")
            continue

        existing = read_existing(file_path)
        if existing is UNDECRYPTABLE:
            errors.append(f"{name}.sops.yaml: cannot decrypt (check AWS credentials / KMS access)")
            continue

        for field in file_def["fields"]:
            if get_nested(existing, field["key"]) is None:
                errors.append(f"{name}.sops.yaml: missing key '{field['key']}'")

    if errors:
        print("Validation errors:")
        for e in errors:
            print(f"  - {e}")
        sys.exit(1)
    print("All config files valid.")


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


def cmd_render(schema_path: str, config_dir: str) -> list[str]:
    schema = load_schema(schema_path)
    config_path = Path(config_dir)
    missing = []

    for file_def in schema["files"]:
        name = file_def["name"]
        existing = read_existing(config_path / f"{name}.sops.yaml")
        if not isinstance(existing, dict):
            continue

        for field in file_def["fields"]:
            render = field.get("render")
            if not render:
                continue
            value = str(get_nested(existing, field["key"]) or "")

            if render["type"] == "git_config":
                target = expand_path(render["path"])
                if value:
                    set_git_config(target, render["config_key"], value)
                else:
                    set_git_config(target, render["config_key"], "")
                    missing.append(f"{field['key']} (config/{name}.sops.yaml)")
            elif render["type"] == "key_file":
                target = expand_path(render["path"])
                if value:
                    write_key_file(target, value)
                elif not target.exists() or not target.read_text().strip():
                    write_key_file(target, "")
                    missing.append(f"{field['key']} (config/{name}.sops.yaml)")
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
                        missing.append(f"{field['key']} (config/{name}.sops.yaml)")
    return missing


def main() -> None:
    parser = argparse.ArgumentParser(description="Homelab configuration manager")
    parser.add_argument("--schema", required=True, help="Path to schema.yaml")
    parser.add_argument("--config-dir", required=True, help="Path to config/ directory")

    subparsers = parser.add_subparsers(dest="command", required=True)
    subparsers.add_parser("create", help="Create or update config files from schema (existing values preserved)")
    subparsers.add_parser("render", help="Render config values into their runtime locations")

    args = parser.parse_args()

    if args.command == "create":
        added = cmd_create(args.schema, args.config_dir)
        if added:
            print("Added missing config fields with schema defaults:")
            for item in added:
                print(f"  - {item}")
            print("Edit values with 'sops edit'.")
        else:
            print("Config files complete; nothing added.")
    elif args.command == "render":
        missing = cmd_render(args.schema, args.config_dir)
        if missing:
            print("Some values are still blank:")
            for item in missing:
                print(f"  - {item}")
        else:
            print("Rendered all values; none blank.")


if __name__ == "__main__":
    main()
