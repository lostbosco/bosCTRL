#!/bin/bash

while true; do
    # Capture user input
    read -p "bos.INPT:<< " user_input

    # Write input to bos_CORE in the INPT_TO_DISP section
    sed -i "/INPT_TO_DISP_START/,/INPT_TO_DISP_END/c\INPT_TO_DISP_START\n$user_input\nINPT_TO_DISP_END" bos_CORE

    # Check for 'exit' command to quit
    if [[ "$user_input" == "exit" ]]; then
        break
    fi
done
