#!/bin/bash

echo "=> Starting NEO containers, please wait..."

docker-compose up -d

echo "=> Waiting for consensus..."

docker-compose run check-for-consensus

echo "=> Claiming GAS..."

docker-compose run neo-python

echo "=> GAS claiming complete, your NEO nodes are running on:"
