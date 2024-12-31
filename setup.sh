#!/bin/bash

BLUE='\e[38;5;33m' 
RED='\e[38;5;196m'
NC='\033[0m' # No Color

clear

# Function to display the menu
display_menu() {
    echo ""
    echo "|-----------------------------------------------------------------------|"
    echo -e "|                   ${BLUE}Welcome to the setup assistant ${NC}                     |"
    echo "|                Please select the tool you want to use                 |"
    echo "|-----------------------------------------------------------------------|"
    echo -e "|  0. Setup Docker                                             ${RED}REQUIRED ${NC}|"
    echo "|  1. Setup Portainer                                                   |"
    echo "|  2. Setup Traefik                                                     |"
    echo "|  3. Setup NGINX Proxy Manager                                         |"
    echo "|  4. Setup Pi-hole                                                     |"
    echo "|  5. Setup Custom VPN                                                  |"
    echo "|  6. Setup HomeAssistant                                               |"
    echo "|  7. Setup Nextcloud AIO                                               |"
    echo "|  8. Setup GitBucket                                                   |"
    echo "|  9. Setup Matrix Server                                               |"
    echo "| 10. Setup Alternative Monitoring Tool (e.g., Prometheus, Grafana)     |"
    echo "| 11. Setup Vaultwarden                                                 |"
    echo "| 12. Setup FileBrowser                                                 |"
    echo "| 13. Setup Streaming (deluge + jellyfin)                               |"
    echo "| 14. Setup Vanilla JS Website                                          |"
    echo "| 15. Setup DDNS Updater                                                |"
    echo "| 16. Setup SOTF (sons of the forest) Server                            |"
    echo "|-----------------------------------------------------------------------|"
    echo "|  q. Exit                                                              |"
    echo "|-----------------------------------------------------------------------|"
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

setup_sotf(){
    sh scripts/setup/sotf_server_setup/sotf_server_setup.sh
}

setup_openvpn(){
    sh scripts/setup/openvpn_setup/openvpn_setup.sh
}

setup_zabbix(){
    sh scripts/setup/zabbix_setup/zabbix_setup.sh
}

setup_outline(){
    sh scripts/setup/outline_vpn_setup/outline_vpn_setup.sh
}

setup_django(){
    sh scripts/setup/django_setup/django_setup.sh
}



main() {
    while true; do
        display_menu
        read -p "Enter your choice: " choice
        case $choice in
            0) setup_docker ;;
            1) setup_portainer ;;
            2) setup_traefik ;;
            3) setup_npm ;;
            4) setup_pihole ;;
            5) setup_vpn ;;
            6) setup_homeassistant ;;
            7) setup_nextcloud_aio ;;
            8) setup_gitbucket ;;
            9) setup_matrix ;;
            10) setup_monitoring ;;
            11) setup_vaultwarden ;;
            12) setup_filebrowser ;;
            13) setup_streaming ;;
            14) setup_vanilla_js_website ;;
            15) setup_ddns_updater ;;
            16) setup_sotf ;;
            q) clear && echo "Bye loser!" && exit;;
            *) clear && echo "Invalid choice. Please enter a valid option." ;;
        esac
        clear
    done
}

main