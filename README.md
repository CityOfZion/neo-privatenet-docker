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
  
  
  ## Install neo-gui or neo-gui developer
  Install one of the following: 
  
  https://github.com/neo-project/neo-gui
  
  https://github.com/CityOfZion/neo-gui-developer
  
  Edit the protocol.json in your respective neo-gui installation to point to the IP of the system running your docker.
  Please note the ports should match. A sample is provided.
  
  Find the section that looks like the following:
  
    "SeedList": [
      "127.0.0.1:20333",
      "127.0.0.1:20334",
      "127.0.0.1:20335",
      "127.0.0.1:20336"
    ],
  
  Change the 127.0.0.1 to the IP of the system or vm running your docker image.
  
  ## Extracting Neo and Gas
  Check out the docs at http://docs.neo.org/en-us/node/private-chain.html for instructions on how to claim Neo and Gas
  for testing.
  
  ## Wallet Passwords
  node1: one
  node2: two
  node3: three
  node4: four
