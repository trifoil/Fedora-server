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

vpn_domain=$(prompt "Enter your domain for the vpn" "")

cat <<EOF > docker-compose.yaml
version: '3.8'

services:
  # WireGuard VPN service
  wireguard:
    image: linuxserver/wireguard
    container_name: wireguard
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    environment:
      - PUID=1000   # Replace with your user ID
      - PGID=1000   # Replace with your group ID
      - TZ=Europe/Brussels  # Set your timezone
      - SERVERURL=your_server_domain_or_ip
      - SERVERPORT=51820  # WireGuard server port (local UDP)
      - PEERS=1  # Number of peers (clients)
      - PEERDNS=auto
      - INTERNAL_SUBNET=10.13.13.0  # Internal WireGuard subnet
    volumes:
      - ./config/wireguard:/config
      - /lib/modules:/lib/modules
    sysctls:
      - net.ipv4.conf.all.src_valid_mark=1
      - net.ipv4.ip_forward=1
    restart: unless-stopped

  # wstunnel service to tunnel WireGuard traffic
  wstunnel:
    image: npateriy/wstunnel
    container_name: wstunnel
    command: >
      --udp 0.0.0.0:8443:127.0.0.1:51820  # Expose WireGuard over WebSockets on port 8443
    ports:
      - 8443:8443  # Expose the WebSocket tunnel on TCP port 8443
    restart: unless-stopped

EOF

#https://chatgpt.com/share/66ec33df-4800-8010-8af6-1df1e6bd309f