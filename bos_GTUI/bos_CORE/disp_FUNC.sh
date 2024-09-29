# /home/deck/BOSctrl/base/bos_GTUI

#!/bin/bash

# Define the absolute path for the pipe location
PROJECT_ROOT="/home/deck/BOSctrl/base/bos_GTUI"  # Replace this with the full path to your project
PIPE="$PROJECT_ROOT/bos_CORE/bos_pipe"

# Ensure the pipe exists
if [[ ! -p "$PIPE" ]]; then
    echo "Creating pipe at $PIPE"
    mkfifo "$PIPE"
else
    echo "Pipe found at $PIPE"
fi

# Launch the display terminal (trml_DISP) to handle the output
echo "Launching trml_DISP (Display Terminal) with bosCTRL profile..."
konsole --profile bosCTRL --noclose -e "tail -f $PIPE" &

# disp_print function: Receives data packet from core_FUNC and prints it
function disp_print() {
    while read -r line < "$PIPE"; do
        # Log data being received and processed
        echo "Received new data packet for display: $line (trml_INPT)"

        # Clear the terminal before printing the new content in trml_DISP
        clear
        # Assume the data_packet is sent as a single line split by delimiters (for simplicity)
        IFS='|' read -r page_title menu_options user_results log_messages <<< "$line"

        # Print the page title in trml_DISP
        echo "==== $page_title ===="
        echo

        # Print the menu options in trml_DISP
        echo "Menu Options:"
        echo "$menu_options"
        echo

        # Print the user results (results of user input processing) in trml_DISP
        echo "Results:"
        echo "$user_results"
        echo

        # Print any log messages in trml_DISP
        echo "Log Messages:"
        echo "$log_messages"
        echo
    done
}

# rfsh_disp function: Simply runs disp_print when new data arrives
function rfsh_disp() {
    echo "Waiting for data to refresh display... (trml_INPT)"
    disp_print
}

# Start the display refresh loop
rfsh_disp
