#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root" >&2
  exit 1
fi

echo "The script will now install nextcloud"
echo "Updating..."
dnf update -y

cd 4_nextcloudAIO
docker-compose up --build -d


docker exec -it nextcloud /bin/bash
DOMAIN="nextcloud.trifoil.cloudns.nz"

# Path to the Nextcloud config.php file
CONFIG_FILE="/config/config.php"

# Check if the domain is already in the trusted_domains array
if grep -q "'$DOMAIN'" "$CONFIG_FILE"; then
    echo "Domain $DOMAIN is already in the trusted_domains array."
    exit 1
fi

# Add the domain to the trusted_domains array
echo "Adding $DOMAIN to the trusted_domains array..."
sed -i "/'trusted_domains' =>/a \ \ \ \ $(printf '%b\n' "\ \ \ \ \ \ \ \ $DOMAIN,")" "$CONFIG_FILE"

echo "Domain $DOMAIN has been added to the trusted_domains array."

docker ps

read -n 1 -s -r -p "Done. Press any key to continue..."

