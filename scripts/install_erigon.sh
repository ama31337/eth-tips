#!/bin/sh

. ./env.sh

cd ~/
wget https://github.com/ledgerwatch/erigon/releases/download/v${ERIGON_VER}/erigon_${ERIGON_VER}_linux_amd64.tar.gz # https://github.com/ledgerwatch/erigon/releases
sudo apt-get update && sudo apt-get install libsnappy-dev libc6-dev libc6 unzip -y
sudo tar -C /usr/local/bin -xvf erigon_${ERIGON_VER}_linux_amd64.tar.gz
rm ~/*.tar.gz

echo "done, erigon ${ERIGON_VER} installed successfully"
echo "-------"
erigon --version

