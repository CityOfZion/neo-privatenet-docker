#!/bin/bash

WALLET_PWD="coz"

echo "Starting script to claim NEO and GAS..."
<<<<<<< HEAD
CLAIM_CMD="python3.5 /opt/neo-python/claim_neo_and_gas.py -o /tmp/wallet -p ${WALLET_PWD} -w /tmp/wif"
DOCKER_CMD="docker exec -it neo-privnet ${CLAIM_CMD}"
=======
CLAIM_CMD="/opt/neo-python/scripts/privnet-claim-neo-and-gas.py -o /wallets/wallet -p ${WALLET_PWD} -w /wallets/wif"
DOCKER_CMD="docker-compose run -T neo-python ${CLAIM_CMD}"
>>>>>>> Use docker-compose to stand things up
echo $DOCKER_CMD
echo
($DOCKER_CMD)

echo
echo "--------------------"
echo
echo "All done! You now have 2 files in the current directory:"
echo
echo "  neo-privnet.wallet .. a wallet you can use with neo-python (pwd: ${WALLET_PWD})"
echo "  neo-privnet.wif ..... a wif private key you can import into other clients"
echo
echo "Enjoy!"
