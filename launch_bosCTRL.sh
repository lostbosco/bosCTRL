#!/bin/bash

# Define the bos_CORE file path with .txt extension
core_file="bos_CORE.txt"

# Ensure bos_CORE file exists
if [ ! -f "$core_file" ]; then
    touch "$core_file"
    echo -e "# bos_CORE file\n\n# ---{DEBUG LOG}---\nDEBUG_LOG_START\nDEBUG_LOG_END\n\n# ---{INPT to DISP}---\nINPT_TO_DISP_START\nINPT_TO_DISP_END\n\n# ---{DISP to INPT}---\nDISP_TO_INPT_START\nDISP_TO_INPT_END" > "$core_file"
fi

# Function to log to bos_CORE
log_to_core() {
    local log_message="$1"
    sed -i "/DEBUG_LOG_START/,/DEBUG_LOG_END/c\DEBUG_LOG_START\n$log_message\nDEBUG_LOG_END" "$core_file"
}

# Log script start in bos_CORE
log_to_core "Script started."

# Open the first Konsole window for input using the "bos.INPT" profile
konsole --profile bos.INPT --hold -e ./bos_input_handler.sh & disown

# Open the second Konsole window for display using the "bos.DISP" profile
konsole --profile bos.DISP --hold -e ./bos_display.sh & disown

# Log that the windows have been opened
log_to_core "bos.INPT and bos.DISP windows launched."
