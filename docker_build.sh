#!/bin/bash
if [ -z "$1" ]; 
then
    echo "no neo-cli.zip provided - fetching default neo-cli" 
    wget -O /opt/neo-cli.zip https://github.com/neo-project/neo-cli/releases/download/v2.4.1/neo-cli-ubuntu.16.04-x64.zip
else
    echo "local neo-cli.zip provided - copying" 
    cp $1 /opt/neo-cli.zip
fi

docker build -t neo-privnet .
