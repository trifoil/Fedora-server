#!/bin/bash

# Stop all running containers
docker stop $(docker ps -aq)

# Remove all containers
docker rm $(docker ps -aq)

docker ps

read -n 1 -s -r -p "Done. Press any key to continue..."