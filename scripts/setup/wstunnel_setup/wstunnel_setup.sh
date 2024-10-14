#!/bin/bash

cd "$(dirname "$0")"

echo "The script will now install the VPN"
echo "Updating ... "
dnf update -y

prompt() {
  local prompt_message=$1
  local default_value=$2
  read -p "$prompt_message [$default_value]: " input
  echo "${input:-$default_value}"
}

input_port=$(prompt "Enter your domain for the vpn service" "51820")
output_port=$(prompt "Enter the volume for the vpn service" "8069")

