#!/bin/bash

# Define the root directory of the app
ROOT_DIR="$(dirname "$0")"

# Define key directories
CORE_DIR="$ROOT_DIR/bos_CORE"
PAGE_DIR="$ROOT_DIR/bos_PAGE"
RECORD_DIR="$CORE_DIR/bos_RECD"
LOG_FILE="$RECORD_DIR/bos_LOGS.txt"

# Function to load core and display functions
function load_core_functions() {
    echo "Loading core and display functions..."

    # Load core_FUNC.sh
    if [[ -f "$CORE_DIR/core_FUNC.sh" ]]; then
        source "$CORE_DIR/core_FUNC.sh"
        echo "Loaded core_FUNC.sh"
    else
        echo "Error: core_FUNC.sh not found." | tee -a "$LOG_FILE"
        exit 1
    fi

    # Load disp_FUNC.sh
    if [[ -f "$CORE_DIR/disp_FUNC.sh" ]]; then
        source "$CORE_DIR/disp_FUNC.sh"
        echo "Loaded disp_FUNC.sh"
    else
        echo "Error: disp_FUNC.sh not found." | tee -a "$LOG_FILE"
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

# Load all necessary components
load_core_functions
load_core_files
load_user_pages
init_logging

# Launch the main menu
echo "Launching the main menu..."
bash "$CORE_DIR/base_MENU.sh"
