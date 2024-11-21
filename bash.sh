#!/bin/bash

# Define the root directory
ROOT_DIR="/mnt/c/Users/ASUS"  # Root directory for the ASUS folder

# Function to check if the path is within the root directory or its subdirectories
is_within_root() {
    local path=$1
    if [[ "$path" == $ROOT_DIR* ]]; then
        return 0  # Inside the root directory
    else
        return 1  # Outside the root directory
    fi
}

# Function to clear the clipboard (emulating blocking the paste)
clear_clipboard() {
    echo "Blocked paste operation outside the root directory."
    /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -Command "Set-Clipboard ''"  # Clear clipboard
}

# Function to monitor clipboard and block unauthorized paste
monitor_clipboard() {
    while true; do
        # Get clipboard content using the full path to powershell.exe
        clipboard_content=$(/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -Command "Get-Clipboard")

        echo "Clipboard content: $clipboard_content"  # Debugging output

        # Check if the clipboard contains a valid file path
        if [[ -n "$clipboard_content" && "$clipboard_content" =~ ^[A-Za-z]:\\.* ]]; then
            echo "Detected file in clipboard: $clipboard_content"

            # If file is within the root directory, allow it, otherwise block it
            if is_within_root "$clipboard_content"; then
                echo "File inside root directory: $clipboard_content"
            else
                clear_clipboard  # Block paste if it's outside the root directory
            fi
        else
            echo "Clipboard does not contain a valid file path or is empty."
        fi

        # Sleep for a while before checking again
        sleep 2  # Check clipboard every 2 seconds
    done
}

# Start monitoring the clipboard
echo "Monitoring clipboard..."
monitor_clipboard
