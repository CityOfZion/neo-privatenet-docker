#!/bin/bash
#
# Starts four consensus nodes.
#
<<<<<<< HEAD
CONTAINER_NAME="neo-privnet"
CONTAINER=$(docker ps -aqf name=$CONTAINER_NAME)

if [ -n "$CONTAINER" ]; then
	echo "Stopping container named $CONTAINER_NAME"
	docker stop $CONTAINER_NAME 1>/dev/null
	echo "Removing container named $CONTAINER_NAME"
	docker rm $CONTAINER_NAME 1>/dev/null
fi

echo "Starting container..."
docker run -d --name $CONTAINER_NAME -p 20333-20336:20333-20336/tcp -p 30333-30336:30333-30336/tcp -h $CONTAINER_NAME $CONTAINER_NAME
=======

docker-compose up -d
>>>>>>> Use docker-compose to stand things up
