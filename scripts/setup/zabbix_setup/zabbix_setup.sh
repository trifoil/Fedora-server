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

zabbix_volume=$(prompt "Enter the volume for the zabbix config" "/storage/zabbix")
zabbix_port=$(prompt "Enter the port for the zabbix server" "8081")


cat <<EOF > docker-compose.yaml
services:
  db:
    image: mariadb:10.5
    environment:
      MYSQL_DATABASE: zabbix
      MYSQL_USER: zabbix
      MYSQL_PASSWORD: zabbix_pass
      MYSQL_ROOT_PASSWORD: root_pass
    volumes:
      - mysql_data:/var/lib/mysql
    networks:
      - zabbix-net


  zabbix-server:
    image: zabbix/zabbix-server-mysql:latest
    environment:
      DB_SERVER_HOST: db
      MYSQL_DATABASE: zabbix
      MYSQL_USER: zabbix
      MYSQL_PASSWORD: zabbix_pass
      MYSQL_ROOT_PASSWORD: root_pass
    depends_on:
      - db
    ports:
      - "10051:10051"
    networks:
      - zabbix-net

  zabbix-web:
    image: zabbix/zabbix-web-nginx-mysql:latest
    environment:
      DB_SERVER_HOST: db
      MYSQL_DATABASE: zabbix
      MYSQL_USER: zabbix
      MYSQL_PASSWORD: zabbix_pass
      ZBX_SERVER_HOST: zabbix-server
      PHP_TZ: Europe/Paris
    ports:
      - "8081:8080"
    depends_on:
      - db
      - zabbix-server
    networks:
      - zabbix-net

volumes:
  mysql_data:

networks:
  zabbix-net:
EOF

echo "The docker-compose.yml has been created successfully."

docker compose up -d
docker ps

read -n 1 -s -r -p "Done. Press any key to continue..."

