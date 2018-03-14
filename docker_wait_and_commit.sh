#!/bin/bash
#
# Waits until a specific block (range) is reached, and then commits the Docker image.
#

function usage {
    echo "Usage: $0 [--2k|--10k|--20k|--until-block <block-number-regex>]"
    echo "Default: 2k"
}

while [[ "$#" > 0 ]]; do case $1 in
    -h)
        usage
        exit 0
        ;;
    --2k)
        UNTIL_BLOCK="200[1-9]"
        shift
        ;;
    --10k)
        UNTIL_BLOCK="1000[1-9]"
        shift
        ;;
    --20k)
        UNTIL_BLOCK="2000[1-9]"
        shift
        ;;
    --until-block)
        if [ -z $2 ]; then usage; exit 1; fi
        UNTIL_BLOCK=$2
        shift
        shift
        ;;
    *)
        usage
        exit 1
        ;;
  esac;
done

if [ -z $UNTIL_BLOCK ]; then
  UNTIL_BLOCK="200[1-9]"
fi

echo "Waiting until block $UNTIL_BLOCK"

while true; do
    cnt=`curl -s -X POST http://localhost:30333 -H 'Content-Type: application/json' -d '{ "jsonrpc": "2.0", "id": 5, "method": "getblockcount", "params": [] }'`
    echo $cnt
    is2k=`echo $cnt | grep "$UNTIL_BLOCK"`
    if [ $? -eq 0 ]; then
      break
    fi
    sleep 30
done

echo "Reached block target of $UNTIL_BLOCK"

echo "Claiming GAS..."
CLAIM_CMD="python3.6 /neo-python/claim_gas_fixedwallet.py"
DOCKER_CMD="docker exec -it neo-privnet ${CLAIM_CMD}"
echo $DOCKER_CMD
echo
($DOCKER_CMD)

#echo "Cleaning up the screenss..."
#DOCKER_CMD="docker exec -it neo-privnet screen -wipe"

echo "Committing docker image as neo-privatenet:latest"
docker commit neo-privnet neo-privatenet:latest

echo "Next steps:"
echo "- docker tag neo-privatenet:latest cityofzion/neo-privatenet:latest"
echo "- docker tag neo-privatenet:latest cityofzion/neo-privatenet:<version>"
echo "- docker push cityofzion/neo-privatenet:latest cityofzion/neo-privatenet:<version>"
