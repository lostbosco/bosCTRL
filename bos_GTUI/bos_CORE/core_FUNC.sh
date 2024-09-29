#!/bin/bash

# Full path to the pipe
PIPE="/home/deck/BOSctrl/base/bos_GTUI/bos_CORE/bos_pipe"

# Clear logs at the start of the app
function clear_logs() {
    echo "" > ./bos_CORE/bos_LOGS.txt
    echo "Logs cleared. (trml_DISP)"
}

clear_logs  # Call the function at the start of the script

# Capture user input (switching to trml_DISP for input)
function bos_INPT() {
    echo -n "bos_INPT:<< "  # Prompt for user input
    read user_input  # Read the user's input

    # Log the input for debugging purposes
    echo "Input received: $user_input (trml_DISP)" >> ./bos_CORE/bos_LOGS.txt
    echo "Captured input: $user_input (trml_DISP)"

    # Send the input and results to the pipe for display
    echo "User input: $user_input" > "$PIPE"  # Send the input to the display terminal
}

# Main loop to capture input
while true; do
    bos_INPT  # Continuously capture input for testing

    if [[ $user_input =~ ^\/ ]]; then
        break
    fi
done
