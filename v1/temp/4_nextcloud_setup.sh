#!/bin/bash


echo "The script will now install nextcloud"
echo "Updating..."
dnf update -y

cd 4_nextcloud
docker-compose up --build -d



docker ps

read -n 1 -s -r -p "Done. Press any key to continue..."

