#!/bin/bash

# Run bitcoind.
/bitcoin/src/bitcoind &

# Run lnd.
lnd &

# Keep contaienr open.
sleep infinity

