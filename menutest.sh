#!/bin/bash

echo "test"

# Function to display the menu
display_menu() {
    echo "Please select an option:"
    echo "1. Run Script 1"
    echo "2. Run Script 2"
    echo "3. Exit"
}

# Function to execute script 1
run_script1() {
    echo "Running Script 1..."
    # Add command to execute Script 1 here
}

# Function to execute script 2
run_script2() {
    echo "Running Script 2..."
    # Add command to execute Script 2 here
}

# Main function
main() {
    while true; do
        display_menu
        read -p "Enter your choice: " choice
        case $choice in
            1) run_script1 ;;
            2) run_script2 ;;
            3) echo "Exiting..." && exit ;;
            *) echo "Invalid choice. Please enter a valid option." ;;
        esac
    done
}

main