#!/bin/bash
<<<<<<< HEAD
# To use a newer neo-cli version, just update this variable:
NEO_CLI_VERSION="2.5.2"

# Definition of standard neo-cli filenames and URL based on the version
NEO_CLI_ZIPFN="neo-release-${NEO_CLI_VERSION}.zip"
NEO_CLI_URL="https://github.com/neo-project/neo-cli/releases/download/v${NEO_CLI_VERSION}/neo-cli-ubuntu.16.04-x64.zip"

if [ -z "$1" ];
then
    echo "Using default neo-cli v${NEO_CLI_VERSION}"

    if [ -e "${NEO_CLI_ZIPFN}" ]
    then
        echo "- release already downloaded: ${NEO_CLI_ZIPFN}"
    else
        echo "- downloading ${NEO_CLI_URL}..."
        wget -O $NEO_CLI_ZIPFN $NEO_CLI_URL
    fi
    cp $NEO_CLI_ZIPFN ./neo-cli.zip
else
    echo "Using custom neo-cli.zip: $1"
    cp $1 ./neo-cli.zip
fi

docker build -t neo-privnet .
=======
docker-compose build
>>>>>>> Use docker-compose to stand things up
