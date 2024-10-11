#!/bin/bash

# Navigate to the directory containing the script
cd "$(dirname "$0")"

# Display start messages
echo "The script will now install your sotf server"
echo "Updating ... "
dnf update -y

# Function to prompt user input with a default value
prompt() {
  local prompt_message=$1
  local default_value=$2
  read -p "$prompt_message [$default_value]: " input
  echo "${input:-$default_value}"
}

sotf_volume=$(prompt "Enter the volume for the sotf server" "/storage/sotf")

cat <<EOF > docker-compose.yaml
version: '3.9'
services:
  sons-of-the-forest-dedicated-server:
    container_name: sons-of-the-forest-dedicated-server
    image: jammsen/sons-of-the-forest-dedicated-server:latest
    restart: always
    environment:
      ALWAYS_UPDATE_ON_START: 1
      SKIP_NETWORK_ACCESSIBILITY_TEST: false
    ports:
      - 8766:8766/udp
      - 27016:27016/udp
      - 9700:9700/udp
    volumes:
      - $sotf_volume/steamcmd:/steamcmd
      - $sotf_volume/game:/sonsoftheforest
      - $sotf_volume/winedata:/winedata

EOF

echo "The docker-compose.yaml has been created successfully."

docker compose up -d
docker ps

read -n 1 -s -r -p "Done. Press any key to continue..."