#!/bin/bash

# Loop through all SOPS-encrypted files with .yaml or .yml extensions, excluding the .sops.yaml config file
find . \( -name '*.sops.yaml' -o -name '*.sops.yml' \) ! -path './.sops.yaml' | while IFS= read -r file; do
    echo "Updating keys in $file..."

    # Update keys based on the .sops.yaml file non-interactively
    sops updatekeys --yes "$file"

    echo "$file updated."
done
