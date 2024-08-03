#!/bin/bash

chmod +x -R scripts
clear

# Function to display the menu
display_menu() {
    echo ""
    echo "|------------------------------------------------"
    echo "| Please select a setup option: "
    echo "|------------------------------------------------"
    echo "| 0. Display running containers"
    echo "| 1. Setup Tools"
    echo "| 2. Setup Docker"
    echo "| 3. Setup NGINX"
    echo "| 4. Setup a website"    
    echo "| 5. Setup a NEXTCLOUD instance"
    echo "| 6. Setup a NEXTCLOUD AIO instance"
    echo "|------------------------------------------------"
    echo "| Or another option :"
    echo "|------------------------------------------------"
    echo "| 7. Backup tool"
    echo "| 8. Stop and remove all containers"
    echo "| 9. Restart all containers"
    echo "| 10. Exit"
    echo "|------------------------------------------------"
    echo ""
}
display_running() {
    docker ps
    read -n 1 -s -r -p "Press any key to continue..."
}

restart_all_containers() {
docker stop $(docker ps -aq)
docker start $(docker ps -aq)
read -n 1 -s -r -p "Done. Press any key to continue..."
}

setup_tools() {
    echo "Starting tools setup"
    ./0_initial_setup.sh
}

setup_docker() {
    echo "setting up Docker"
    ./1_docker_setup.sh
}

setup_nginx() {
    ./2_nginx_setup.sh
    echo "Starting nginx setup, kindly please wait :)"
}

setup_website() {
    echo "Starting website setup"
    ./3_php_site_setup.sh
}

setup_nextcloud_aio() {
    echo "Starting NEXTCLOUD AIO setup (based)"
    ./4_nextcloud_setup_AIO.sh
}

backup_tool(){
    echo "Starting backup tool script"
}

remove_all_containers() {
    echo "Starting container removal"
    ./container_remover.sh
}

# resize_lvm() {
#     echo "resizing ..."
#     lsblk
#     lvextend fedora/root /dev/sda3
#     lsblk
# }

# Main function
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
            10) echo "Bye loser!" && clear && exit;;
            *) clear && echo "Invalid choice. Please enter a valid option." ;;
        esac
        clear
    done
    
}

main