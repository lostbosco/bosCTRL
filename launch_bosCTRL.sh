#!/bin/bash

# Function to log to bos_CORE
log_to_core() {
    local log_message="$1"
    sed -i "/DEBUG_LOG_START/,/DEBUG_LOG_END/c\DEBUG_LOG_START\n$log_message\nDEBUG_LOG_END" bos_CORE
}

# Log script start in bos_CORE
log_to_core "Script started."

# Open the first Konsole window for input using the "bos.INPT" profile
konsole --profile bos.INPT --hold -e ./bos_input_handler.sh & disown

# Open the second Konsole window for display using the "bos.DISP" profile
konsole --profile bos.DISP --hold -e ./bos_display.sh & disown

# Log that the windows have been opened
log_to_core "bos.INPT and bos.DISP windows launched."
