#!/bin/bash

cd "$(dirname "$0")"

echo "The script will now install your streaming services"
echo "Updating ... "
dnf update -y

prompt() {
    local prompt_message=$1
    local default_value=$2
    read -p "$prompt_message [$default_value]: " input
    echo "${input:-$default_value}"
}

downloads_volume=$(prompt "Enter the volume for downloading media" "/storage/streaming")
deluge_conf_volume=$(prompt "Enter the volume for deluge conf files" "/storage/deluge")
media_volume=$(prompt "Enter the volume for jellyfin media" "/storage/media")
jellyfin_conf_volume=$(prompt "Enter the volume for jellyfin conf files" "/storage/jellyfin")

cat <<EOF > docker-compose.yaml
version: '3.8'

services:
  jellyfin:
    image: jellyfin/jellyfin:latest
    container_name: jellyfin
    ports:
      - "8096:8096" # Jellyfin Web UI Port
    volumes:
      - $jellyfin_conf_volume:/config     # Jellyfin config storage
      - $media_volume:/media              # Media directory
    environment:
      - PUID=1000                         # User ID for file permissions
      - PGID=1000                         # Group ID for file permissions
      - TZ=Europe/Brussels                # Set your timezone
    restart: unless-stopped
    networks:
      - media-network

  deluge:
    image: linuxserver/deluge
    container_name: deluge
    ports:
      - "8112:8112"                  # Deluge Web UI Port
      - "58846:58846"                # Deluge Daemon Port
      - "58946:58946"                # Torrent traffic
      - "58946:58946/udp"            # Torrent traffic (UDP)
    volumes:
      - $deluge_conf_volume:/config           # Deluge config storage
      - $downloads_volume:/downloads    # Downloads directory
    environment:
      - PUID=1000                    # User ID for file permissions
      - PGID=1000                    # Group ID for file permissions
      - TZ=Europe/London             # Set your timezone
    restart: unless-stopped
    networks:
      - media-network

networks:
  media-network:
    driver: bridge


EOF

echo "The docker-compose.yml has been created successfully."

docker compose up -d
docker ps

read -n 1 -s -r -p "Done. Press any key to continue..."