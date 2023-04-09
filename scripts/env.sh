#!/bin/sh

# RPC 
ETH_RPC=""

################### Erigon configs ###################

ERIGON_MAINNET_VER="2.42.0"
ERIGON_VER="2.40.1" # https://github.com/ledgerwatch/erigon/releases 
ERIGON_POLYGON_VER="v0.0.5" # https://github.com/maticnetwork/erigon

### Erigon mainnet ###
HTTP_PORT=8545
METRICS_PORT=44451
P2P_PORT=30303
API_PORT=9090
AUTHRPC_PORT=8541
TORRENT_PORT=42069

### Erigon goerli ###
GOERLI_HTTP_PORT=18545
GOERLI_METRICS_PORT=44452
GOERLI_P2P_PORT=30304
GOERLI_API_PORT=9091
GOERLI_AUTHRPC_PORT=8542
GOERLI_TORRENT_PORT=42070

### Gnosis ###
GNOSIS_NETWORK_PORT=38303
GNOSIS_RPC_PORT=38545
GNOSIS_ENGINE_PORT=38551

### Polygon ###
POLYGON_HTTP_PORT=11545
POLYGON_METRICS_PORT=55969
POLYGON_P2P_PORT=30305
POLYGON_API_PORT=9092
POLYGON_AUTHRPC_PORT=8543
POLYGON_TORRENT_PORT=42071
BOR_HIEMDALL_PORT=1317 # default
#BOR_LADDR_PORT=1317 # default

################### Lighthouse configs ####################

LIGHTHOUSE_MAINNET_VER="v4.0.1"
LIGHTHOUSE_VER="v3.5.1"

### Lighthouse mainnet ###
EXECUTION_PORT=${AUTHRPC_PORT}
METRICS_PORT_LIGHHOUSE=44550
LIGHTHOUSE_HTTP_PORT=5352 # default 5062
LIGHTHOUSE_METRICS_PORT=5054 # default
LIGHTHOUSE_LISTEN_PORT=9010 # default 9000

### Lighthouse goerli ###
GOERLI_EXECUTION_PORT=${GOERLI_AUTHRPC_PORT}
GOERLI_METRICS_PORT_LIGHHOUSE=44552
GOERLI_LIGHTHOUSE_HTTP_PORT=5152
GOERLI_LIGHTHOUSE_METRICS_PORT=5154
GOERLI_LIGHTHOUSE_LISTEN_PORT=9100

### Lighthouse gnosis ###
GNOSIS_EXECUTION_PORT=${GNOSIS_ENGINE_PORT}
GNOSIS_METRICS_PORT_LIGHHOUSE=44554
GNOSIS_LIGHTHOUSE_HTTP_PORT=5252
GNOSIS_LIGHTHOUSE_METRICS_PORT=5254
GNOSIS_LIGHTHOUSE_LISTEN_PORT=9200

################### Arbitrum configs ####################
ARBITRUM_CLASSIC_RPC_PORT=9656
ARBITRUM_NITRO_HTTP_PORT=9657
ARBITRUM_NITRO_RPC_CLASSIC_REDIRECT_PORT=${ARBITRUM_CLASSIC_RPC_PORT}

################### Fantom configs ####################
FANTOM_P2P_PORT=5350
FANTOM_HTTP_PORT=19545
FANTOM_WSS_PORT=19546
