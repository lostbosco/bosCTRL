#!/bin/bash



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

# Function to print the menu (lines 20–23)
print_menu() {
    for i in {20..23}; do
        printf '%s\n' "Menu line $i (Placeholder)"
    done
    print_border  # Line 24 is a border
}

# Function to print the input and output lines (bos. lines)
print_bos_lines() {
    printf 'bos.DBUG:>>%s\n' "$debug_log"  # Debug log line (line 25)
    printf 'bos.CTRL:>>%s\n' "$ctrl_log"   # Control log line (line 26)
    printf 'bos.INPT:<< '   # Input prompt (line 27)
}

# Function to capture user input with horizontal scrolling
capture_input() {
    # Move cursor to line 27, column 12 (start after "bos.INPT:<< ")
    tput cup 26 12

    # Read user input with horizontal scrolling (no wrapping)
    read -e user_input
}

# Function to process input and update logs
process_input() {
    if [[ "$user_input" == "exit" ]]; then
        exit_program=true
    else
        debug_log="You entered: '$user_input'"
        ctrl_log="Processed input: $user_input"
    fi
}

# Main function to print and capture input
main() {
    clear_screen  # Clear the terminal screen
    print_version_line
    print_title_block
    print_content_block
    print_menu
    print_bos_lines  # Print input prompt and logs
    capture_input  # Wait for user input
    process_input  # Process user input and update bos.DBUG and bos.CTRL lines
}

# Function to clear the screen
clear_screen() {
    clear
}

# Loop to keep the screen active, break when "exit" is entered
exit_program=false
while [[ "$exit_program" == false ]]; do
    main
done


cleanup
