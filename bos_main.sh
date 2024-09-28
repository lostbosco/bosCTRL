#!/bin/bash

# Clear debug log in bos_CORE on start
sed -i "/DEBUG_LOG_START/,/DEBUG_LOG_END/c\DEBUG_LOG_START\nProgram Started\nDEBUG_LOG_END" bos_CORE

# Main loop to handle user input and update display
while true; do
    # Check if input file exists and read the input
    if [[ -f /tmp/bos_input ]]; then
        user_input=$(cat /tmp/bos_input)
        rm /tmp/bos_input  # Remove the file after reading it

        # Process the input
        if [[ "$user_input" == "exit" ]]; then
            echo "Exiting..." > /tmp/bos_debug_log
            break
        else
            # Write to debug log
            sed -i "/DEBUG_LOG_START/,/DEBUG_LOG_END/c\DEBUG_LOG_START\nYou entered: '$user_input'\nDEBUG_LOG_END" bos_CORE
        fi

        sleep 1  # Wait for display window to refresh
    fi
    sleep 0.5  # Adjust timing as needed
done
