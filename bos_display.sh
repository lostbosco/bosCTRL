#!/bin/bash

# Disable user input and hide the cursor
stty -echo  # Disable user typing
tput civis  # Hide the cursor

# Function to display the content on bos.DISP window
display_content() {
    clear
    printf '□%69s' "v.3"  # Add an empty square in column 1 and shift the version number 69 spaces to the right
    echo ""  # Newline after version number
    echo "□ Title Block (Placeholder)"  # Add empty square in column 1

    # Display content lines (adjusted to 4–19)
    for i in {4..19}; do
        echo "□ Content line $i (Placeholder)"
    done

    echo ""
    echo "□ Menu line 20 (Placeholder)"
    echo "□ Menu line 21 (Placeholder)"
    echo "□ Menu line 22 (Placeholder)"
    echo "□ Menu line 23 (Placeholder)"
    echo ""  # Add a blank line after the menu

    # Read input from bos_CORE (INPT_TO_DISP section)
    display_log=$(sed -n '/INPT_TO_DISP_START/,/INPT_TO_DISP_END/p' bos_CORE | sed '1d;$d')

    # Display logs from the main program
    debug_log=$(cat /tmp/bos_debug_log 2>/dev/null)
    ctrl_log=$(cat /tmp/bos_ctrl_log 2>/dev/null)

    echo "□ bos.DBUG:>> $debug_log"
    echo "□ bos.CTRL:>> $ctrl_log"
    echo "□ Display: $display_log"
}

# Continuously update the display window
while true; do
    display_content
    sleep 1  # Adjust update frequency as needed
done

# Restore cursor visibility and input when the script exits
trap "tput cnorm; stty echo" EXIT
