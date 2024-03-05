#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root" >&2
  exit 1
fi

echo "The script will now install your tools"

dnf update

# configuring cockpit

dnf install cockpit -y
systemctl enable --now cockpit.socket

firewall-cmd --permanent --zone=public --add-service=cockpit
firewall-cmd --reload

# install and enable docker (start auto at boot)

dnf install docker -y
systemctl enable docker

systemctl start docker

# to not need to put sudo for using docker with my administrator user

usermod -aG docker administrator

docker --version



echo "Installation complete"
