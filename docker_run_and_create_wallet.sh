#!/bin/bash
#
# This script starts the privnet Docker container and:
#
# 1. Create a wallet
# 2. Claim initial NEO and GAS
#
# This will take about 5 minutes.
#
# The output is a wallet file and a WIF key. Both are copied
# into the current directory:
#
# - neo-privnet.wallet (pwd: neo)
# - neo-privnet.wif
#

./docker_run.sh

WALLET_PWD="coz"

echo "Waiting 10 seconds to let consensus nodes start..."
sleep 10

echo "Starting script to claim NEO and GAS..."
CLAIM_CMD="python3.5 /opt/neo-python/contrib/privnet-claim-neo-and-gas.py -o /tmp/wallet -p ${WALLET_PWD} -w /tmp/wif"
DOCKER_CMD="docker exec -it neo-privnet ${CLAIM_CMD}"
echo $DOCKER_CMD
echo
($DOCKER_CMD)

echo
echo "Copying wallet file and wif key out of Docker container..."
docker cp neo-privnet:/tmp/wif ./neo-privnet.wif
docker cp neo-privnet:/tmp/wallet ./neo-privnet.wallet

echo
echo "--------------------"
echo
echo "All done! You now have 2 files in the current directory:"
echo
echo "  neo-privnet.wallet .. a wallet you can use with neo-python (pwd: ${WALLET_PWD})"
echo "  neo-privnet.wif ..... a wif private key you can import into other clients"
echo
echo "Enjoy!"
