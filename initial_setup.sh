#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root" >&2
  exit 1
fi

echo "The script will now install your basic tools"

dnf update

dnf install btop git fastfetch -y

# configuring cockpit

dnf install cockpit -y
systemctl enable --now cockpit.socket

firewall-cmd --permanent --zone=public --add-service=cockpit
firewall-cmd --reload

echo You can now connect at :

ip a | grep -E 'inet\s' | grep -v '127.0.0.1' | awk '{print $2}' | awk -F/ '{print $1}'


echo "Installation complete"

