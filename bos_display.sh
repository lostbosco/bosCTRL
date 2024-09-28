#!/bin/bash

# Disable user input and hide the cursor
stty -echo
tput civis

# Function to display content from the hub
display_content() {
    clear
    echo "□ Title Block (Placeholder)"

    for i in {4..19}; do
        echo "□ Content line $i (Placeholder)"
    done

    echo ""
    echo "□ Menu line 20 (Placeholder)"

    # Read processed input from the file written by the hub
    display_log=$(cat bos_display_data.txt)

    echo "□ bos.DBUG:>>"
    echo "□ bos.CTRL:>> $display_log"  # Display the message sent by the hub
}

# Continuously update the display window
while true; do
    display_content
    sleep 1
done

# Restore cursor visibility and input when the script exits
trap "tput cnorm; stty echo" EXIT
