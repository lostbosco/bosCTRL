#!/bin/bash

# Disable text wrapping in the terminal
tput rmam

# Function to print a border (empty line)
print_border() {
    printf '%78s\n' ""  # Print an empty border line
}

# Function to print the version number on the first line
print_version_line() {
    local version="v.3"
    printf '%73s%s\n' "" "$version"  # 73 spaces to keep v.3 at the far right
}

# Function to print the title block on line 2 (currently placeholder text)
print_title_block() {
    printf '%s\n' "Title Block (Placeholder)"
}

# Function to print the content lines (lines 4–18)
print_content_block() {
    print_border  # Line 3 is a border
    for i in {4..18}; do
        printf '%s\n' "Content line $i (Placeholder)"
    done
    print_border  # Line 19 is a border
}

# Enable text wrapping in the terminal for the menu section (lines 20–23)
enable_wrapping() {
    tput smam  # This enables wrapping
}

# Function to print the menu (lines 20–23, wrapping allowed)
print_menu() {
    enable_wrapping
    for i in {20..23}; do
        printf '%s\n' "Menu line $i (Placeholder)"
    done
    print_border  # Line 24 is a border
    tput rmam  # Disable wrapping again after the menu is printed
}

# Function to print the input and output lines (bos. lines)
print_bos_lines() {
    printf 'bos.DBUG:>>\n'  # Debug log line (line 25)
    printf 'bos.CTRL:>>\n'  # Control log line (line 26)
    printf 'bos.INPT:<< '   # Input prompt (line 27)
}

# Function to print the bottom border (line 28)
print_bottom_border() {
    print_border  # Line 28 is a border
}

# Function to capture user input without reprinting the prompt
capture_input() {
    # Move the cursor back to line 27 before capturing input to keep it in place
    tput cup 26 12  # This moves the cursor to line 27 after the prompt
    read user_input  # Capture user input on line 27
}

# Main function to call all other functions in order (top to bottom)
main() {
    clear_screen  # Clear the screen BEFORE printing
    print_version_line
    print_title_block
    print_content_block
    print_menu
    print_bos_lines  # This prints all the bos. lines, including input prompt
    print_bottom_border
    capture_input  # Capture the user input after printing everything
}

# Function to clear the screen
clear_screen() {
    clear  # Clear the terminal
}

# Infinite loop to keep the title screen active
while true; do
    main
done

# Reset terminal wrapping after the program finishes
cleanup() {
    tput smam
}
cleanup
