#!/usr/bin/env python3
"""Bootstrap the devcontainer workspace.

Thin flow around the config module: checks SOPS KMS key access (the gate
for decrypting config), ensures config/ files exist, renders credentials,
and offers in-flow editing of blanks. Idempotent: safe to re-run at any
time. AWS credentials are managed by 'task workspace:aws:auth', which runs before
this in the bootstrap chain.
"""

import importlib.util
import os
import subprocess
import sys
from pathlib import Path

import boto3

SCRIPTS_DIR = Path(__file__).resolve().parent
TASKFILES_DIR = SCRIPTS_DIR.parent.parent
REPO_ROOT = TASKFILES_DIR.parent
CONFIG_SCRIPT = TASKFILES_DIR / "config" / "scripts" / "configure.py"
SCHEMAS_DIR = TASKFILES_DIR / "config" / "schemas"
CONFIG_DIR = REPO_ROOT / "config"

AWS_CONFIG_FILE = Path.home() / ".aws" / "config"


def load_config_module():
    spec = importlib.util.spec_from_file_location("configure", CONFIG_SCRIPT)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def get_region() -> str:
    region = os.environ.get("AWS_REGION") or os.environ.get("AWS_DEFAULT_REGION")
    if not region and AWS_CONFIG_FILE.exists():
        for line in AWS_CONFIG_FILE.read_text().splitlines():
            if line.strip().startswith("region"):
                parts = line.split("=", 1)
                if len(parts) == 2 and parts[1].strip():
                    region = parts[1].strip()
    return region or "us-east-1"


def main() -> None:
    print("=== Workspace Bootstrap ===\n")

    kms = boto3.client("kms", region_name=get_region())
    sops_keys = [a["AliasName"] for a in kms.list_aliases()["Aliases"] if a["AliasName"].startswith("alias/sops")]
    if not sops_keys:
        sys.exit(
            "No SOPS KMS keys (alias/sops-*) reachable with these credentials. "
            "Either they belong to a different account or region, or this is a "
            "fresh account - in that case run 'task terraform:aws:apply' first to "
            "create them."
        )
    print(f"SOPS KMS keys reachable: {len(sops_keys)}\n")

    config = load_config_module()

    added = config.cmd_create(str(SCHEMAS_DIR), str(CONFIG_DIR))
    if added:
        print("Repaired missing config fields with schema defaults:")
        for item in added:
            print(f"  - {item}")

    missing = config.cmd_render(str(SCHEMAS_DIR), str(CONFIG_DIR))
    print("Rendered credentials from config/.")

    if missing and sys.stdin.isatty():
        answer = input(
            "\nSome values are still blank. Open sops edit now to fill them in? [Y/n] "
        ).strip().lower()
        if answer in ("", "y", "yes"):
            for name in sorted({item.split(" (config/")[1].rstrip(")") for item in missing}):
                print(f"Editing config/{name} ...")
                subprocess.run(["sops", "edit", str(CONFIG_DIR / name)], check=False)
            missing = config.cmd_render(str(SCHEMAS_DIR), str(CONFIG_DIR))
            print("Re-rendered credentials after edit.")

    if missing:
        print("\nSome values are still blank. Fill them in with 'sops edit', then re-run:")
        for item in missing:
            print(f"  - {item}")
    else:
        print("\nWorkspace is fully configured.")

    print("\n=== Bootstrap complete ===")


if __name__ == "__main__":
    main()
