#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root" >&2
  exit 1
fi


echo "The script will now install nginx proxy manager"
echo "Updating..."
dnf update -y

cd 2_nginx_compose
docker compose up -d

docker ps

read -n 1 -s -r -p "Done. Press any key to continue..."