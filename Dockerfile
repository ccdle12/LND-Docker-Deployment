# FROM ubuntu:latest 
FROM golang:latest 

# Seting Working Directory.
WORKDIR /

# Install dependenices.
RUN apt-get update \
    && apt-get install make git gcc autoconf build-essential libtool autotools-dev automake pkg-config bsdmainutils python3 -y \
    && apt-get install libssl-dev libevent-dev libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-test-dev libboost-thread-dev -y \
    && apt-get install libminiupnpc-dev libzmq3-dev -y vim -y \
    && git clone https://github.com/bitcoin/bitcoin 

# Set Working Directory to make Bitcoin.
WORKDIR /bitcoin
RUN ./autogen.sh \
    && ./configure --disable-wallet --without-gui \ 
    && make 

# Create the .bitcoin file, the bitcoin.conf file
# will be volume mounted.
WORKDIR /root/.bitcoin

# Set Working Directory to Go folder.
WORKDIR /root/go/src/github.com/lightningnetwork

RUN git clone https://github.com/lightningnetwork/lnd

# Set Working Directory to LND.
WORKDIR ./lnd

# Install LND.
RUN make && make install

# Expose ports for Bitcoin and LND.
EXPOSE 8332 8333 10009 8080 9735

# TODO: 
# Create .lnd config file

WORKDIR /
