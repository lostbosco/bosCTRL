import threading
import random
import time
from blessed import Terminal

# Initialize terminal
term = Terminal()

# Fixed size for the terminal
MAX_WIDTH = 78
MAX_HEIGHT = 28

# Version info
VERSION = "v0.2"  # Four characters: 'v', '0', '.', '2'

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

# === Animation Settings Table ===
animation_settings = {
    'letters': ['b', 'o', 's', 'c'],  # Characters used in the Matrix effect
    'colors': ['blue', 'cyan', 'bright_blue', 'white'],  # Blue hues + white
    'delay': 0.05,  # Delay in seconds between refreshes
    'drop_chance': 0.02,  # Chance of new column drops starting
    'pulsing': True,  # Enables pulsing effect between bright and dim
}

# === Output, Debug, and Command Prompt Lines ===
def display_bos_out(message="Waiting for input..."):
    """Displays the bos.OUT line for program status and clears it before displaying new content."""
    with term.location(0, 26):
        print(term.clear_eol() + term.yellow(f"bos.OUT:>>  {message}"), end='')

def display_bos_bug(message="Ready"):
    """Displays the bos.DBG line for debugging logs and clears it before displaying new content."""
    with term.location(0, 25):
        print(term.clear_eol() + term.red(f"bos.DBG:>>  {message}"), end='')

# === Version Display (displayed only once) ===
def display_version():
    """Displays the version number in the top-right corner only once."""
    version_x = MAX_WIDTH - len(VERSION) - 2  # Adjust for starting at 0
    with term.location(version_x, 1):
        print(term.on_white(term.black(VERSION)), end='')

# === Display Area ===
def display_area():
    """Displays the artwork, animations, or other information in the display section (lines 2-18)."""
    with term.location(0, 10):
        print(term.cyan("=== Welcome to BOSctrl v.2 ==="), end='')

# === Menu Area ===
def clear_menu_area():
    """Clears the menu area to prevent duplicates."""
    for line in range(20, 26):  # Menu now starts at line 20, shifted down by one
        with term.location(0, line):
            print(term.clear_eol(), end='')

def display_menu():
    """Displays the menu options horizontally with wrapping, and leaves first two lines blank for aesthetics."""
    width = MAX_WIDTH
    current_line = 20  # Menu now starts at line 20 (shifted down by one line)
    current_pos = 0  # Track the current horizontal position

    clear_menu_area()  # Clear the menu area before printing

    for option in menu_options:
        formatted_option = f"   {option}   "
        if current_pos + len(formatted_option) > width:
            # Wrap to the next line if it exceeds width
            current_line += 1
            current_pos = 0
            if current_line > 25:  # Stop if we run out of space (bottom line is reserved)
                break
        with term.location(current_pos, current_line):
            print(formatted_option, end='')
        current_pos += len(formatted_option)

def capture_user_input():
    """Capture user input from the bos.USR prompt."""
    with term.location(12, 27):
        # Print prompt and capture input
        print("bos.USR:<<  ", end='', flush=True)
        user_input = input().strip().lower()
        return user_input

# === Matrix Animation ===
def matrix_animation(stop_event, settings, version_chars, version_cols):
    """Runs a Matrix-style animation in the display area with version number in fixed columns."""
    letters = settings['letters']
    colors = settings['colors']
    delay = settings['delay']
    drop_chance = settings['drop_chance']
    pulsing = settings['pulsing']

    # Initialize columns with no active drops
    cols = [0 for _ in range(MAX_WIDTH)]

    while not stop_event.is_set():
        for col in range(MAX_WIDTH):
            if stop_event.is_set():
                break

            if col in version_cols:
                # Version columns: display fixed character with pulsing
                char = version_chars[col - (MAX_WIDTH - 4)]
                # Ensure valid terminal capabilities for bright colors
                try:
                    color = term.bright_blue if random.random() < 0.5 else term.blue
                except TypeError:
                    color = term.blue  # Fallback to regular blue if bright fails

                # Print the character at the current position
                with term.location(col, cols[col]):
                    print(color(char), end='', flush=True)

                # Erase the previous character
                if cols[col] > 2:
                    with term.location(col, cols[col] - 1):
                        print(' ', end='', flush=True)

                # Move down the column
                cols[col] += 1

                # Reset if it reaches the bottom (line 18)
                if cols[col] > 18:
                    cols[col] = 0
            else:
                # Regular columns: animate random characters
                if col == 0:
                    # Skip column 0 to prevent interference with input
                    continue
                if cols[col] == 0 and random.random() < drop_chance:
                    cols[col] = 2  # Start at line 2

                if cols[col] > 0:
                    char = random.choice(letters)
                    # Ensure valid terminal capabilities for bright colors
                    try:
                        bright_color_name = f'bright_{random.choice(colors)}'
                        color = getattr(term, bright_color_name)
                    except AttributeError:
                        color = getattr(term, random.choice(colors))  # Fallback if bright variant doesn't exist

                    # Print the character
                    with term.location(col, cols[col]):
                        print(color(char), end='', flush=True)

                    # Erase the previous character
                    if cols[col] > 2:
                        with term.location(col, cols[col] - 1):
                            print(' ', end='', flush=True)

                    # Move the drop down
                    cols[col] += 1

                    # Reset if it reaches the bottom (line 18)
                    if cols[col] > 18:
                        cols[col] = 0
        time.sleep(delay)

def main():
    """Main function to display the title screen, run animation, and accept input."""
    print(term.clear)
    display_version()  # Version is displayed only once here
    display_area()
    display_menu()

    # Always show these lines, even before any input
    display_bos_out("Waiting for input...")
    display_bos_bug("Ready")
    # Removed initial 'display_bos_usr()'

    # Set up threading for the animation
    stop_event = threading.Event()

    # Version number settings
    version_chars = list(VERSION)  # ['v','0','.','2']
    version_cols = list(range(MAX_WIDTH - 4, MAX_WIDTH))  # Last four columns: 74-77 for MAX_WIDTH=78

    # Start animation thread
    animation_thread = threading.Thread(target=matrix_animation, args=(stop_event, animation_settings, version_chars, version_cols), daemon=True)
    animation_thread.start()

    try:
        while True:
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

            # Re-display the menu after every command
            display_menu()  # Re-display the menu after processing input
            # No need to call 'display_bos_usr()' here, as 'capture_user_input()' already handles it
    except KeyboardInterrupt:
        pass
    finally:
        # Signal the animation thread to stop and wait for it to finish
        stop_event.set()
        animation_thread.join()

        # Clear the screen before exiting
        print(term.clear)

if __name__ == "__main__":
    main()
