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
ddns_updater_port=$(prompt "Enter the port number" "8094")


mkdir -p $ddns_updater_volume



dns_provider=$(prompt "Enter the provider" "infomaniak")
root_domain=$(prompt "Enter the root domain" "example.com")

cat <<EOF > $ddns_updater_volume/config.json
{
    "settings": [
      {
        "provider": "$dns_provider",
        "domain": "$root_domain",
        "host": "@", 
        "username": "your-infomaniak-username",
        "password": "your-infomaniak-api-key",
        "ip_version": "ipv4"
      }
EOF

add_subdomains=true

while $add_subdomains; do
  add_more=$(prompt "Do you want to add another subdomain? (yes/no)" "no")
  
  if [ "$add_more" == "yes" ]; then
    subdomain=$(prompt "Enter the subdomain" "subdomain.example.com")
    cat <<EOF >> $ddns_updater_volume/config.json
      ,{
        "provider": "$dns_provider",
        "domain": "$root_domain",
        "host": "$subdomain",
        "username": "your-infomaniak-username",
        "password": "your-infomaniak-api-key",
        "ip_version": "ipv4"
      }
EOF
  else
    add_subdomains=false
  fi
done

cat <<EOF >> $ddns_updater_volume/config.json
    ],
    "period": 300
  }
EOF


cat <<EOF > docker-compose.yaml

services:
  ddns-updater:
    image: qmcgaw/ddns-updater
    container_name: ddns-updater
    network_mode: bridge
    ports:
      - 8000:8000/tcp
    volumes:
      - ./data:/updater/data
    environment:
      -  CONFIG={"settings":[{"provider":"strato","domain":"mydomain","host":"test,cloud","password":"mypassword"}]}
      -  PERIOD=5m
      -  IP_METHOD=cycle
      -  IPV4_METHOD=cycle
      -  IPV6_METHOD=cycle
      -  HTTP_TIMEOUT=10s
      -  LISTENING_PORT=8000
      -  ROOT_URL=/
    restart: always
EOF

docker run -d \
  --name ddns-updater \
  -e CONFIG=/updater/config.json \
  -v $ddns_updater_volume:/updater \
  qmcgaw/ddns-updater



docker compose up -d
docker ps

read -n 1 -s -r -p "Done. Press any key to continue..."
