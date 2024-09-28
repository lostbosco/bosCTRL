#!/bin/bash

# Log the launch start to bosLOGS.txt
echo "$(date): Starting application..." >> bosAPP/bosPAGE/bosLOGS.txt

# Load necessary scripts
source ./bosAPP/bosBASE.sh  # Printer script
source ./bosAPP/bosSYST.sh  # System settings page
source ./bosAPP/bosPMGR.sh  # Page creation and management script

# Define paths
bosPAGE_DIR="bosAPP/bosPAGE"  # Directory for storing pages

# Log successful script loading
echo "$(date): All scripts loaded successfully." >> bosAPP/bosPAGE/bosLOGS.txt

# Start the application
# The start of the program will rely on bosBASE.sh to manage input/output handling

# Call the initial function to display the main menu from bosBASE
bosBASE_main_menu
