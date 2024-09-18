#!/bin/bash

cd "$(dirname "$0")"

echo "The script will now install NGINX proxy manager"
echo "Updating ... "
dnf update -y


# Function to prompt user for input and set default value if input is empty
prompt() {
  local prompt_message=$1
  local default_value=$2
  read -p "$prompt_message [$default_value]: " input
  echo "${input:-$default_value}"
}

# Prompt user for necessary inputs
db_mysql_password=$(prompt "Enter DB MySQL password" "npm")
db_mysql_root_password=$(prompt "Enter DB MySQL root password" "npm")
volume_data=$(prompt "Enter the volume path for NGINX Proxy Manager data" "/storage/npm/data")
volume_letsencrypt=$(prompt "Enter the volume path for Let's Encrypt" "/storage/npm/letsencrypt")
volume_mysql=$(prompt "Enter the volume path for MySQL data" "/storage/npm/mysql")

# Write to docker-compose.yaml
cat <<EOF > docker-compose.yaml
services:
  app:
    container_name: NGINX-proxy-manager
    image: 'jc21/nginx-proxy-manager:latest'
    restart: always
    ports:
      - '80:80' # Public HTTP Port
      - '443:443' # Public HTTPS Port
      - '81:81' # Admin Web Port
    environment:
      DB_MYSQL_HOST: "db"
      DB_MYSQL_PORT: 3306
      DB_MYSQL_USER: "npm"
      DB_MYSQL_PASSWORD: "$db_mysql_password"
      DB_MYSQL_NAME: "npm"
    volumes:
      - $volume_data:/data
      - $volume_letsencrypt:/etc/letsencrypt
    depends_on:
      - db
    privileged: true

  db:
    container_name: NGINX-proxy-manager-DB
    image: 'jc21/mariadb-aria:latest'
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: "$db_mysql_root_password"
      MYSQL_DATABASE: "npm"
      MYSQL_USER: "npm"
      MYSQL_PASSWORD: "$db_mysql_password"
      MARIADB_AUTO_UPGRADE: '1'
    volumes:
      - $volume_mysql:/var/lib/mysql
    privileged: true
EOF

echo "The docker-compose.yml has been created successfully."

docker compose up -d
docker ps

read -n 1 -s -r -p "Done. Press any key to continue..."