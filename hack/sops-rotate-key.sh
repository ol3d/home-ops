#!/bin/bash

# Define the paths to the old/current and new age key files
SOPS_AGE_KEY_FILE_NEW=~/.config/sops/age/keys.txt

# Define the commands to decrypt and encrypt the file
# DECRYPT_COMMAND="sops --decrypt --age \$(cat $SOPS_AGE_KEY_FILE |grep -oP \"public key: \K(.*)\") --encrypted-regex '^(data|stringData)$' --in-place"
DECRYPT_COMMAND="sops -d --kms "arn:aws:kms:us-east-1:707904332389:key/a7f77b88-3d50-474a-a8a9-59aa09144204" --in-place"
ENCRYPT_COMMAND="sops -e --age \$(cat $SOPS_AGE_KEY_FILE_NEW |grep -oP \"public key: \K(.*)\") --in-place"

# Find all the *.sops.yaml files recursively in the current directory and apply the decrypt and encrypt commands to them
find . -name "*.sops.yml" -type f -print0 | while IFS= read -r -d '' file; do
    eval "$DECRYPT_COMMAND $file"
    eval "$ENCRYPT_COMMAND $file"
done

# Find all the *.sops.yaml files recursively in the current directory and apply the decrypt and encrypt commands to them
find . -name "*.sops.yaml" -type f -print0 | while IFS= read -r -d '' file; do
    eval "$DECRYPT_COMMAND $file"
    eval "$ENCRYPT_COMMAND $file"
done
