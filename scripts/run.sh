#!/bin/bash

# Don't run the docker-compose file if the conf files don't exist.
if [ -f ./configs/bitcoin.conf ]; then
    echo "Running docker-compose"
    docker-compose up -d 
else
    echo "
[MAKE FAILED]
The bitcoin.conf and lnd.conf files both need to exist, run 'make setup'
    "
fi

