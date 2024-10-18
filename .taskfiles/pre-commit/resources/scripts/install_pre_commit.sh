#!/usr/bin/env bash

# Install pre-commit Script
# ------------------------------------
# This script installs pre-commit onto the system.

# Function to check if pre-commit is installed
check_pre_commit_installed() {
    if command -v pre-commit &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to install pre-commit using pip
install_pre_commit() {
    echo "Installing pre-commit..."
    sudo apt update
    sudo apt install -y python3-pip
    pip3 install pre-commit --user
    echo "pre-commit installed successfully."
}

# Function to get the latest version of pre-commit from PyPi
get_latest_pre_commit_version() {
    pip3 install --upgrade pip &> /dev/null
    latest_version=$(pip3 show pre-commit | grep -i 'version' | awk '{print $2}')
    if [ -z "$latest_version" ]; then
        latest_version=$(pip3 install pre-commit --dry-run | grep -oP '(?<=pre-commit )[0-9]+(\.[0-9]+)+')
    fi
    echo "$latest_version"
}

# Function to check if the installed version is out of date
check_version() {
    installed_version=$(pre-commit --version | awk '{print $3}')
    latest_version=$(get_latest_pre_commit_version)

    if [ -z "$latest_version" ]; then
        echo "Could not retrieve the latest version."
        return 1
    fi

    if [ "$installed_version" != "$latest_version" ]; then
        echo "Pre-commit is out of date. Installed version: $installed_version, Latest version: $latest_version."
        return 1
    else
        echo "Pre-commit is up to date (version $installed_version)."
        return 0
    fi
}

# Function to prompt for an upgrade
upgrade_pre_commit() {
    read -p "Would you like to upgrade pre-commit to version $latest_version? (y/n): " choice
    if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
        echo "Upgrading pre-commit..."
        pip3 install --upgrade pre-commit --user
        echo "Pre-commit upgraded to version $latest_version."
    else
        echo "Skipping upgrade."
    fi
}

# Main script logic
if check_pre_commit_installed; then
    echo "Pre-commit is already installed."
    if check_version; then
        exit 0
    else
        upgrade_pre_commit
    fi
else
    install_pre_commit
    check_version
fi
