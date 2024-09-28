#!/bin/bash

# Log the start of the printer script
echo "$(date): bosBASE.sh started." >> bosAPP/bosPAGE/bosLOGS.txt

# Global commands that will always print on line 20
global_commands=(".exit" ".back" ".menu")

# Function to print a line with padding
print_padded_line() {
    local content="$1"
    local total_columns=89
    printf " %-$(($total_columns - 2))s \n" "$content"
}

# Function to print an empty padded line (for spacing/padding)
print_empty_line() {
    local total_columns=89
    printf "%-${total_columns}s\n" " "
}

# Function to refresh the display
bosBASE_refresh() {
    clear
    local title="$1"
    local version="v0.4"
    local display_content=("${!2}")  # Pass display lines as an array
    local menu_list=("${!3}")        # Pass menu items as an array
    local command="$4"

    # Line 1: Padding
    print_empty_line

    # Line 2: Title and Version
    printf " %-$(($(tput cols) - 15))s %9s \n" "$title" "$version"

    # Line 3: Padding
    print_empty_line

    # Lines 4-16: Display content (DISP)
    for ((i=0; i<13; i++)); do
        if [[ $i -lt ${#display_content[@]} ]]; then
            print_padded_line "${display_content[$i]}"
        else
            print_padded_line "DISP"
        fi
    done

    # Line 17: Padding
    print_empty_line

    # Lines 18-19: Menu items (Page-specific)
    local current_line=18
    local menu_line=""

    for menu_item in "${menu_list[@]}"; do
        if [[ -z "$menu_line" ]]; then
            menu_line="$menu_item"
        else
            menu_line="$menu_line, $menu_item"
        fi

        # Print menu items on lines 18 and 19
        if [[ ${#menu_line} -ge 89 || $current_line -ge 19 ]]; then
            print_padded_line "$menu_line"
            menu_line=""
            current_line=$((current_line + 1))
        fi
    done

    # Print remaining menu items if there's space left
    if [[ -n "$menu_line" && $current_line -le 19 ]]; then
        print_padded_line "$menu_line"
    fi

    # Ensure line 19 has padding if no content fills it
    if [[ $current_line -eq 18 ]]; then
        print_empty_line
    fi

    # Line 20: Global commands
    local global_line=""
    for global_command in "${global_commands[@]}"; do
        if [[ -z "$global_line" ]]; then
            global_line="$global_command"
        else
            global_line="$global_line, $global_command"
        fi
    done

    print_padded_line "$global_line"

    # Line 21: Padding
    print_empty_line

    # Line 22: Show last command result (bos.CTRL)
    print_padded_line "bos.CTRL:>> $command"

    # Line 23: Input prompt (bos.INPT)
    printf " bos.INPT:<< "
}

# Ensure that bosBASE_refresh has its closing bracket
# Function to capture and process user input
bosBASE_main_menu() {
    local title="Main Menu"
    local display_lines=("Welcome to the app!" "Choose an option from the menu:")
    local menu_items=("page" "syst")  # Page-specific options
    local user_input=""

    while true; do
        # Refresh the screen with the title, display, and menu
        bosBASE_refresh "$title" display_lines[@] menu_items[@] "$user_input"

        # Capture user input
        read -p " " user_input  # No extra input prompt after this

        # Handle user input and send to respective functions
        case "$user_input" in
            "syst")
                bosSYST_main  # Call system settings page function
                ;;
            "page")
                bosPMGR_main  # Call page manager function
                ;;
            ".exit" | ".back" | ".menu")
                echo "$(date): Exiting program." >> bosAPP/bosPAGE/bosLOGS.txt
                clear
                exit 0
                ;;
            *)
                echo "$(date): Invalid input '$user_input'" >> bosAPP/bosPAGE/bosLOGS.txt
                user_input="Invalid input. Try again."
                ;;
        esac
    done
}

# Log the successful setup of bosBASE.sh
echo "$(date): bosBASE.sh setup complete." >> bosAPP/bosPAGE/bosLOGS.txt
