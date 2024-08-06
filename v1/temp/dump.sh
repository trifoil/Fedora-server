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
    sh 2_nginx_setup.sh
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