#!/bin/bash 

# Splyse, Inc. 2017

cd "$(dirname "$(readlink -f "$0")")"
docker build -t neo-privnet .
