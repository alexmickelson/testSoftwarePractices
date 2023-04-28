#!/bin/bash

# Set the name of the container to check
CONTAINER_NAME="development-myblazorserverapp-1"

# Get the container ID
CONTAINER_ID=$(docker ps -aqf "name=$CONTAINER_NAME")

# Get the health status of the container
HEALTH=$(docker inspect --format='{{json .State.Health}}' $CONTAINER_ID)

# Check if the container is healthy
if [[ "$HEALTH" =~ "healthy" ]]; then
    echo "Container $CONTAINER_NAME is healthy!"
else
    echo "Container $CONTAINER_NAME is not healthy."
fi
