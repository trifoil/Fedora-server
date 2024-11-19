#!/bin/bash
cd "$(dirname "$0")"

echo "Now installing zabbix"
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
  mysql-server:
    image: mysql:8.0
    container_name: mysql-server
    environment:
      MYSQL_DATABASE: zabbix
      MYSQL_USER: zabbix
      MYSQL_PASSWORD: zabbix_pwd
      MYSQL_ROOT_PASSWORD: root_pwd
    command: --character-set-server=utf8 --collation-server=utf8_bin --default-authentication-plugin=mysql_native_password
    volumes:
      - /storage/zabbix/mysql:/var/lib/mysql
    networks:
      - zabbix-network
    restart: unless-stopped

  zabbix-server:
    image: zabbix/zabbix-server-mysql:alpine-7.0-latest
    container_name: zabbix-server
    environment:
      DB_SERVER_HOST: mysql-server
      MYSQL_DATABASE: zabbix
      MYSQL_USER: zabbix
      MYSQL_PASSWORD: zabbix_pwd
      MYSQL_ROOT_PASSWORD: root_pwd
    volumes:
      - /storage/zabbix/zabbix-server:/var/lib/zabbix
    ports:
      - "10051:10051"
    depends_on:
      - mysql-server
    networks:
      - zabbix-network
    restart: unless-stopped

  zabbix-web:
    image: zabbix/zabbix-web-nginx-mysql:alpine-7.0-latest
    container_name: zabbix-web
    environment:
      ZBX_SERVER_HOST: zabbix-server
      DB_SERVER_HOST: mysql-server
      MYSQL_DATABASE: zabbix
      MYSQL_USER: zabbix
      MYSQL_PASSWORD: zabbix_pwd
      MYSQL_ROOT_PASSWORD: root_pwd
    volumes:
      - /storage/zabbix/zabbix-web:/usr/share/zabbix
    ports:
      - "80:8080"
    depends_on:
      - zabbix-server
    networks:
      - zabbix-network
    restart: unless-stopped

  zabbix-agent:
    image: zabbix/zabbix-agent:alpine-7.0-latest
    container_name: zabbix-agent
    environment:
      ZBX_SERVER_HOST: zabbix-server
      HOSTNAME: docker-agent
    volumes:
      - /storage/zabbix/zabbix-agent:/var/lib/zabbix-agent
    ports:
      - "10050:10050"
    depends_on:
      - zabbix-server
    networks:
      - zabbix-network
    restart: unless-stopped

networks:
  zabbix-network:
    driver: bridge


EOF

echo "The docker-compose.yml has been created successfully."

docker compose up -d
docker ps

read -n 1 -s -r -p "Done. Press any key to continue..."

