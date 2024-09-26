from blessed import Terminal

term = Terminal()

# Fixed size
MAX_WIDTH = 78
MAX_HEIGHT = 28

# Version info in top-right corner
VERSION = "v.2"

# Menu options for the title screen (with action letters in brackets)
menu_options = [
    "{c}ODE",
    "e{x}it",
    "{J}OURNAL",
    "{T}ODO",
    "{S}ETTINGS",
    "{H}ELP",
    "{A}BOUT",
]

# Command to menu action mapping
command_map = {
    "c": "CODE",
    "x": "EXIT",
    "j": "JOURNAL",
    "t": "TODO",
    "s": "SETTINGS",
    "h": "HELP",
    "a": "ABOUT",
}

def display_version():
    """Displays the version number in the top-right corner."""
    version_x = MAX_WIDTH - len(VERSION) - 2
    print(term.move_xy(version_x, 0) + term.on_white(term.black(VERSION)))

def display_menu():
    """Displays the menu options horizontally with wrapping, and leaves first two lines blank for aesthetics."""
    width = MAX_WIDTH
    current_line = 21  # Leave two lines blank for whitespace aesthetics
    current_pos = 0  # Track the current horizontal position

    for option in menu_options:
        formatted_option = f"   {option}   "
        if current_pos + len(formatted_option) > width:
            # Wrap to the next line if it exceeds width
            current_line += 1
            current_pos = 0
            if current_line > 25:  # Stop if we run out of space (bottom line is reserved)
                break
        print(term.move_xy(current_pos, current_line) + formatted_option)
        current_pos += len(formatted_option)

    # Debugging/status line (line 27)
    print(term.move_xy(0, 26) + term.red("DEBUG/STATUS LINE: Ready"))

def main():
    """Main function to display the title screen and accept input."""
    # Clear screen and display the version once
    print(term.clear)
    display_version()

    while True:
        # Display the menu, but don't reprint the version
        display_menu()

        # Move command prompt to the very last line (line 28)
        print(term.move_xy(0, 27) + "COMMAND PROMPT:>> ", end="")

        # Capture user input directly on the last line
        user_input = input().strip().lower()

        # Check if the input matches any command from the menu
        if user_input in command_map:
            print(term.move_xy(0, 26) + term.red(f"DEBUG/STATUS LINE: You selected {command_map[user_input]}"))
            if user_input == "x":  # Exit command
                print(term.move_xy(0, 26) + term.red("Exiting..."))
                break
        else:
            print(term.move_xy(0, 26) + term.red(f"DEBUG/STATUS LINE: Invalid command '{user_input}'"))

if __name__ == "__main__":
    main()
