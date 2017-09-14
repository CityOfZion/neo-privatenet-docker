# neo-privatenet-docker

Here we have provided a convenient way to setup a private Neo blockchain with an Ubuntu 16.04 docker image.
Please review Dockerfile for details of software. 

This image is meant to skip the overhead of having to wait to get enough gas for smart contract testing on testnet and to bypass the steps of creating your own private chain.

See the section below on extracting Neo and Gas as the private chain in this docker image starts at block height 0.

You will also need to install and configure the neo-gui pc client on your favorite distro. This involves editing the protocol.json file to point the seeds at your docker IP addresses.


## Installation Instructions
    git clone https://github.com/Splyse/neo-privatenet-docker.git
    cd neo-privatenet-docker
    ./docker_build.sh
    ./docker_run.sh
  
  
  ## Extracting Neo and Gas
  Check out the docs at http://docs.neo.org/en-us/node/private-chain.html for instructions on how to claim Neo and Gas
  for testing.
  
  ## Wallet Passwords
  node1: one
  node2: two
  node3: three
  node4: four
