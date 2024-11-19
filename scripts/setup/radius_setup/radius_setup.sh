#!/bin/bash
cd "$(dirname "$0")"

echo "Now installing radius"
echo "Updating ... "
dnf update -y

prompt() {
  local prompt_message=$1
  local default_value=$2
  read -p "$prompt_message [$default_value]: " input
  echo "${input:-$default_value}"
}

radius_volume=$(prompt "Enter the volume for the zabbix config" "/storage/radius")
radius_port=$(prompt "Enter the port for the zabbix server" "8080")


cat <<EOF > docker-compose.yaml
version: '3.8'
services:
  freeradius:
    image: freeradius/freeradius-server:latest
    container_name: freeradius
    ports:
      - "1812:1812/udp"  # RADIUS authentication port
      - "1813:1813/udp"  # RADIUS accounting port
    environment:
      - FREERADIUS_DEBUG=yes
    volumes:
      - ./radius-config:/etc/raddb  # Replace with your RADIUS configuration folder
      - ./radius-data:/var/lib/radius # Persisted data (optional)
    restart: unless-stopped

  daloradius:
    image: instrumentationlabs/daloradius
    container_name: daloradius
    ports:
      - "8080:80"  # Web interface accessible on http://localhost:8080
    environment:
      - DB_HOST=radius-mysql
      - DB_PORT=3306
      - DB_USER=radius
      - DB_PASS=radiuspassword
      - DB_NAME=radius
    depends_on:
      - radius-mysql
    volumes:
      - ./daloradius-config:/var/www/html/daloradius/library/daloradius.conf.php  # Optional customization
    restart: unless-stopped

  radius-mysql:
    image: mariadb:latest
    container_name: radius-mysql
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: radius
      MYSQL_USER: radius
      MYSQL_PASSWORD: radiuspassword
    volumes:
      - ./mysql-data:/var/lib/mysql
    restart: unless-stopped

EOF

echo "The docker-compose.yml has been created successfully."

docker compose up -d
docker ps

read -n 1 -s -r -p "Done. Press any key to continue..."

