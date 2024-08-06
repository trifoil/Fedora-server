#!/bin/bash

BLUE='\e[38;5;33m' #Red
NC='\033[0m' # No Color

clear

# Function to display the menu
display_menu() {
    echo ""
    echo "|----------------------------------------------------------------------|"
    echo -e "|                   ${BLUE}Welcome to the setup assistant ${NC}                    |"
    echo "|                Please select the tool you want to use                |"
    echo "|----------------------------------------------------------------------|"
    echo "| 0. Setup Portainer                                                   |"
    echo "| 1. Setup Portainer                                                   |"
    echo "| 2. Setup NGINX Proxy Manager                                         |"
    echo "| 3. Setup LAMP (Linux, Apache, MySQL, PHP)                            |"
    echo "| 4. Setup Nextcloud AIO                                               |"
    echo "|----------------------------------------------------------------------|"
    echo "| q. Exit                                                              |"
    echo "|----------------------------------------------------------------------|"
    echo ""
}

setup_docker(){
    sh scripts/setups/docker_setup/docker_setup.sh
}

setup_npm(){
    sh scripts/setups/npm_setup/npm_setup.sh
}

setup_portainer(){
    sh scripts/setups/portainer_setup/portainer_setup.sh
}

setup_lamp(){
    sh scripts/setups/lamp_setup/lamp_setup.sh
}

setup_nextcloud_aio(){
    sh scripts/setups/nextcloud_aio_setup/nextcloud_aio_setup.sh
}

main() {
    while true; do
        display_menu
        read -p "Enter your choice: " choice
        case $choice in
            0) setup_docker ;;
            1) setup_portainer ;;
            2) setup_npm ;;
            3) setup_lamp ;;
            4) setup_nextcloud_aio ;;
            q) echo "Bye loser!" && clear && exit;;
            *) clear && echo "Invalid choice. Please enter a valid option." ;;
        esac
        clear
    done
}

main