#!/bin/bash

# Function to start a tmux session with two new windows
start_tmux_session() {
    # Create a detached tmux session
    tmux new-session -d -s tui_session

    # Create the second window for TUI display (main window for output)
    tmux new-window -d -t tui_session:1 -n 'Main TUI'
    tmux send-keys -t tui_session:1 'bash -c "main_tui_loop"' C-m  # Run TUI loop in this window

    # Create the third window for input (size 4 lines, 12 columns)
    tmux new-window -d -t tui_session:2 -n 'User Input'
    tmux send-keys -t tui_session:2 'bash -c "input_loop"' C-m  # Run input loop in this window

    # Resize the input window to 4 lines and 12 columns
    tmux resize-pane -t tui_session:2 -x 12 -y 4

    # Attach to the session (input window will not take over the original terminal)
    tmux attach-session -d -t tui_session
}

# Main TUI loop (running in the second tmux window)
main_tui_loop() {
    # Initialize TUI display
    tput civis   # Hide the cursor
    tput clear   # Clear the screen

    # Draw TUI content
    draw_tui() {
        tput clear
        tput cup 0 0
        echo "╔════════════════════════════════════════════════════╗"
        for i in {1..23}; do
            tput cup $i 0
            echo "║                                                    ║"
        done
        tput cup 24 0
        echo "╚════════════════════════════════════════════════════╝"

        # Display placeholder logs
        tput cup 22 2
        echo "bos.DBUG:>> Waiting for input..."
        tput cup 23 2
        echo "bos.CTRL:>> No input processed"
    }

    # Continuously refresh TUI
    while true; do
        draw_tui
        sleep 1  # Refresh delay
    done

    # Cleanup on exit
    tput cnorm
    tput clear
}

# Input loop (running in the input window)
input_loop() {
    while true; do
        # Capture input
        read -p "bos.INPT:<< " user_input

        # If user types "exit", stop the tmux session
        if [ "$user_input" == "exit" ]; then
            tmux kill-session -t tui_session
            exit
        fi
    done
}

# Cleanup function for resetting terminal behavior
cleanup() {
    tput cnorm  # Reset terminal to normal state
    tmux kill-session -t tui_session  # Cleanly kill the tmux session
}

# Trap cleanup function to handle termination
trap cleanup EXIT

# Start the tmux session
start_tmux_session
