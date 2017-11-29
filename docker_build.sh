#!/bin/bash
if [ -z "$1" ]; 
    then wget -O /opt/neo-cli.zip https://github.com/neo-project/neo-cli/releases/download/v2.4.1/neo-cli-ubuntu.16.04-x64.zip
    else cp $1 /opt/neo-cli.zip
fi

docker build -t neo-privnet .
