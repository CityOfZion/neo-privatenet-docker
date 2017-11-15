#!/bin/bash
#
# Start a Docker container which runs the four consensus nodes. If it is
# already running, it will be destroyed first.
#
CONTAINER=$(docker ps -aqf name=neo-privnet)

if [ -n "$CONTAINER" ]; then
	echo "Stopping container named neo-privnet"
	docker stop neo-privnet 1>/dev/null
	echo "Removing container named neo-privnet"
	docker rm neo-privnet 1>/dev/null
fi

echo "Starting container..."
docker run -d --name neo-privnet -p 20333-20336:20333-20336/tcp -p 30333-30336:30333-30336/tcp -h neo-privnet neo-privnet
