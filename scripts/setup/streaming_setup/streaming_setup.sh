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

filebrowser_volume=$(prompt "Enter the volume" "/storage/streaming")


cat <<EOF > docker-compose.yaml
services:
  jellyfin:
    image: jellyfin/jellyfin:latest
    container_name: jellyfin
    ports:
      - "8096:8096" # Jellyfin web UI
      - "8920:8920" # Optional: Jellyfin HTTPS port
    volumes:
      - ./config:/config       # Jellyfin configuration data
      - ./cache:/cache         # Cache for optimized data
      - /storage/streaming:/media         # Your media files (adjust to point to your media)
    environment:
      - TZ=YOUR_TIMEZONE       # e.g., Europe/London
    restart: unless-stopped

# Optional: Add a network section if you need Jellyfin to connect with other services.
# networks:
#   default:
#     external:
#       name: your_custom_network

EOF