#!/bin/bash

# Script Variables.
network="" # network is the variable if LND should be mainnet or testnet.

# RPC user and password for Bitcoin and LND Node.
rpcuser=""
rpcpass=""

# Persistent Storage.
persistent_storage=""

# Alias for LND.
alias_lnd=""

# External IP for LND.
external_ip=""

# Check if bitcoin.conf exists.
if [ -f ./configs/bitcoin.conf ]; then
echo "
~~~~~~ SETUP WIZARD ~~~~~~
Bitcoin.conf file already exists. 
To run the setup wizard again, delete the bitcoin.conf and lnd.conf file.
"
exit
fi

# Check if mainnet or testnet.
while true; do
read -p "
Is the LND Node for mainnet or testnet (m/t)?   
" mt
case $mt in
    [Mm]* ) network=mainnet; break;;
    [Tt]* ) network=testnet; break;;
    * ) echo "Please choose mainnet (m) or testnet (t)";;
    esac
done

# Add a user rpc and password.
while true; do
read -p "
Please enter the RPC Username:
" username
case $username in
    "" ) echo "RPC Username cannot be empty";;
    * ) rpcuser=$username; break;; 
    esac
done

# Add a user rpc and password.
while true; do
read -p "
Please enter the RPC  Password:
" password
case $password in
    "" ) echo "RPC Password cannot be empty";;
    * ) rpcpass=$password; break;; 
    esac
done

# Get the persistent-storage path.
while true; do
read -p "
Please enter the path to your peristent storage, this will save the Bitcoin chain data to your peristent-storage path:
" storage 
case $storage in
    "" ) echo "Currently this project needs a path to store the chain data.";;
    * ) persistent_storage=$storage; break;; 
    esac
done

# Get the LND alias.
while true; do
read -p "
Please enter your LND alias:
" alias
case $alias in
    "" ) echo "Currently this project needs to have an alias for LND.";;
    * ) alias_lnd=$alias; break;; 
    esac
done

# Get the external ip for the LND node.
while true; do
read -p "
Please enter the external ip of the LND Node:
" externalip 
case $externalip in
    "" ) echo "Currently this project needs to have an externalip for LND.";;
    * ) external_ip=$externalip; break;; 
    esac
done

# Create .env file.
cat <<EOF > .env
# Bitcoin RPC
BITCOIN_RPCUSER=$rpcuser
BITCOIN_RPCPASS=$rpcpass

# Persistent Storage path.
PERSISTENT_STORAGE=$persistent_storage

# LND Alias
LND_ALIAS=$alias_lnd

# External IP for the LND Node.
EXTERNAL_IP=$external_ip
EOF

# Create the bitocin.conf according to the network.
cat <<EOF > ./configs/bitcoin.conf
# Chain Data
datadir=/bitcoin-datadir

# JSON RPC options
server=1
daemon=1

# RPC options
rpcuser=$rpcuser
rpcpassword=$rpcpass
rpcallowip=::/0

# Open Ports
rpcport=8332

# P2P Ports
port=8333

# ZMQ for notification to LND
zmqpubrawblock=tcp://127.0.0.1:28332
zmqpubrawtx=tcp://127.0.0.1:28333
EOF

# Add testnet to bitcoin config if set.
if [ $network == "testnet" ]; then
    echo "testnet=1" >> ./configs/bitcoin.conf
fi

# Create the lnd.conf file.
cat <<EOF > ./configs/lnd.conf
bitcoind.zmqpubrawblock=tcp://127.0.0.1:28332
bitcoind.zmqpubrawtx=tcp://127.0.0.1:28333
bitcoind.rpcuser=$rpcuser
bitcoind.rpcpass=$rpcpass
alias=$alias_lnd
externalip=$externalip
bitcoin.node=bitcoind
bitcoin.active=1
rpclisten=127.0.0.1:10008
rpclisten=0.0.0.0:10009
restlisten=0.0.0.0:8080
tlsextraip=$externalip
EOF

# Append whether LND should be running on testnet or mainnet.
if [ $network == "testnet" ]; then
    echo "bitcoin.testnet=1" >> ./configs/lnd.conf
else
    echo "bitcoin.mainnet=1" >> ./configs/lnd.conf
fi

# Set the lncli.sh script.
cat <<EOF > ./lncli.sh
#!/bin/bash

# Command line to access lightning-cli
docker exec -ti bitcoin_node /bin/bash -c "lncli --tlscertpath=/root/.lnd/tls.cert --macaroonpath=/root/.lnd/data/chain/bitcoin/$network/admin.macaroon \$@"
EOF

chmod a+x ./lncli.sh

# Run the docker-compose file.
echo "[NOW RUNNING THE DOCKER-COMPOSE FILE...]"
make
