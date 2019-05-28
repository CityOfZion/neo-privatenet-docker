#!/bin/bash
#
# This script checks if an environment variable "DATADIR" is set. If it is set, the
# script copies the chain databases into that directory and updates the node configs
# to use this chain database location.
#

if [ -n "$DATADIR" ]; then
    echo "DATADIR: $DATADIR"

    echo "Updating neo-cli config.json files to use $DATADIR..."
    sed "s|DATADIR|$DATADIR|g" /opt/node1/neo-cli/config.datadir.json > /opt/node1/neo-cli/config.json
    sed "s|DATADIR|$DATADIR|g" /opt/node2/neo-cli/config.datadir.json > /opt/node2/neo-cli/config.json
    sed "s|DATADIR|$DATADIR|g" /opt/node3/neo-cli/config.datadir.json > /opt/node3/neo-cli/config.json
    sed "s|DATADIR|$DATADIR|g" /opt/node4/neo-cli/config.datadir.json > /opt/node4/neo-cli/config.json

    if [ ! -d "$DATADIR" ] || [ ! -d "$DATADIR/node1" ] || [ ! -d "$DATADIR/node1/Chain_0000DDB1" ]; then
        echo "Creating $DATADIR/nodeX paths..."
        mkdir -p /data/node1
        mkdir -p /data/node2
        mkdir -p /data/node3
        mkdir -p /data/node4

        echo "Copying consensus databases to $DATADIR/..."
        cp -r /opt/chaindata/* $DATADIR/
    fi
else
    cp /opt/node1/neo-cli/config.orig.json /opt/node1/neo-cli/config.json
    cp /opt/node2/neo-cli/config.orig.json /opt/node2/neo-cli/config.json
    cp /opt/node3/neo-cli/config.orig.json /opt/node3/neo-cli/config.json
    cp /opt/node4/neo-cli/config.orig.json /opt/node4/neo-cli/config.json
fi

# On docker run, start the consensus nodes
echo "Starting consensus nodes..."
/opt/run.sh
