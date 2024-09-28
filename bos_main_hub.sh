#!/bin/bash

# Central Hub for managing both windows and handling communication
echo "Central Hub started. Launching input and display windows..."

# Open the input and display windows
konsole --profile bos.INPT --hold -e ./bos_input_handler.sh & disown
konsole --profile bos.DISP --hold -e ./bos_display.sh & disown

# Function to log actions and events to the hub window
log_to_hub() {
    local message="$1"
    echo "[HUB LOG] $message"
}

# Start the main loop for communication and logging
while true; do
    # Capture input from the input window (this should be redirected to this TTY)
    read -t 1 current_input

    if [[ -n "$current_input" ]]; then
        log_to_hub "Received input: '$current_input' from bos.INPT"
        current_input_processed="Processed input: $current_input"

        # Send processed input to display window (this will be shown)
        echo "$current_input_processed" > bos_display_data.txt
    fi

    sleep 1  # Wait before checking for updates again
done
