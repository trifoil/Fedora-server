#!/bin/bash

echo "The script will now install your php website"
echo "Updating..."
dnf update -y

cd "$(dirname "$0")"
docker compose up --build -d

docker ps

read -n 1 -s -r -p "Done. Press any key to continue..."