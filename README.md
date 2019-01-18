# LND Docker Deployment

An LND Docker Deployment used by myself in personal and professional projects.

## Getting Started

These instructions will get the project deployed on your local machine or on a remote server.

### Prerequisites

What things you need to install the software

* Docker
* Docker-compose
* Make
* *OPTIONAL* - Mounted persistent storage


### Installing

A step by step series of examples that tell you how to setup the LND Node Deployment.

1. Git clone the project and cd into the project.

```
$ git clone https://github.com/ccdle12/LND-Docker-Deployment.git
$ cd ./LND-Docker-Deployment
```

2. Run the setup-wizard.

```
$ make setup
```

3. Follow the setup-wizard.

```
* Select whether the node is mainnet or test
$ Is the LND Node for mainnet or testnet (m/t)?
> t

* Enter the RPC Username for the Bitcoin Node
$ Please enter the RPC Username:
> kek

* Enter the RPC Password for the Bitcoin Node
$ Please enter the RPC  Password:
> <some-password>

* Enter a Path to store the chain data:
$ Please enter the path to your peristent storage, this will save the Bitcoin chain data to your peristent-storage path:
> /mnt/blockstorage

* Enter an alias for the LND-Node:
$ Please enter your LND alias:
> kek

* Enter the external IP of the server, both LND and Bitcoin will use this IP address:
$ Please enter the external ip of the LND Node:
> <some-ip-addr>
```

After running the setup-wizard a file "lncli.sh" will generated in the project folder.

Create an LND wallet, please note the CIPHER SEED that will be returned on the CLI.
PLEASE KEEP A NOTE OF IT SOMEWHERE SAFE.
```
$ ./lncli.sh create
```

Run LND commands

```
$ ./lncli.sh getinfo
```

## Built With

* [Docker](https://www.docker.com/) - Container Technology
* [Docker-Compose](https://docs.docker.com/compose/) - Container Orchestration
* [LND](https://github.com/lightningnetwork/lnd) - Lightning Node
* [Bitcoin](https://github.com/bitcoin/bitcoin) - Bitcoin Node

## Authors

* **Christopher Coverdale** - *Initial work* - [ccdle12](https://github.com/ccdle12)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Bitcoin
* LND
* BTCPay Server
