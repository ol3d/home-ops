#!/usr/bin/env python3
"""Manage AWS credentials for the homelab toolchain.

Prompts for an IAM access key on first use (writing it to the persistent
~/.aws volume), or forces re-entry with the 'rotate' argument after a key
rotation. Existing credentials are verified and left alone; the region
entry is self-healed to the default when missing. ~/.aws is owned by
this flow - credential entry writes the [default] profile only and does
not preserve other profiles.
"""

import os
import sys
from pathlib import Path

import boto3

AWS_DIR = Path.home() / ".aws"
CREDENTIALS_FILE = AWS_DIR / "credentials"
AWS_CONFIG_FILE = AWS_DIR / "config"


def get_region() -> str:
    region = os.environ.get("AWS_REGION") or os.environ.get("AWS_DEFAULT_REGION")
    if not region and AWS_CONFIG_FILE.exists():
        for line in AWS_CONFIG_FILE.read_text().splitlines():
            if line.strip().startswith("region"):
                parts = line.split("=", 1)
                if len(parts) == 2 and parts[1].strip():
                    region = parts[1].strip()
    return region or "us-east-1"


def aws_credentials_work() -> bool:
    try:
        boto3.client("sts", region_name=get_region()).get_caller_identity()
        return True
    except Exception:
        return False


def prompt_aws_credentials(reconfigure: bool = False) -> None:
    if not sys.stdin.isatty():
        sys.exit("AWS credential entry requires an interactive terminal. Re-run from a TTY.")
    if reconfigure:
        print("Enter the new AWS credentials. Existing ones will be replaced.")
    else:
        print("AWS credentials not found.")
        print("An IAM access key is required to unlock SOPS-encrypted config.")
    access_key_id = input("AWS Access Key ID: ").strip()
    secret_access_key = input("AWS Secret Access Key: ").strip()
    region = input("AWS Region [us-east-1]: ").strip() or "us-east-1"

    if not access_key_id or not secret_access_key:
        retry = "task workspace:aws:auth:rotate" if reconfigure else "task workspace:aws:auth"
        sys.exit(f"Credentials cannot be blank. Re-run '{retry}' to try again.")

    AWS_DIR.mkdir(mode=0o700, exist_ok=True)
    os.chmod(AWS_DIR, 0o700)
    CREDENTIALS_FILE.write_text(
        "[default]\n"
        f"aws_access_key_id = {access_key_id}\n"
        f"aws_secret_access_key = {secret_access_key}\n"
    )
    AWS_CONFIG_FILE.write_text(f"[default]\nregion = {region}\n")
    for path in (CREDENTIALS_FILE, AWS_CONFIG_FILE):
        os.chmod(path, 0o600)


def ensure_region() -> None:
    """Keep ~/.aws/config self-describing: a missing region entry is
    written with the default so every tool reads the same value instead
    of silently falling back per-tool."""
    if AWS_CONFIG_FILE.exists():
        for line in AWS_CONFIG_FILE.read_text().splitlines():
            if line.strip().startswith("region"):
                return
    AWS_DIR.mkdir(mode=0o700, exist_ok=True)
    AWS_CONFIG_FILE.write_text(f"[default]\nregion = {get_region()}\n")
    os.chmod(AWS_CONFIG_FILE, 0o600)
    print(f"AWS region missing from ~/.aws/config; wrote default ({get_region()}).")


def main() -> None:
    rotate = len(sys.argv) > 1 and sys.argv[1] == "rotate"

    if rotate:
        print("=== AWS Authentication ===\n")
        try:
            prompt_aws_credentials(reconfigure=True)
        except KeyboardInterrupt:
            sys.exit("\nCancelled. Existing credentials left unchanged.")
        if not aws_credentials_work():
            sys.exit("The new credentials are not valid. Existing credentials were replaced - re-run if this was a mistake.")
        print("AWS credentials updated and verified.\n")
        ensure_region()
        return

    if not aws_credentials_work():
        try:
            prompt_aws_credentials()
        except KeyboardInterrupt:
            sys.exit("\nCancelled. No credentials written.")
        if not aws_credentials_work():
            sys.exit("AWS credentials are still not valid. Check the keys and re-run.")
    print("AWS credentials verified.")
    ensure_region()


if __name__ == "__main__":
    main()
