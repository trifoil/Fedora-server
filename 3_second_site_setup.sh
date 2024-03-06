#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root" >&2
  exit 1
fi

echo "The script will now install nginx proxy manager"
echo "Updating..."
dnf update -y

cd second_test
docker-compose up -d

docker ps

echo "Installation complete"