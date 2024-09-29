#!/bin/bash

# Define the root directory of the app
ROOT_DIR="$(dirname "$0")"

# Define key directories
CORE_DIR="$ROOT_DIR/bos_CORE"
PAGE_DIR="$ROOT_DIR/bos_PAGE"
RECORD_DIR="$CORE_DIR/bos_RECD"
LOG_FILE="$RECORD_DIR/bos_LOGS.txt"

# Function to load disp_FUNC first to open the second terminal (trml_DISP)
function load_disp_terminal() {
    echo "Loading display terminal..."

    # Load disp_FUNC.sh
    if [[ -f "$CORE_DIR/disp_FUNC.sh" ]]; then
        source "$CORE_DIR/disp_FUNC.sh"
        echo "Loaded disp_FUNC.sh"
    else
        echo "Error: disp_FUNC.sh not found." | tee -a "$LOG_FILE"
        exit 1
    fi
}

# Function to load core functions (after disp_FUNC)
function load_core_functions() {
    echo "Loading core functions..."

    # Load core_FUNC.sh
    if [[ -f "$CORE_DIR/core_FUNC.sh" ]]; then
        source "$CORE_DIR/core_FUNC.sh"
        echo "Loaded core_FUNC.sh"
    else
        echo "Error: core_FUNC.sh not found." | tee -a "$LOG_FILE"
        exit 1
    fi
}

# Function to load the remaining core files
function load_core_files() {
    echo "Checking and loading remaining core files..."
    local core_files=(
        "$CORE_DIR/base_MENU.sh"
        "$CORE_DIR/base_PMGR.sh"
        "$CORE_DIR/base_SYST.sh"
    )

    for file in "${core_files[@]}"; do
        if [[ -f "$file" ]]; then
            echo "Loading $file"
            source "$file"
        else
            echo "Warning: $file not found." | tee -a "$LOG_FILE"
        fi
    done
}

# Function to load user-generated pages
function load_user_pages() {
    echo "Loading user-generated pages from $PAGE_DIR..."

    if [[ -d "$PAGE_DIR" ]]; then
        for page_file in "$PAGE_DIR"/*.sh; do
            if [[ -f "$page_file" ]]; then
                echo "Loading $page_file"
                source "$page_file"
            fi
        done
    else
        echo "Warning: $PAGE_DIR directory not found." | tee -a "$LOG_FILE"
    fi
}

# Initialize log file if it exists
function init_logging() {
    if [[ -f "$LOG_FILE" ]]; then
        echo "$(date) - bos_GTUI launched." >> "$LOG_FILE"
    fi
}

# Function to launch the input terminal (trml_DISP as input)
function launch_input_terminal() {
    echo "Launching trml_DISP (Input Terminal) in new Konsole window..."
    konsole --profile bosCTRL --noclose -e "tail -f $CORE_DIR/bos_pipe" &
}

# Function to launch the output terminal (trml_INPT as display)
function launch_output_terminal() {
    echo "Launching trml_INPT (Display Terminal) in current window..."
}

# Load all necessary components
load_disp_terminal  # Load the display terminal first
load_core_functions
load_core_files
load_user_pages
init_logging

# Launch the input terminal first
launch_input_terminal

# Launch the display terminal (output terminal) in the current window
launch_output_terminal

# Launch the main menu
echo "Launching the main menu..."
bash "$CORE_DIR/base_MENU.sh"
