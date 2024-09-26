from blessed import Terminal

term = Terminal()

def get_terminal_size():
    """Retrieve and display the terminal's current width and height."""
    width = term.width
    height = term.height
    print(f"Terminal width: {width}")
    print(f"Terminal height: {height}")

if __name__ == "__main__":
    get_terminal_size()
