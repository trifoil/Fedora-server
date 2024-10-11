#!/bin/bash

cd "$(dirname "$0")"

echo "The script will now install your web js server"
echo "Updating ... "
dnf update -y

prompt() {
  local prompt_message=$1
  local default_value=$2
  read -p "$prompt_message [$default_value]: " input
  echo "${input:-$default_value}"
}

js_website_name=$(prompt "Enter the js website container name" "vanilla-js-site")
js_website_volume=$(prompt "Enter the volume for your js website" "/storage/$js_website_name")
js_website_port=$(prompt "Enter the port number" "42069")

cat <<EOF > docker-compose.yaml
services:
  web:
    image: nginx:alpine
    container_name: $js_website_name
    ports:
      - "$js_website_port:80"
    volumes:
      - $js_website_volume:/usr/share/nginx/html:ro
    restart: always

EOF

echo "The docker-compose.yaml has been created successfully."

docker compose up -d
docker ps

read -n 1 -s -r -p "Done. Press any key to continue..."