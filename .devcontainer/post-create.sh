#!/usr/bin/env bash
set -euo pipefail

# Make volume-mounted directories owned by vscode (they mount as root).
sudo chown -R vscode:vscode /home/vscode/.local /home/vscode/.aws 2>/dev/null || true

# Install pre-commit hooks into the repo.
pre-commit install

echo ""
echo "Workspace container is up."
echo "If this is a first run, configure it with:  task bootstrap"
