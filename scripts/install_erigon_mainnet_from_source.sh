#!/bin/sh

. ./env.sh

# go install
cd ~/
GO_VER=1.19.5
curl -s https://gist.githubusercontent.com/c29r3/3130b5cd51c4a94f897cc58443890c28/raw/134d86f8a90b2bbb7c68cd6bb663c60c5846ae31/install_golang.sh | bash -s - ${GO_VER}
echo "export PATH=$PATH:/usr/local/go/bin" >> $HOME/.profile && source $HOME/.profile
echo "export GOPATH=$HOME/go" >> $HOME/.profile && source $HOME/.profile
go version

# erigon install
cd ~/
wget https://github.com/ledgerwatch/erigon/archive/refs/tags/v${ERIGON_MAINNET_VER}.zip
unzip v${ERIGON_MAINNET_VER}.zip
rm v${ERIGON_MAINNET_VER}.zip
cd erigon-${ERIGON_MAINNET_VER}
make erigon
sudo cp ./build/bin/erigon /usr/local/bin/erigon-mainnet

echo "done, erigon ${ERIGON_MAINNET_VER} installed successfully"
echo "-------"
erigon-mainnet --version

