#!/usr/bin/env bash

# Command line to access lightning-cli
docker exec -ti bitcoin_node lncli --tlscertpath=/root/.lnd/tls.cert --macaroonpath=/root/.lnd/data/chain/bitcoin/testnet/admin.macaroon "$@"
