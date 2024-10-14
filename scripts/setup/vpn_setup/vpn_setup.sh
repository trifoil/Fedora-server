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

sudo update-alternatives --set iptables /usr/sbin/iptables-nft
sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-nft


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
    image: ghcr.io/erebe/wstunnel:latest
    container_name: wstunnel
    command: wstunnel server wss://0.0.0.0:$vpn_port --restrict-to "127.0.0.1:51820"
    ports:
      - "$vpn_port:$vpn_port/tcp"
    depends_on:
      - wireguard
    restart: unless-stopped

EOF

echo "The docker-compose.yaml has been created successfully."

docker compose up -d

docker ps

read -n 1 -s -r -p "Done. Press any key to continue..."
