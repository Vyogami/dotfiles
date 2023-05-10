#!/bin/bash

# Function to backup the installed extensions
backup_extensions() {
    read -p "Enter the name of the backup file (or leave blank for default): " backup_file
    
    if [[ -z "$backup_file" ]]; then
        backup_file="extensions-list.txt"
    fi
    
    code --list-extensions >> "$backup_file"
    echo "Extensions backed up successfully to $backup_file."
}

# Function to install extensions from the backup
install_extensions() {
    if [ ! -f "extensions-list.txt" ]; then
        echo "No extension backup found. Please run backup first."
        return
    fi
    
    cat extensions-list.txt | xargs -n 1 code --install-extension
    echo "Extensions installed successfully."
}

# Function to uninstall extensions
uninstall_extensions() {
    code --list-extensions | xargs -n 1 code --uninstall-extension
    echo "Extensions uninstalled successfully."
}

# Menu function
show_menu() {
    echo "Menu:"
    echo "1. Backup extensions"
    echo "2. Install extensions"
    echo "3. Uninstall extensions"
    echo "4. Quit"
}

# Main program
while true; do
    show_menu
    read -p "Enter your choice: " choice
    
    case $choice in
        1)
            backup_extensions
            ;;
        2)
            install_extensions
            ;;
        3)
            uninstall_extensions
            ;;
        4)
            echo "Exiting program."
            break
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac
    
    echo
done

