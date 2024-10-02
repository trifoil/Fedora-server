#!/bin/bash

BLUE='\e[38;5;33m' 
RED='\e[38;5;196m'
NC='\033[0m' # No Color

clear

# Function to display the menu
display_menu() {
    echo ""
    echo "|----------------------------------------------------------------------|"
    echo -e "|                   ${BLUE}Welcome to the setup assistant ${NC}                    |"
    echo "|                Please select the tool you want to use                |"
    echo "|----------------------------------------------------------------------|"
    echo "| 0. Setup Docker                                             ${RED}REQUIRED ${NC}|"
    echo "| 1. Setup Portainer                                                   |"
    echo "| 2. Setup NGINX Proxy Manager                                         |"
    echo "| 3. Setup FileBrowser                                                 |"
    echo "| 4. Setup Nextcloud AIO                                               |"
    echo "| 5. Setup SurrealDB                                                   |"
    echo "| 6. Setup Streaming                                                   |"
    echo "| 7. Setup Vanilla JS Website                                          |"
    echo "| 7. Setup Vanilla JS Website                                          |"
    echo "|----------------------------------------------------------------------|"
    echo "| q. Exit                                                              |"
    echo "|----------------------------------------------------------------------|"
    echo ""
}

setup_docker(){
    sh scripts/setup/docker_setup/docker_setup.sh
}

setup_npm(){
    sh scripts/setup/npm_setup/npm_setup.sh
}

setup_portainer(){
    sh scripts/setup/portainer_setup/portainer_setup.sh
}

setup_filebrowser(){
    sh scripts/setup/filebrowser_setup/filebrowser_setup.sh
}

setup_nextcloud_aio(){
    sh scripts/setup/nextcloud_aio_setup/nextcloud_aio_setup.sh
}

setup_surrealdb(){
    sh scripts/setup/surrealdb_setup/surrealdb_setup.sh
}

setup_streaming(){
    sh scripts/setup/streaming_setup/streaming_setup.sh
}

setup_vanilla_js_website(){
    sh scripts/setup/js_website_setup/js_website_setup.sh
}

setup_ddns_updater()(
    sh scripts/setup/ddns_updater_setup/ddns_updater_setup.sh
)

main() {
    while true; do
        display_menu
        read -p "Enter your choice: " choice
        case $choice in
            0) setup_docker ;;
            1) setup_portainer ;;
            2) setup_npm ;;
            3) setup_filebrowser ;;
            4) setup_nextcloud_aio ;;
            5) setup_surrealdb ;;
            6) setup_streaming ;;
            7) setup_vanilla_js_website ;;
            8) setup_ddns_updater ;;
            q) echo "Bye loser!" && clear && exit;;
            *) clear && echo "Invalid choice. Please enter a valid option." ;;
        esac
        clear
    done
}

main