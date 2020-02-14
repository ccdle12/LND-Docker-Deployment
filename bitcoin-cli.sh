#!/bin/bash

# Command line to access lightning-cli
docker exec -ti bitcoin_node /bitcoin/src/bitcoin-cli "$@"
