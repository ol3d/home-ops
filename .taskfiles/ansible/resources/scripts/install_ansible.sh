#!/bin/bash

# Accept the desired Ansible version as a parameter
ANSIBLE_VERSION="$1"

install_latest_ansible_version() {
    echo "Installing the latest version of Ansible..."
    sudo apt-get update && sudo apt-get --assume-yes install ansible
}

if [ -z "$ANSIBLE_VERSION" ] || [ "$ANSIBLE_VERSION" == "latest" ]; then
    echo "No Ansible version specified."
    install_latest_ansible_version
    exit 0
fi

# Check if Ansible is installed
if command -v ansible &> /dev/null; then
    INSTALLED_VERSION=$(ansible --version | head -n1 | awk '{print $2}')
    if [ "$INSTALLED_VERSION" != "$ANSIBLE_VERSION" ]; then
        echo "Upgrading Ansible to version $ANSIBLE_VERSION"
        sudo apt-get update && sudo apt-get --assume-yes install ansible
    else
        echo "Ansible version $ANSIBLE_VERSION is already installed"
    fi
else
    echo "Installing Ansible..."
    sudo apt-get update && sudo apt-get --assume-yes install ansible
fi
