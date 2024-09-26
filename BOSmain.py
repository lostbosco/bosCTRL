from blessed import Terminal

term = Terminal()

# Fixed size
MAX_WIDTH = 78
MAX_HEIGHT = 28

# Version info in top-right corner
VERSION = "v.2"

# Menu options with action letters in brackets
menu_options = [
    "{C}ODE",
    "{L}OG",
    "{S}YSTEM",
    "{D}EBUG",
    "e{X}IT"
]

# Command to menu action mapping
command_map = {
    "c": "CODE",
    "l": "LOG",
    "s": "SYSTEM",
    "d": "DEBUG",
    "x": "EXIT"
}

# === Output, Debug, and Command Prompt Lines ===
def display_bos_out(message="Waiting for input..."):
    """Displays the bos.OUT line for program status and clears it before displaying new content."""
    print(term.move_xy(0, 26) + term.clear_eol() + term.yellow(f"bos.OUT:>>  {message}"))

def display_bos_bug(message="Ready"):
    """Displays the bos.DBG line for debugging logs and clears it before displaying new content."""
    print(term.move_xy(0, 25) + term.clear_eol() + term.red(f"bos.DBG:>>  {message}"))

def display_bos_usr():
    """Displays the bos.USR line as the command prompt."""
    print(term.move_xy(0, 27) + term.clear_eol() + "bos.USR:<<  ", end="")

# === Version Display (displayed every time) ===
def display_version():
    """Displays the version number in the top-right corner every time it's called."""
    version_x = MAX_WIDTH - len(VERSION) - 2
    print(term.move_xy(version_x, 0) + term.on_white(term.black(VERSION)))  # Put version on line 1

# === Display Area ===
def display_area():
    """Displays the artwork, animations, or other information in the display section (lines 2-18)."""
    print(term.move_xy(0, 10) + term.cyan("=== Welcome to BOSctrl v.2 ==="))

# === Menu Area ===
def clear_full_display_area():
    """Clears the entire display area (including menu and empty space) to prevent duplicates."""
    for line in range(2, 25):  # Clear lines 2-25 (display and menu area)
        print(term.move_xy(0, line) + term.clear_eol())

def display_menu():
    """Displays the menu options horizontally with wrapping, and leaves first two lines blank for aesthetics."""
    width = MAX_WIDTH
    current_line = 19  # Menu starts at line 19 (lines 19-25 are reserved for the menu)
    current_pos = 0  # Track the current horizontal position

    clear_full_display_area()  # Clear everything, including menu area

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

def capture_user_input():
    """Capture user input from the bos.USR prompt."""
    print(term.move_xy(12, 27), end="")  # Move cursor to the end of 'bos.USR:<<  '
    return input().strip().lower()

def main():
    """Main function to display the title screen and accept input."""
    print(term.clear)

    while True:
        display_version()  # Re-display the version number every time
        display_area()  # Re-display the main artwork
        display_menu()  # Re-display the menu after processing input
        display_bos_out("Waiting for input...")
        display_bos_bug("Ready")
        display_bos_usr()

        # Capture user input from the command prompt
        user_input = capture_user_input()

        # Display the debug log with user input
        display_bos_bug(f"User input received: '{user_input}'")

        # Check if the input matches any command from the menu
        if user_input in command_map:
            display_bos_out(f"You selected {command_map[user_input]}")
            if user_input == "x":  # Exit command
                display_bos_out("Exiting...")
                break
        else:
            display_bos_out(f"Invalid command '{user_input}'")

if __name__ == "__main__":
    main()
