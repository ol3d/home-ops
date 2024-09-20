#!/usr/bin/env bash

# Install Dependencies and Task Script
# ------------------------------------
# This script checks for required dependencies (curl) and installs them if missing.
# After the required tools are installed, it prompts the user to install Task (https://taskfile.dev/).

# List of required dependencies
REQUIRED_TOOLS=("curl")
MISSING_TOOLS=()

# Function to check for missing tools
check_missing_tools() {
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

# Function to install Task if not present
install_task() {
    # Default directory for Task installation
    TASK_DIR="/usr/local/bin"

    if ! command -v "task" &> /dev/null
    then
        echo $'Task was not found on your system. Beginning installation...\n'
        while true
        do
            read -rep $'Install Task into /usr/local/bin directory? (Y/n)\n' response
            RESPONSE=${response:-Y}
            if [[ $RESPONSE =~ ^([yY][eE][sS]|[yY])$ ]]; then
                sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b $TASK_DIR
                echo "Task installation completed."
                exit
            elif [[ $RESPONSE =~ ^([nN][oO]|[nN])$ ]]; then
                while true
                do
                    read -rep "Please enter the directory in which you would like to download Task: " directory
                    TASK_DIR=${directory}
                    echo "You have specified $TASK_DIR as the download directory. Is this correct? (Y/n)"
                    read verify
                    VERIFY=${verify:-Y}
                    if [[ $VERIFY =~ ^([yY][eE][sS]|[yY])$ ]]; then
                        mkdir -p "$TASK_DIR"
                        sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d -b $TASK_DIR
                        exit
                    elif [[ $VERIFY =~ ^([nN][oO]|[nN])$ ]]; then
                        :
                    elif [[ $VERIFY =~ ^([eE][xX][iI][tT])$ ]]; then
                        exit
                    else
                        echo "Invalid response."
                    fi
                done
                exit
            elif [[ $RESPONSE =~ ^([eE][xX][iI][tT])$ ]]; then
                exit
            else
                echo "Invalid response."
            fi
        done
    else
        echo "Task is already installed on the system. Exiting..."
        exit
    fi
}

check_missing_tools

if [ ${#MISSING_TOOLS[@]} -eq 0 ]; then
    echo "All required dependencies are already installed. Task is ready to be installed."
else
    echo "The following dependencies are required but not installed:"
    for tool in "${MISSING_TOOLS[@]}"; do
        echo "- $tool"
    done

    while true
    do
        read -rep $'\nWould you like to install all the missing dependencies now? (Y/n): ' response
        RESPONSE=${response:-Y}
        if [[ $RESPONSE =~ ^([yY][eE][sS]|[yY])$ ]]; then
            install_missing_tools
            echo "All required dependencies have been installed. Task is now ready to be installed."
            break
        elif [[ $RESPONSE =~ ^([nN][oO]|[nN])$ ]]; then
            echo "Installation aborted. Task cannot be installed without the required dependencies."
            exit
        else
            echo "Invalid response."
        fi
    done
fi

install_task
