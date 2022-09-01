#!/usr/bin/env bash

# Install Task Script
# -------------------
# The purpose of this script is to install Task (https://taskfile.dev/) onto the system if it does not already exist.

# Default directory for Task installation $path
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
    echo "Task already exists on the system. Exiting..."
    exit
fi
