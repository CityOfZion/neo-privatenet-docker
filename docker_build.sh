#!/bin/bash
if [ -z "$1" ]; 
then    
    if [ -e neo-release241.zip ]
    then
        echo "no neo-cli.zip provided - release already downloaded" 
    else
        echo "no neo-cli.zip provided - downloading now" 
        wget -O ./neo-release241.zip https://github.com/neo-project/neo-cli/releases/download/v2.4.1/neo-cli-ubuntu.16.04-x64.zip
    fi
    cp ./neo-release241.zip ./neo-cli.zip
else
    echo "local neo-cli.zip provided - copying" 
    cp $1 ./neo-cli.zip
fi

docker build -t neo-privnet .
