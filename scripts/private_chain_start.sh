#!/bin/bash

screen -dmS node1 expect ${1}/start_cli.sh ${1}/node1/neo-cli/ wallet1.db3 one
screen -dmS node2 expect ${1}/start_cli.sh ${1}/node2/neo-cli/ wallet2.db3 two
screen -dmS node3 expect ${1}/start_cli.sh ${1}/node3/neo-cli/ wallet3.db3 three
screen -dmS node4 expect ${1}/start_cli.sh ${1}/node4/neo-cli/ wallet4.db3 four

sleep infinity

