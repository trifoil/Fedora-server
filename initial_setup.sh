#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root" >&2
  exit 1
fi

echo "The script will now install your tools"

dnf update

dnf install btop git fastfetch -y

# configuring cockpit

dnf install cockpit -y
systemctl enable --now cockpit.socket

firewall-cmd --permanent --zone=public --add-service=cockpit
firewall-cmd --reload

echo You can now connect at :

ip a | grep -E 'inet\s' | grep -v '127.0.0.1' | awk '{print $2}' | awk -F/ '{print $1}'

# install and enable docker (start auto at boot)

dnf install docker -y
systemctl enable docker

systemctl start docker

# to not need to put sudo for using docker with my administrator user 

usermod -aG docker administrator

# and to not need to put sudo for your current user

usermod -aG docker $USER

# pull and run the portainer image

docker pull portainer/portainer-ce

sudo docker run -d -p 9000:9000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock portainer/portainer-ce
firewall-cmd --permanent --zone=public --add-service=portainer
firewall-cmd --reload


docker --version


echo "Installation complete"
