#!/bin/bash

# Command line to access lightning-cli
docker exec -ti bitcoin_node /bin/bash -c "/bitcoin/src/bitcoin-cli $*"
