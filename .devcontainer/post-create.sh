#!/usr/bin/env bash
set -euo pipefail

# Make volume-mounted directories owned by vscode (they mount as root).
sudo chown -R vscode:vscode /home/vscode/.local /home/vscode/.aws 2>/dev/null || true

# Full bootstrap: credentials, config render, state backend. Tolerant so a
# failed interactive prompt (e.g. AWS auth) does not break container creation.
if task bootstrap; then
    echo ""
    echo "Workspace container is up and bootstrapped."
else
    echo ""
    echo "Bootstrap did not complete (likely a credential prompt)."
    echo "Finish configuring with:  task bootstrap"
fi
