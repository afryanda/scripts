#!/bin/bash

# Define the source directory to monitor
SOURCE_DIR="$HOME/Downloads/mps"

# Define the destination directory where you want to copy the file
DEST_DIR="$HOME/Music"

status="Not Running"

# Function to update the status message
update_status() {
    if [[ "$status" == "Not Running" ]]; then
        status="Running"
    else
        status="Not Running"
    fi
    dunstify "Script Status" "The script is currently $status."
}

# Display the initial status message
update_status

# Wait for an MP3 file to be created in the source directory
while true; do
    # Use inotifywait to monitor the source directory for file creations
    file=$(inotifywait -e create --format "%f" "$SOURCE_DIR" --quiet)

    # Check if the newly created file is an MP3 file
    if [[ "$file" == *.mp3 ]]; then
        # Copy the MP3 file to the destination directory
        cp "$SOURCE_DIR/$file" "$DEST_DIR"

        # Send a desktop notification using dunstify
        dunstify "New MP3 File" "A new MP3 file '$file' was added to the directory."
    fi

    # Update the status message
    update_status
done
