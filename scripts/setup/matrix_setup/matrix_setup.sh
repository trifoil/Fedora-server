#!/bin/bash

cd "$(dirname "$0")"

echo "The script will now install the Matrix Synapse server"
echo "Updating ... "
dnf update -y

# Function to prompt user for input and set default value if input is empty
prompt() {
  local prompt_message=$1
  local default_value=$2
  read -p "$prompt_message [$default_value]: " input
  echo "${input:-$default_value}"
}

synapse_volume=$(prompt "Enter the volume path for the Matrix Synapse server" "/storage/synapse")
synapse_port=$(prompt "Enter the port for the Matrix Synapse server" "8448")
synapse_db_volume=$(prompt "Enter the volume path for the Matrix Synapse server database" "/storage/synapse/synapse_db_volume")
synapse_db_user=$(prompt "Enter the username for the Matrix Synapse server database" "synapse")
synapse_db_pwd=$(prompt "Enter the password for the Matrix Synapse server database" "changeme")

cat <<EOF > docker-compose.yaml
# This compose file is compatible with Compose itself, it might need some
# adjustments to run properly with stack.

services:

  synapse:
    build:
      context: ../..
      dockerfile: docker/Dockerfile
    image: docker.io/matrixdotorg/synapse:latest
    # Since synapse does not retry to connect to the database, restart upon
    # failure
    restart: unless-stopped
    # See the readme for a full documentation of the environment settings
    # NOTE: You must edit homeserver.yaml to use postgres, it defaults to sqlite
    environment:
      - SYNAPSE_CONFIG_PATH=/data/homeserver.yaml
    volumes:
      # You may either store all the files in a local folder
      - $synapse_volume:/data
      # .. or you may split this between different storage points
      # - ./files:/data
      # - /path/to/ssd:/data/uploads
      # - /path/to/large_hdd:/data/media
    depends_on:
      - db
    # In order to expose Synapse, remove one of the following, you might for
    # instance expose the TLS port directly:
    ports:
      - $synapse_port:8448/tcp


  db:
    image: docker.io/postgres:12-alpine
    # Change that password, of course!
    environment:
      - POSTGRES_USER=$synapse_db_user
      - POSTGRES_PASSWORD=$synapse_db_pwd
      # ensure the database gets created correctly
      # https://element-hq.github.io/synapse/latest/postgres.html#set-up-database
      - POSTGRES_INITDB_ARGS=--encoding=UTF-8 --lc-collate=C --lc-ctype=C
    volumes:
      # You may store the database tables in a local folder..
      - $synapse_db_volume:/var/lib/postgresql/data
      # .. or store them on some high performance storage for better results
      # - /path/to/ssd/storage:/var/lib/postgresql/data
EOF

echo "The docker-compose.yml has been created successfully."

docker compose up -d
docker ps

read -n 1 -s -r -p "Done. Press any key to continue..."