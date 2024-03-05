#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root" >&2
  exit 1
fi

echo "The script will now install your tools"

apt update

# configuring cockpit

dnf install cockpit -y
systemctl enable --now cockpit.socket

sudo firewall-cmd --permanent --zone=public --add-service=cockpit
sudo firewall-cmd --reload

# 

echo "Installation complete"
