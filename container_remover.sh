#!/bin/bash

echo "Containers running prior removal"

docker ps

# Stop all running containers
docker stop $(docker ps -aq)
docker-compose down -v -f $(docker ps -aq)
# Remove all containers
docker rm $(docker ps -aq)

docker ps

read -n 1 -s -r -p "Done. Press any key to continue..."