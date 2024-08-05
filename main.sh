#!/bin/bash

BLUE='\e[38;5;33m' #Red
NC='\033[0m' # No Color

clear

display_menu() {
    echo ""
    echo "|----------------------------------------------------------------------|"
    echo -e "|                   ${BLUE}Welcome to the server assistant ${NC}                   |"
    echo "|              Please select the toolbox you want to use               |"
    echo "|----------------------------------------------------------------------|"
    echo "| 0. Services Maintenance                                              |"
    echo "| 1. Services Setup                                                    |"
    echo "| 2. Services Backup                                                   |"
    echo "| 3. Services Restoration                                              |"
    echo "|----------------------------------------------------------------------|"
    echo "| q. Exit                                                              |"
    echo "|----------------------------------------------------------------------|"
    echo ""
}

services_maintenance() {
    sh maintenance.sh
}

services_setup() {
    sh setup.sh
}

services_backup() {
    sh backup.sh
}

services_restoration() {
    sh restore.sh
}


main() {
    while true; do
        display_menu
        read -p "Enter your choice: " choice
        case $choice in
            0) services_maintenance ;;
            1) services_setup ;;
            2) services_backup ;;
            3) services_restoration ;;
            q) echo "Bye!" && clear && exit;;
            *) clear && echo "Invalid choice. Please enter a valid option." ;;
        esac
        clear
    done
}

main