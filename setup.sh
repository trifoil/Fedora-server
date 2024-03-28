#!/bin/bash

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
    echo "| 11. Use whole lvm"
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
    chmod +x 0_initial_setup.sh
    ./0_initial_setup.sh
}

setup_docker() {
    chmod +x 1_docker_setup.sh
    ./1_docker_setup.sh
    echo "setting up Docker"
}

setup_nginx() {
    chmod +x 2_nginx_setup.sh
    ./2_nginx_setup.sh
    echo "Starting nginx setup, kindly please wait :)"
}

setup_website() {
    echo "Starting website setup"
    chmod +x 3_php_site_setup.sh
    ./3_php_site_setup.sh
}

setup_nextcloud_aio() {
    echo "Starting NEXTCLOUD AIO setup (based)"
    chmod +x 4_nextcloud_setup.sh
    ./4_nextcloud_setup.sh
}

backup_tool(){
    echo "Starting backup tool script"
}

remove_all_containers() {
    echo "Starting container removal"
    chmod +x container_remover.sh
    ./container_remover.sh
}

resize_lvm() {
    echo "resizing ..."
    lvextend fedora/root /dev/sda3
}

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
            10) resize_lvm ;;
            11) echo "Bye loser!" && clear && exit;;
            *) clear && echo "Invalid choice. Please enter a valid option." ;;
        esac
        clear
    done
    
}

main