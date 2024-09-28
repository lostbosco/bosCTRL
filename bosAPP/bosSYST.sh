#!/bin/bash

# Log the start of the system settings script
echo "$(date): bosSYST.sh started." >> bosAPP/bosPAGE/bosLOGS.txt

# Function to send system settings data to bosBASE for printing
bosSYST_main() {
    local title="System Settings"
    local display_lines=("This is the system settings page." "Here you can manage system configurations.")
    local menu_items=("page" ".back" ".exit")  # Sending the page code format for menus
    local user_input=""

    # Refresh the screen by sending data to bosBASE
    bosBASE_refresh "$title" display_lines[@] menu_items[@] "$user_input"

    # Handle user input (this part will call other functions but not print)
    read -p "bos.INPT:<< " user_input

    case "$user_input" in
        "page")
            bosPMGR_main  # Call page manager for editing pages
            ;;
        ".back")
            bosBASE_main_menu  # Return to the main menu
            ;;
        ".exit")
            echo "$(date): Exiting program from system settings." >> bosAPP/bosPAGE/bosLOGS.txt
            clear
            exit 0
            ;;
        *)
            echo "$(date): Invalid input '$user_input' in system settings." >> bosAPP/bosPAGE/bosLOGS.txt
            bosSYST_main  # Reprint system settings on invalid input
            ;;
    esac
}

# Log the successful setup of bosSYST.sh
echo "$(date): bosSYST.sh setup complete." >> bosAPP/bosPAGE/bosLOGS.txt
