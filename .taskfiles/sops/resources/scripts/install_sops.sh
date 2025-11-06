#!/bin/bash

# Exit script if any command fails
set -e

# Define the SOPS version to install
SOPS_VERSION="v3.7.3"

# Define the AGE key location (replace with your actual key path)
AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt"

# Function to install dependencies
install_dependencies() {
  echo "Installing dependencies..."
  sudo apt-get update
  sudo apt-get install -y wget
}

# Function to install Mozilla SOPS
install_sops() {
  echo "Downloading and installing Mozilla SOPS..."
  wget "https://github.com/mozilla/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.linux" -O /usr/local/bin/sops
  sudo chmod +x /usr/local/bin/sops

  # Verify SOPS installation
  if command -v sops &>/dev/null; then
    echo "SOPS installed successfully."
  else
    echo "SOPS installation failed. Exiting."
    exit 1
  fi
}

# Function to install AGE
install_age() {
  echo "Downloading and installing AGE..."
  wget "https://github.com/FiloSottile/age/releases/download/v1.0.0/age-v1.0.0-linux-amd64.tar.gz" -O age.tar.gz
  tar -xzf age.tar.gz
  sudo mv age/age /usr/local/bin/
  sudo mv age/age-keygen /usr/local/bin/
  sudo chmod +x /usr/local/bin/age /usr/local/bin/age-keygen
  rm -rf age.tar.gz age/

  # Verify AGE installation
  if command -v age &>/dev/null; then
    echo "AGE installed successfully."
  else
    echo "AGE installation failed. Exiting."
    exit 1
  fi
}

# Function to configure AGE key for SOPS
configure_age() {
  echo "Configuring AGE key for SOPS..."

  # Check if AGE key file exists; if not, generate a new key
  if [ ! -f "$AGE_KEY_FILE" ]; then
    mkdir -p "$(dirname "$AGE_KEY_FILE")"
    age-keygen -o "$AGE_KEY_FILE"
    echo "New AGE key generated at $AGE_KEY_FILE"
  else
    echo "AGE key already exists at $AGE_KEY_FILE"
  fi

  # Export the AGE_RECIPIENTS environment variable so that SOPS can use it
  AGE_RECIPIENT=$(grep -o 'public key: .*' "$AGE_KEY_FILE" | awk '{print $3}')
  export SOPS_AGE_KEY_FILE="$AGE_KEY_FILE"
  export SOPS_AGE_RECIPIENTS="$AGE_RECIPIENT"

  echo "AGE key successfully configured for SOPS."
}

# Function to test SOPS decryption using AGE
test_sops_decryption() {
  TEST_FILE="test-encrypted-file.yaml"

  echo "Verifying SOPS decryption using AGE..."
  if sops -d "$TEST_FILE" &>/dev/null; then
    echo "SOPS is correctly set up with AGE."
  else
    echo "SOPS decryption test failed. Check AGE setup."
    exit 1
  fi
}

main() {
  install_dependencies
  install_sops
  install_age
  configure_age
  test_sops_decryption
  echo "SOPS installation and configuration complete using AGE."
}

main
