#!/bin/bash

# Spylse Inc. 2017


CONTAINER=$(docker ps -aqf name=neo-privnet)

if [ -n "$CONTAINER" ]; then
	echo "Stopping container named neo-privnet"
	docker stop neo-privnet 1>/dev/null
	echo "Removing container named neo-privnet"
	docker rm neo-privnet 1>/dev/null
fi

echo "Starting container..."
docker run -d --name neo-privnet -p 20333-20336:20333-20336/tcp -h neo-privnet neo-privnet /bin/bash /opt/private_chain_start.sh /opt/
