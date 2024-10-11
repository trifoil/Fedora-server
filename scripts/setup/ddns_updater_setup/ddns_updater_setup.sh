#!/bin/bash

# Navigate to the directory containing the script
cd "$(dirname "$0")"

# Display start messages
echo "The script will now install ddns updater"
echo "Updating ... "
dnf update -y

# Function to prompt user input with a default value
prompt() {
  local prompt_message=$1
  local default_value=$2
  read -p "$prompt_message [$default_value]: " input
  echo "${input:-$default_value}"
}

# Prompt for DDNS updater volume and port
ddns_updater_volume=$(prompt "Enter the volume for ddns updater" "/storage/ddns_updater")
ddns_updater_port=$(prompt "Enter the port number" "8094")

# Create the volume directory
mkdir -p $ddns_updater_volume

# Prompt for DNS provider details
dns_provider=$(prompt "Enter the provider" "infomaniak")
root_domain=$(prompt "Enter the root domain" "example.com")
username=$(prompt "Enter the username (for your DNS provider)" "your-infomaniak-username")
api_key=$(prompt "Enter the API key (for your DNS provider)" "your-infomaniak-api-key")

# Create the config.json file for DDNS updater
cat <<EOF > $ddns_updater_volume/config.json
{
    "settings": [
      {
        "provider": "$dns_provider",
        "domain": "$root_domain",
        "host": "@", 
        "username": "$username",
        "password": "$api_key",
        "ip_version": "ipv4"
      }
EOF

# Allow the user to add subdomains in the configuration
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
        "username": "$username",
        "password": "$api_key",
        "ip_version": "ipv4"
      }
EOF
  else
    add_subdomains=false
  fi
done

# Complete the config.json file
cat <<EOF >> $ddns_updater_volume/config.json
    ],
    "period": 300
  }
EOF

echo "The config.json has been created successfully."

# Create the docker-compose.yaml file
cat <<EOF > docker-compose.yaml
version: '3.8'

services:
  ddns-updater:
    image: qmcgaw/ddns-updater
    container_name: ddns-updater
    network_mode: bridge
    ports:
      - $ddns_updater_port:8000/tcp
    volumes:
      - $ddns_updater_volume:/updater/data
    environment:
      - CONFIG_FILE=/updater/data/config.json
      - PERIOD=5m
      - IP_METHOD=cycle
      - IPV4_METHOD=cycle
      - IPV6_METHOD=cycle
      - HTTP_TIMEOUT=10s
      - LISTENING_PORT=$ddns_updater_port
      - ROOT_URL=/
    restart: always
    privileged: true

EOF


echo "The docker-compose.yaml has been created successfully."

# Start the docker container
docker compose up -d

chmod 755 $ddns_updater_volume

# Show running containers
docker ps

# Wait for user input to finish
read -n 1 -s -r -p "Done. Press any key to continue..."