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
version: '3'
services:
  wireguard:
    image: linuxserver/wireguard
    container_name: wireguard
    cap_add:
      - NET_ADMIN
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - SERVERURL=<YOUR_DOMAIN_OR_IP>   # Replace with your actual domain or public IP
      - SERVERPORT=51820
      - PEERS=1 # Adjust this to the number of clients you want
      - PEERDNS=auto
    volumes:
      - ./config:/config
      - /lib/modules:/lib/modules
    ports:
      - "51820:51820/udp"  # Exposing WireGuard over UDP
    sysctls:
      - net.ipv4.ip_forward=1
      - net.ipv6.conf.all.forwarding=1
    restart: unless-stopped
    networks:
      - vpn_net

  stunnel:
    image: alpine/stunnel
    container_name: stunnel
    volumes:
      - ./stunnel:/etc/stunnel  # Stunnel config and certificates
    expose:
      - "443"  # Internal to NPM
    restart: unless-stopped
    command: stunnel /etc/stunnel/stunnel.conf
    depends_on:
      - wireguard
    networks:
      - vpn_net

networks:
  vpn_net:
    driver: bridge

EOF

#https://chatgpt.com/share/66ec33df-4800-8010-8af6-1df1e6bd309f