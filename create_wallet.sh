#!/bin/bash
echo "Starting script to claim NEO and GAS..."
CLAIM_CMD="python3.5 /opt/neo-python/claim_neo_and_gas_fixedwallet.py"
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
echo "  neo-privnet.wallet .. a wallet you can use with neo-python (pwd: coz)"
echo "  neo-privnet.wif ..... a wif private key you can import into other clients"
echo
echo "Enjoy!"
