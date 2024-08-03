#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root" >&2
  exit 1
fi

echo "The script will now install your php website"
echo "Updating..."
dnf update -y

cd 3_apache-php-fpm-app
docker-compose up --build -d

docker ps

read -n 1 -s -r -p "Done. Press any key to continue..."