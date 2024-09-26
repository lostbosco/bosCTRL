#!/bin/bash

# Navigate to the directory where your app is stored
cd /home/deck/BOSctrl/base/BOSmain.py

# Activate the virtual environment
source /home/deck/BOSctrl/bin/activate

# Run the Python script
python BOSmain.py

# Keep the terminal open after the script finishes (for debugging or other tasks)
exec bash
