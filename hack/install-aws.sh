#!/usr/bin/env bash

# Install AWS CLI v2 and Configure AWS Credentials Script
# --------------------------------------------------------
# The purpose of this script is to install the AWS CLI v2 (https://aws.amazon.com/cli/) 
# and configure the AWS config and credentials files with the provided user input.

# AWS CLI install directory
AWS_CLI_INSTALL_DIR="/usr/local/bin"

# Function to check for missing tools (curl is required for AWS CLI installation)
check_missing_tools() {
    REQUIRED_TOOLS=("curl" "unzip")
    MISSING_TOOLS=()
    
    echo "Checking for required dependencies..."
    for tool in "${REQUIRED_TOOLS[@]}"
    do
        if ! command -v "$tool" &> /dev/null
        then
            MISSING_TOOLS+=("$tool")
        fi
    done
}

# Function to install missing tools
install_missing_tools() {
    for tool in "${MISSING_TOOLS[@]}"
    do
        echo "Installing $tool..."
        sudo apt update && sudo apt install -y "$tool"
    done
}

# Function to install AWS CLI v2
install_aws_cli_v2() {
    if ! command -v "aws" &> /dev/null
    then
        echo "AWS CLI v2 not found. Beginning installation..."
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        unzip awscliv2.zip
        sudo ./aws/install --bin-dir $AWS_CLI_INSTALL_DIR
        echo "AWS CLI v2 installation completed."
        rm -rf awscliv2.zip aws
    else
        echo "AWS CLI is already installed on the system."
    fi
}

# Function to configure AWS CLI with user-provided credentials
configure_aws_cli() {
    echo "Starting AWS CLI configuration..."

    while true
    do
        read -rep "Enter your AWS Access Key ID: " AWS_ACCESS_KEY_ID
        read -rep "Enter your AWS Secret Access Key: " AWS_SECRET_ACCESS_KEY
        read -rep "Enter your AWS Default Region (e.g., us-east-1): " AWS_REGION
        read -rep "Enter your AWS Output Format (json, text, or table): " AWS_OUTPUT_FORMAT

        echo "You have entered the following details:"
        echo "AWS Access Key ID: $AWS_ACCESS_KEY_ID"
        echo "AWS Secret Access Key: **************"
        echo "AWS Region: $AWS_REGION"
        echo "AWS Output Format: $AWS_OUTPUT_FORMAT"

        read -rep "Is this information correct? (Y/n): " response
        RESPONSE=${response:-Y}

        if [[ $RESPONSE =~ ^([yY][eE][sS]|[yY])$ ]]; then
            mkdir -p ~/.aws

            # Configure the credentials file
            cat <<EOF > ~/.aws/credentials
[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
EOF

            # Configure the config file
            cat <<EOF > ~/.aws/config
[default]
region = $AWS_REGION
output = $AWS_OUTPUT_FORMAT
EOF

            echo "AWS CLI configuration completed successfully."
            break
        else
            echo "Let's try entering the information again."
        fi
    done
}

# Main script logic
check_missing_tools

if [ ${#MISSING_TOOLS[@]} -eq 0 ]; then
    echo "All required dependencies are already installed. Proceeding with AWS CLI v2 installation..."
else
    echo "The following dependencies are required but not installed:"
    for tool in "${MISSING_TOOLS[@]}"; do
        echo "- $tool"
    done

    while true
    do
        read -rep "Would you like to install all missing dependencies now? (Y/n): " response
        RESPONSE=${response:-Y}
        if [[ $RESPONSE =~ ^([yY][eE][sS]|[yY])$ ]]; then
            install_missing_tools
            echo "All required dependencies have been installed."
            break
        elif [[ $RESPONSE =~ ^([nN][oO]|[nN])$ ]]; then
            echo "Installation aborted. AWS CLI cannot be installed without the required dependencies."
            exit
        else
            echo "Invalid response."
        fi
    done
fi

install_aws_cli_v2
configure_aws_cli
