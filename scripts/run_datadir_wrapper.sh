#!/bin/bash
#
# This script checks if an environment variable "DATADIR" is set. If it is set, the
# script copies the chain databases into that directory and updates the node configs
# to use this chain database location.
#

if [ -n "$DATADIR" ]; then
    echo "DATADIR: $DATADIR"

    echo "Updating neo-cli config.json files to use $DATADIR..."
    sed "s|/opt/chaindata|$DATADIR|g" /opt/node1/neo-cli/config.orig.json > /opt/node1/neo-cli/config.json
    sed "s|/opt/chaindata|$DATADIR|g" /opt/node2/neo-cli/config.orig.json > /opt/node2/neo-cli/config.json
    sed "s|/opt/chaindata|$DATADIR|g" /opt/node3/neo-cli/config.orig.json > /opt/node3/neo-cli/config.json
    sed "s|/opt/chaindata|$DATADIR|g" /opt/node4/neo-cli/config.orig.json > /opt/node4/neo-cli/config.json

    sed "s|/opt/chaindata|$DATADIR|g" /opt/node1/neo-cli/Plugins/ApplicationLogs/config.orig.json > /opt/node1/neo-cli/Plugins/ApplicationLogs/config.json
    sed "s|/opt/chaindata|$DATADIR|g" /opt/node2/neo-cli/Plugins/ApplicationLogs/config.orig.json > /opt/node2/neo-cli/Plugins/ApplicationLogs/config.json
    sed "s|/opt/chaindata|$DATADIR|g" /opt/node3/neo-cli/Plugins/ApplicationLogs/config.orig.json > /opt/node3/neo-cli/Plugins/ApplicationLogs/config.json
    sed "s|/opt/chaindata|$DATADIR|g" /opt/node4/neo-cli/Plugins/ApplicationLogs/config.orig.json > /opt/node4/neo-cli/Plugins/ApplicationLogs/config.json

    if [ ! -d "$DATADIR" ] || [ ! -d "$DATADIR/node1" ] || [ ! -d "$DATADIR/node1/Chain_0000DDB1" ]; then
        echo "Copying consensus databases to $DATADIR ..."
        mkdir -p $DATADIR
        rm -rf $DATADIR/node1 $DATADIR/node2 $DATADIR/node3 $DATADIR/node4  # Just in case one of them is already there
        cp -r /opt/chaindata/* $DATADIR/
    fi
else
    echo "Resetting neo-cli configs to original datadir /opt/chaindata/ ..."
    cp /opt/node1/neo-cli/config.orig.json /opt/node1/neo-cli/config.json
    cp /opt/node2/neo-cli/config.orig.json /opt/node2/neo-cli/config.json
    cp /opt/node3/neo-cli/config.orig.json /opt/node3/neo-cli/config.json
    cp /opt/node4/neo-cli/config.orig.json /opt/node4/neo-cli/config.json

    cp /opt/node1/neo-cli/Plugins/ApplicationLogs/config.orig.json /opt/node1/neo-cli/Plugins/ApplicationLogs/config.json
    cp /opt/node2/neo-cli/Plugins/ApplicationLogs/config.orig.json /opt/node2/neo-cli/Plugins/ApplicationLogs/config.json
    cp /opt/node3/neo-cli/Plugins/ApplicationLogs/config.orig.json /opt/node3/neo-cli/Plugins/ApplicationLogs/config.json
    cp /opt/node4/neo-cli/Plugins/ApplicationLogs/config.orig.json /opt/node4/neo-cli/Plugins/ApplicationLogs/config.json
fi

# On docker run, start the consensus nodes
echo "Starting consensus nodes..."
/opt/run.sh
