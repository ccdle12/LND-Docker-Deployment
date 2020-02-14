#!/usr/bin/env bash

# Get the lightning chain environment from running `getinfo` using the lightning
# node.
testnet=""
testnet=$(. lncli.sh getinfo | grep true)

# Macaroon hex dump.
macaroon=""

# If testnet variable is empty, meaning it is mainnet.
if [ -z "$testnet" ]
then
    macaroon=$(docker exec -ti bitcoin_node /bin/bash -c "
        chain=$(xxd -ps -u -c 1000  /root/.lnd/data/chain/bitcoin/mainnet/admin.macaroon)
    ")
else
    macaroon=$(docker exec -ti bitcoin_node /bin/bash -c "
        xxd -ps -u -c 1000  /root/.lnd/data/chain/bitcoin/testnet/admin.macaroon
    ")
fi

# certthumpprint of the tls.cert for communication.
cert_thumb_print=""

cert_thumb_print=$(docker exec -ti bitcoin_node /bin/bash -c "
        openssl x509 -noout -fingerprint -sha256 -inform pem -in /root/.lnd/tls.cert
    ")

echo ""
echo "**** MACAROON AND TLS CERT THUMB PRINT ****"
echo ""
echo "MACAROON: "$macaroon
echo ""
echo $cert_thumb_print
echo ""
