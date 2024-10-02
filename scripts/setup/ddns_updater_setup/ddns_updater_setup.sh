#!/bin/bash

cd "$(dirname "$0")"

echo "The script will now install ddns updater"
echo "Updating ... "
dnf update -y

prompt() {
  local prompt_message=$1
  local default_value=$2
  read -p "$prompt_message [$default_value]: " input
  echo "${input:-$default_value}"
}

ddns_updater_volume=$(prompt "Enter the volume for ddns updater" "/storage/ddns_updater")
ddns_updater_port=$(prompt "Enter the port number" "8002")

cat <<EOF > docker-compose.yaml
services:
  ddns-updater:
    image: qmcgaw/ddns-updater
    container_name: ddns-updater
    network_mode: bridge
    ports:
      - $ddns_updater_port:8000/tcp
    volumes:
      - $ddns_updater_volume:/updater/data
    environment:
      - CONFIG=
      - PERIOD=5m
      - UPDATE_COOLDOWN_PERIOD=5m
      - PUBLICIP_FETCHERS=all
      - PUBLICIP_HTTP_PROVIDERS=all
      - PUBLICIPV4_HTTP_PROVIDERS=all
      - PUBLICIPV6_HTTP_PROVIDERS=all
      - PUBLICIP_DNS_PROVIDERS=all
      - PUBLICIP_DNS_TIMEOUT=3s
      - HTTP_TIMEOUT=10s

      # Web UI
      - LISTENING_ADDRESS=:$ddns_updater_port
      - ROOT_URL=/

      # Backup
      - BACKUP_PERIOD=0 # 0 to disable
      - BACKUP_DIRECTORY=/updater/data

      # Other
      - LOG_LEVEL=info
      - LOG_CALLER=hidden
      - SHOUTRRR_ADDRESSES=
    restart: always
EOF

echo "The docker-compose.yaml has been created successfully."

docker compose up -d
docker ps

read -n 1 -s -r -p "Done. Press any key to continue..."