#!/bin/bash

# Log the start of the page manager script
echo "$(date): bosPMGR.sh started." >> bosAPP/bosPAGE/bosLOGS.txt

# Directory to store pages
bosPAGE_DIR="bosAPP/bosPAGE"

# Function to display the page manager menu
bosPMGR_main() {
    local title="Page Manager"
    local display_lines=("Manage your pages here." "You can create, edit, or delete pages.")
    local menu_items=("1. Create New Page" "2. Edit Existing Page" "3. Delete Page" ".back (Return to Main Menu)")
    local user_input=""

    while true; do
        # Refresh the screen with the page manager data
        bosBASE_refresh "$title" display_lines[@] menu_items[@] "$user_input"

        # Capture user input
        read -p "bos.INPT:<< " user_input

        # Handle user input and send to respective functions
        case "$user_input" in
            "1")
                bosPMGR_create_page  # Call function to create a new page
                ;;
            "2")
                bosPMGR_edit_page  # Call function to edit an existing page
                ;;
            "3")
                bosPMGR_delete_page  # Call function to delete a page
                ;;
            ".back")
                bosBASE_main_menu  # Return to the main menu
                ;;
            ".exit")
                echo "$(date): Exiting program from page manager." >> bosAPP/bosPAGE/bosLOGS.txt
                clear
                exit 0
                ;;
            *)
                echo "$(date): Invalid input '$user_input' in page manager." >> bosAPP/bosPAGE/bosLOGS.txt
                user_input="Invalid input. Try again."
                ;;
        esac
    done
}

# Function to create a new page
bosPMGR_create_page() {
    local page_name=""
    echo "$(date): User selected Create New Page." >> bosAPP/bosPAGE/bosLOGS.txt
    read -p "Enter the name of the new page: " page_name

    if [[ -f "$bosPAGE_DIR/$page_name.sh" ]]; then
        echo "Page already exists. Please choose a different name."
        echo "$(date): Page creation failed. $page_name already exists." >> bosAPP/bosPAGE/bosLOGS.txt
        return
    fi

    # Create the new page with a basic template
    cat <<EOL > "$bosPAGE_DIR/$page_name.sh"
#!/bin/bash
# --{$page_name}--
# Meta data for page
# Parent page: menu>page
# Display title: $page_name Page
# Display data below
EOL

    echo "$(date): Created new page '$page_name'." >> bosAPP/bosPAGE/bosLOGS.txt
    echo "Page '$page_name' created successfully."
}

# Function to edit an existing page
bosPMGR_edit_page() {
    local page_name=""
    echo "$(date): User selected Edit Existing Page." >> bosAPP/bosPAGE/bosLOGS.txt
    read -p "Enter the name of the page to edit: " page_name

    if [[ ! -f "$bosPAGE_DIR/$page_name.sh" ]]; then
        echo "Page not found. Please check the name and try again."
        echo "$(date): Page edit failed. $page_name does not exist." >> bosAPP/bosPAGE/bosLOGS.txt
        return
    fi

    # Open the page file in the default editor (can be changed)
    nano "$bosPAGE_DIR/$page_name.sh"
    echo "$(date): Edited page '$page_name'." >> bosAPP/bosPAGE/bosLOGS.txt
}

# Function to delete an existing page
bosPMGR_delete_page() {
    local page_name=""
    echo "$(date): User selected Delete Page." >> bosAPP/bosPAGE/bosLOGS.txt
    read -p "Enter the name of the page to delete: " page_name

    if [[ ! -f "$bosPAGE_DIR/$page_name.sh" ]]; then
        echo "Page not found. Please check the name and try again."
        echo "$(date): Page deletion failed. $page_name does not exist." >> bosAPP/bosPAGE/bosLOGS.txt
        return
    fi

    rm "$bosPAGE_DIR/$page_name.sh"
    echo "$(date): Deleted page '$page_name'." >> bosAPP/bosPAGE/bosLOGS.txt
    echo "Page '$page_name' deleted successfully."
}

# Log the successful setup of bosPMGR.sh
echo "$(date): bosPMGR.sh setup complete." >> bosAPP/bosPAGE/bosLOGS.txt
