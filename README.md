
<p align="center">
  <img 
    src="http://res.cloudinary.com/vidsy/image/upload/v1503160820/CoZ_Icon_DARKBLUE_200x178px_oq0gxm.png" 
    width="125px"
  >
</p>

<h1 align="center">neo-privatenet-docker</h1>

<p align="center">
  Repo for running a local privatenet NEO cluster using docker.
</p>

<p align="center">
  <a href="https://github.com/stevenjack/neo-privatenet-docker/releases">
    <img src="https://img.shields.io/github/tag/stevenjack/neo-privatenet-docker.svg?style=flat">
  </a>
  <a href="https://circleci.com/gh/stevenjack/neo-privatenet-docker/tree/master">
    <img src="https://circleci.com/gh/stevenjack/neo-privatenet-docker/tree/master.svg?style=shield">
  </a>
</p>

## What?

- Set of scripts for Linux, OSX and Windows to simply run a local NEO cluster using docker.
- Created to skip the overhead of having to wait to get enough gas for smart contract testing on testnet and to bypass the steps of creating your own private chain.
- Run using docker compose.
- Creates a 4 node cluster that can be interacted with from clients such as the neo-gui.

## Quick Start

### Linux / OSX

Run the following to set the cluster up:

```
./scripts/linux/run.sh
```

### Windows

```
./scripts/windows/run.bat
```

The scripts will output the progress of the node setup and once running will automatically create a wallet and claim the gas after one minute. 

### NEO GUI client configuration

You will also need to install and configure the neo-gui pc client on your favorite distro, for example one of the following:

* [neo-gui](https://github.com/neo-project/neo-gui)
* [neo-gui-developer](https://github.com/CityOfZion/neo-gui-developer)

Then run:

#### OSX/Linux

```bash
scripts/linux/generate_protocol_json.sh
```

#### Windows

```bat
scripts/windows/generate_protocol_json.bat
```

and you'll find `protocol.json` in root of this repo that you can then use as the config for your chosen version of `neo-gui` that you've installed.

#### Manunal protocol.json confnig

If you don't copy the protocol.json from the docker configs directory of this repo, in addition to the "SeedList" modifications mentioned above, youd will also need to edit the following:

1. Change value "Magic" to 56753
2. Copy the public keys of each of your node wallets into the "StandbyValidators" section

### Wallets

The wallets are mounted into the NEO CLI containers so are available in `wallets/` in preparation for multiparty signature and neo/gas extraction.

#### Passwords

  * `node1`: `one`
  * `node2`: `two`
  * `node3`: `three`
  * `node4`: `four`

### Extracting Neo and Gas

Check out the [docs](http://docs.neo.org/en-us/node/private-chain.html) for instructions on how to claim Neo and Gas for testing.

### Prebuilt image

There is also a turnkey Docker image with the initial 100m NEO and 16.6k GAS already claimed in a ready-to-use wallet available here: 

* [neo-privnet-with-gas](https://hub.docker.com/r/metachris/neo-privnet-with-gas/)


## Help

- Open a new [issue](https://github.com/stevenjack/neo-privatenet-docker/issues/new) if you encountered a problem.
- Submitting PRs to the project is always welcome! 🎉
- Check the [Changelog](https://github.com/stevenjack/neo-privatenet-docker/blob/master/CHANGELOG.md) for recent changes.

## License

- Open-source [MIT](https://github.com/stevenjack/neo-privatenet-docker/blob/master/LICENSE).



