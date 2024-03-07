#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root" >&2
  exit 1
fi

# start of the script
echo "Yeppee"

chmod +x 0_initial_setup.sh
chmod +x 1_docker_setup.sh
chmod +x 2_nginx_setup.sh
chmod +x 3_php_site_setup.sh

./ +x 0_initial_setup.sh
./ +x 1_docker_setup.sh
./ +x 2_nginx_setup.sh
./ +x 3_php_site_setup.sh

echo "Yeppee again!"
