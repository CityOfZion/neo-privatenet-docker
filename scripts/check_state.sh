#!/bin/bash

NODE_DIR=$1
NODE_COUNT=0
CONSENSUS_COUNT=4

echo "=> Checking how many nodes are connected..."

while [ $NODE_COUNT -lt $CONSENSUS_COUNT ]
do
  NODES=$(expect -c "cd ${NODE_DIR}; spawn dotnet neo-cli.dll; expect \"neo>\";sleep 0.2;send \"show state\n\";send \"exit\n\";interact" | tr -d '\0')
  NODE_COUNT=$(echo `expr "$NODES" : '.* Nodes: \([0-9]\)'`)
  echo "=> $NODE_COUNT/$CONSENSUS_COUNT connected"
  sleep 0.5
done

echo "=> Cluster has attained consensus!"
