#!/bin/bash

echo "The script will now install nginx proxy manager"
echo "Updating..."
dnf update -y

mkdir /storage/npm

cd 2_nginx_compose
docker compose up -d
docker ps

read -n 1 -s -r -p "Done. Press any key to continue..."