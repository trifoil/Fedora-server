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
      - PUID=1000  # Adjust this according to your user
      - PGID=1000  # Adjust this according to your group
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
    sysctls:
      - net.ipv4.conf.all.src_valid_mark=1
    restart: unless-stopped

  wstunnel:
    image: erebe/wstunnel:latest
    container_name: wstunnel
    command: wstunnel --server wss://0.0.0.0:8080 --restrictTo=127.0.0.1:51820
    restart: unless-stopped
    ports:
      - "$vpn_port:8080"

networks:
  default:
    external: true

EOF

#https://chatgpt.com/share/66ec33df-4800-8010-8af6-1df1e6bd309f