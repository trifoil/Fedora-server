#!/bin/bash
cd "$(dirname "$0")"

echo "Now installing OpenVPN"
echo "Updating ... "
dnf update -y

prompt() {
  local prompt_message=$1
  local default_value=$2
  read -p "$prompt_message [$default_value]: " input
  echo "${input:-$default_value}"
}

openvpn_volume=$(prompt "Enter the volume for the OpenVPN config" "/storage/openvpn")
openvpn_tcp_port=$(prompt "Enter the TCP port for the OpenVPN config" "443")
openvpn_udp_port=$(prompt "Enter the UDP port for the OpenVPN config" "1194")
openvpn_webui=$(prompt "Enter the webUI port for the OpenVPN config" "943")

cat <<EOF > docker-compose.yaml
services:
  openvpn-as:
    image: openvpn/openvpn-as
    container_name: openvpn-as
    cap_add:
      - NET_ADMIN
    ports:
      - $openvpn_webui:943
      - $openvpn_tcp_port:443
      - $openvpn_udp_port:1194/udp
    volumes:
      - $openvpn_volume:/openvpn
    restart: unless-stopped
EOF

echo "The docker-compose.yml has been created successfully."

docker compose up -d
docker ps

read -n 1 -s -r -p "Done. Press any key to continue..."