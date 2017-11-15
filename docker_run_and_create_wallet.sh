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

echo "Waiting 10 seconds to let consensus nodes start..."
sleep 10

./create_wallet.sh
