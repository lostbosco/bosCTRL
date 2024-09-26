#!/bin/bash

# Navigate to the directory where the Python script is located
cd /home/deck/BOSctrl/base || exit

# Activate the virtual environment
source /home/deck/BOSctrl/bin/activate

# Run the Python script
python BOSmain.py


# Keep the terminal open after the script finishes (for debugging or other tasks)
exec bash
