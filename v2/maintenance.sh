#!/bin/bash

BLUE='\e[38;5;33m' #Red
NC='\033[0m' # No Color

display_menu() {
    echo ""
    echo "|----------------------------------------------------------------------|"
    echo -e "|                   ${BLUE}Welcome to the server assistant ${NC}                   |"
    echo "|                Please select the tool you want to use                |"
    echo "|----------------------------------------------------------------------|"
    echo "|                 Please select a maintenance option:                  |"
    echo "|----------------------------------------------------------------------|"
    echo "| 0. Display running containers                                        |"
    echo "| 1. Restart all containers                                            |"
    echo "| 2. Stop and remove all containers                                    |"
    echo "|----------------------------------------------------------------------|"
    echo "| q. Exit                                                              |"
    echo "|----------------------------------------------------------------------|"
    }


main() {
    while true; do
        display_menu
        read -p "Enter your choice: " choice
        case $choice in
            0) display_running ;;
            1) setup_tools ;;
            2) setup_docker ;;
            3) setup_nginx ;;
            4) setup_website ;;
            5) setup_nextcloud ;;
            6) setup_nextcloud_AIO ;;
            7) backup_tool ;;
            8) remove_all_containers ;;
            9) restart_all_containers ;;
            q) echo "Bye loser!" && clear && exit;;
            *) clear && echo "Invalid choice. Please enter a valid option." ;;
        esac
        clear
    done
}

main