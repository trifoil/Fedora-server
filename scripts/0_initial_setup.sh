#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root" >&2
  exit 1
fi

# start of the script

echo "The script will now install your basic tools"

# basic shit

echo "Updating..."
dnf update -y
echo "installing btop, git and fastfetch"
dnf install btop git fastfetch -y

# configuring cockpit

echo "installing and configuring cockpit"
dnf install cockpit -y
systemctl enable --now cockpit.socket
firewall-cmd --permanent --zone=public --add-service=cockpit
firewall-cmd --reload

dnf -y remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

dnf -y install dnf-plugins-core
dnf -y config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo systemctl start docker

# make the system not hibernate

#echo "lazy computer should not sleep"
#systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# connection informations

echo "You can now connect at :"
ip a | grep -E 'inet\s' | grep -v '127.0.0.1' | awk '{print $2}' | awk -F/ '{print $1}'
echo "on port 9090"

# end of the script

read -n 1 -s -r -p "Done. Press any key to continue..."