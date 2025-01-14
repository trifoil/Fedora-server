#!/bin/bash

cd "$(dirname "$0")"

echo "The script will now install the WG VPN server"
echo "Updating ... "
dnf update -y

prompt() {
  local prompt_message=$1
  local default_value=$2
  read -p "$prompt_message [$default_value]: " input
  echo "${input:-$default_value}"
}

volume_data=$(prompt "Enter the volume for unobfuscated wireguard vpn" "/storage/vpn/wg")

dnf install -y dnf-plugins-core -y
dnf install wireguard-tools -y
modprobe wireguard
mkdir -p /path/to/wireguard/config
docker pull lscr.io/linuxserver/wireguard:latest
cat <<EOF >docker-compose.yaml

services:
  wireguard:
    image: lscr.io/linuxserver/wireguard:latest
    container_name: wireguard
    cap_add:
      - NET_ADMIN
      - SYS_MODULE #optional
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - SERVERURL=trifoil.be #optional
      - SERVERPORT=51820 #optional
      - PEERS=1 #optional
      - PEERDNS=auto #optional
      #- INTERNAL_SUBNET=192.168.1.0 #optional
      - ALLOWEDIPS=0.0.0.0/0 #optional
      - PERSISTENTKEEPALIVE_PEERS= #optional
      - LOG_CONFS=true #optional
    volumes:
      - $volume_data:/config
      - /lib/modules:/lib/modules #optional
    sysctls:
      - net.ipv4.conf.all.src_valid_mark=1
    restart: unless-stopped

  wstunnel:
    image: erebe/wstunnel:latest
    container_name: wstunnel
    command: server --restrict-http-upgrade-path-prefix "<secret>" --restrict-to wireguard:51820 wss://0.0.0.0:8888
    ports:
      - 8888:8888
    restart: unless-stopped

networks:
  default:
    name: wireguard_network


EOF

docker compose up -d

read -n 1 -s -r -p "Done. Press any key to continue..."