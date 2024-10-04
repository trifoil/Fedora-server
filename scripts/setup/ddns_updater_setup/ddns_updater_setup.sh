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

mkdir $ddns_updater_volume

while [ in_menu = true ]
do 
  
done

dns_provider=$(prompt "Enter the provider" "infomaniak")
dns_domain=$(prompt "Enter the root domain" "example.com")

cat <<EOF > $ddns_updater_volume
{
    "settings": [
      {
        "provider": "$provider",
        "domain": "$dns_domain",
        "host": "@", 
        "username": "your-infomaniak-username",
        "password": "your-infomaniak-api-key",
        "ip_version": "ipv4"
      }
EOF

cat <<EOF >> $ddns_updater_volume
      ,{
        "provider": "$provider",
        "domain": "example.com",
        "host": "subdomain1",
        "username": "your-infomaniak-username",
        "password": "your-infomaniak-api-key",
        "ip_version": "ipv4"
      }
EOF

cat <<EOF >> $ddns_updater_volume
    ],
    "period": 300
  }
EOF

docker run -d \
  --name ddns-updater \
  -e CONFIG=/updater/config.json \
  -v /path/to/your/config:/updater/config.json \
  qmcgaw/ddns-updater



docker compose up -d
docker ps

read -n 1 -s -r -p "Done. Press any key to continue..."
