#!/bin/bash

cd "$(dirname "$0")"

echo "The script will now install the VPN"
echo "Updating ... "
dnf update -y


prompt() {
  local prompt_message=$1
  local default_value=$2
  read -p "$prompt_message [$default_value]: " input
  echo "${input:-$default_value}"
}

vpn_domain=$(prompt "Enter your domain for the vpn service" "vpn.example.com")
vpn_volume=$(prompt "Enter the volume for the vpn service" "/storage/vpn")
vpn_port=$(prompt "Enter the port for the vpn service" "8080")

cat <<EOF > docker-compose.yaml

services:
  wireguard:
    image: linuxserver/wireguard
    container_name: wireguard
    cap_add:
      - NET_ADMIN
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Brussels
      - SERVERURL=$vpn_domain
      - SERVERPORT=51820
      - PEERS=2
      - PEERDNS=auto
    volumes:
      - $vpn_volume/wireguard:/config
      - /lib/modules:/lib/modules:ro
    ports:
      - "51820:51820/udp"
    restart: unless-stopped

  wstunnel:
    image: mhzed/wstunnel:latest
    container_name: wstunnel
    environment:
      - LISTEN_PORT=80 # The port on which WSTunnel will listen
      - CONNECT_HOST=wireguard # Internal DNS name of WireGuard container
      - CONNECT_PORT=51820 # WireGuard's port that WSTunnel will tunnel traffic to
      - MODE=server # Run WSTunnel in server mode
    ports:
      - "$vpn_port:80" # Public WebSocket port (can configure SSL via NPM)
    restart: unless-stopped
    depends_on:
      - wireguard

z
networks:
  vpn-network:
    driver: bridge


EOF

echo "The docker-compose.yaml has been created successfully."

docker compose up -d

docker ps

read -n 1 -s -r -p "Done. Press any key to continue..."
