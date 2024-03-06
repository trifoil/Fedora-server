#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root" >&2
  exit 1
fi

echo "The script will now install your basic tools"

# basic shit

echo "Updating..."
dnf update
echo "installing btop, git and fastfetch"
dnf install btop git fastfetch -y

# configuring cockpit

echo "installing and configuring cockpit"
dnf install cockpit -y
systemctl enable --now cockpit.socket
firewall-cmd --permanent --zone=public --add-service=cockpit
firewall-cmd --reload

# make the system not hibernate

echo "lazy computer should not sleep"
systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# connection informations

echo "You can now connect at :"
ip a | grep -E 'inet\s' | grep -v '127.0.0.1' | awk '{print $2}' | awk -F/ '{print $1}'
echo "on port 9090"

# end of the script

echo "Installation complete"
