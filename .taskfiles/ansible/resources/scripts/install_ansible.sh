#!/bin/bash

# Accept the desired Ansible version as a parameter
ANSIBLE_VERSION="$1"

install_ansible() {
    echo "Installing Ansible version $ANSIBLE_VERSION..."
    sudo apt-get update && sudo apt-get --assume-yes install python3-pip
    sudo pip3 install ansible=="$ANSIBLE_VERSION"
}

install_latest_ansible_version() {
    echo "Installing the latest version of Ansible..."
    sudo apt-get update && sudo apt-get --assume-yes install python3-pip
    sudo pip3 install ansible
}

if [ -z "$ANSIBLE_VERSION" ] || [ "$ANSIBLE_VERSION" == "latest" ]; then
    echo "No specific Ansible version provided. Installing the latest version."
    install_latest_ansible_version
    exit 0
fi

# Check if Ansible is installed
if command -v ansible &> /dev/null; then
    INSTALLED_VERSION=$(ansible --version | head -n1 | awk '{print $2}')
    if [ "$INSTALLED_VERSION" != "$ANSIBLE_VERSION" ]; then
        echo "Upgrading Ansible to version $ANSIBLE_VERSION"
        sudo pip3 install --upgrade ansible=="$ANSIBLE_VERSION"
    else
        echo "Ansible version $ANSIBLE_VERSION is already installed"
    fi
else
    echo "Ansible is not installed. Installing version $ANSIBLE_VERSION."
    install_ansible
fi
