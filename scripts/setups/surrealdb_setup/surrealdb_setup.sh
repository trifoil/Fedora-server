#!/bin/bash

# Change to the directory where the script is located
cd "$(dirname "$0")"

echo "The script will now set up SurrealDB using Docker Compose."
echo "Updating system..."
sudo dnf update -y

# Function to prompt user for input and set default value if input is empty
prompt() {
  local prompt_message=$1
  local default_value=$2
  read -p "$prompt_message [$default_value]: " input
  echo "${input:-$default_value}"
}

# Prompt user for necessary inputs
data_volume=$(prompt "Enter the volume path for SurrealDB data" "/storage/surrealdb/data")
db_user=$(prompt "Enter the SurrealDB root username" "root")
db_password=$(prompt "Enter the SurrealDB root password" "root")
host_port=$(prompt "Enter the host port to map to SurrealDB's port 8000" "8000")

# Create the data directory if it doesn't exist
mkdir -p "$data_volume"

# Define the database file path within the storage directory
db_file_path="$data_volume/mydatabase.db"

# Write to docker-compose.yml
cat <<EOF > docker-compose.yml
services:
  surrealdb:
    image: surrealdb/surrealdb:latest
    container_name: surrealdb
    ports:
      - "$host_port:8000"
    volumes:
      - $data_volume:/mydata
    command: 
      - start 
      - --log trace 
      - --user $db_user 
      - --pass $db_password 
    restart: unless-stopped
EOF

echo "The docker-compose.yml has been created successfully."

# Start the SurrealDB service using Docker Compose
docker compose up -d

# List running containers
docker ps

read -n 1 -s -r -p "Done. Press any key to continue..."
