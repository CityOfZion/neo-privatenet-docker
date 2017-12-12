#!/bin/bash
if [ -z "$1" ];
then
    if [ -e neo-release241.zip ]
    then
        echo "no neo-cli.zip provided - release already downloaded"
    else
        echo "no neo-cli.zip provided - downloading now"
        wget -O ./neo-release250.zip https://github.com/neo-project/neo-cli/releases/download/v2.5.0/neo-cli-ubuntu.16.04-x64.zip
    fi
    cp ./neo-release250.zip ./neo-cli.zip
else
    echo "local neo-cli.zip provided - copying"
    cp $1 ./neo-cli.zip
fi

docker build -t neo-privnet .
