#!/bin/bash

# Capture the hub's TTY (replace with the correct one)
hub_tty="/dev/pts/1"  # Update this to your actual hub's TTY

while true; do
    # Capture user input from the input window
    read -p "bos.INPT:<< " user_input

    # Send the input to the hub's TTY
    echo "$user_input" > "$hub_tty"

    # Check for 'exit' command
    if [[ "$user_input" == "exit" ]]; then
        echo "Exiting input handler..."
        break
    fi
done
