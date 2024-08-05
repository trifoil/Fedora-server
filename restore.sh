#!/bin/bash

#!/bin/bash

BLUE='\e[38;5;33m' #Red
NC='\033[0m' # No Color

clear

display_menu() {
    echo ""
    echo "|----------------------------------------------------------------------|"
    echo -e "|                ${BLUE}Welcome to the restoration assistant ${NC}                 |"
    echo "|               Please select the tool you want to use                 |"
    echo "|----------------------------------------------------------------------|"
    echo "|                    Please select a setup option:                     |"
    echo "|----------------------------------------------------------------------|"
    echo "|----------------------------------------------------------------------|"
    echo "| q. Exit                                                              |"
    echo "|----------------------------------------------------------------------|"
    echo ""
}


main() {
    while true; do
        display_menu
        read -p "Enter your choice: " choice
        case $choice in
            q) echo "Bye!" && clear && exit;;
            *) clear && echo "Invalid choice. Please enter a valid option." ;;
        esac
        clear
    done
}

main