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



dns_provider=$(prompt "Enter the provider" "infomaniak")
root_domain=$(prompt "Enter the root domain" "example.com")

cat <<EOF > $ddns_updater_volume
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
    cat <<EOF >> $ddns_updater_volume
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
