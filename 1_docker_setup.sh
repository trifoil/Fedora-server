#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root" >&2
  exit 1
fi

echo "The script will now install your containers"
echo "Updating..."
dnf update -y

# install and enable docker (start auto at boot)

dnf install docker -y
systemctl enable docker
systemctl start docker

# and to not need to put sudo for your current user

usermod -aG docker $USER

# install docker-compose

dnf install docker-compose -y

# pull and run the portainer image it needs to be privileged because it is conflicting SELinx

docker volume create portainer_data
docker run -d --privileged -p 9443:9443 -p 8000:8000 --name portainer --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

# display docker version

docker --version


echo "Script 1 complete"