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
    print_border  # Line 24 is the empty border
    tput rmam  # Disable wrapping again after the menu is printed
}

# Function to cdprint the input lines (bos.INPT on line 27)
print_input_lines() {
    printf 'bos.DBUG:>>\n'  # Debug log line (now line 25)
    printf 'bos.CTRL:>>\n'  # Control info line (now line 26)
    printf 'bos.INPT:<< '   # Input line for user (line 27)
}

# Function to print the bottom border (line 28)
print_bottom_border() {
    print_border
}

# Function to capture user input
capture_input() {
    read -p "bos.INPT:<< " user_input  # Capture user input correctly
}

# Main function to call all other functions in order (top to bottom)
main() {
    print_version_line
    print_title_block
    print_content_block
    print_menu
    print_input_lines
    print_bottom_border
    capture_input  # Capture the user input while printing the correct prompt
    clear_screen  # Clear the screen AFTER capturing input
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
