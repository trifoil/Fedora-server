#!/bin/bash
cd "$(dirname "$0")"

echo "Now installing radius"
echo "Updating ... "
dnf update -y



cat <<EOF > docker-compose.yaml
version: '3.7'

services:
  freeradius:
    image: freeradius/freeradius-server:latest
    container_name: freeradius
    environment:
      - MYSQL_HOST=freeradius-db
      - MYSQL_USER=radius
      - MYSQL_PASSWORD=radius
      - MYSQL_DB=radius
    volumes:
      - ./freeradius/config:/etc/freeradius/3.0
    ports:
      - "1812:1812"
      - "1813:1813"
    depends_on:
      - freeradius-db
    networks:
      - freeradius-net

  freeradius-admin:
    image: junelsolis/freeradius-admin:latest
    container_name: freeradius-admin
    environment:
      - DB_HOST=freeradius-db
      - DB_USER=radius
      - DB_PASSWORD=radius
      - DB_NAME=radius
      - APP_URL=http://localhost:8000
    ports:
      - "8000:80"
    depends_on:
      - freeradius-db
    networks:
      - freeradius-net

  freeradius-db:
    image: mysql:5.7
    container_name: freeradius-db
    environment:
      - MYSQL_ROOT_PASSWORD=rootpassword
      - MYSQL_DATABASE=radius
      - MYSQL_USER=radius
      - MYSQL_PASSWORD=radius
    volumes:
      - freeradius-db-data:/var/lib/mysql
    networks:
      - freeradius-net

networks:
  freeradius-net:
    driver: bridge

volumes:
  freeradius-db-data:

EOF

echo "The docker-compose.yml has been created successfully."

docker compose up -d
docker ps

read -n 1 -s -r -p "Done. Press any key to continue..."

