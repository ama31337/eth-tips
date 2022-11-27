#!/bin/sh

. ./env.sh

sudo systemctl stop lighthouse-goerli.service
sudo systemctl stop lighthouse-gnosis.service

cd ~/ && wget https://github.com/sigp/lighthouse/releases/download/${LIGHTHOUSE_VER}/lighthouse-${LIGHTHOUSE_VER}-x86_64-unknown-linux-gnu.tar.gz
sudo tar -C /usr/local/bin -xvf lighthouse-${LIGHTHOUSE_VER}-x86_64-unknown-linux-gnu.tar.gz 
rm *.tar.gz

sudo systemctl restart lighthouse-goerli.service
sudo systemctl restart lighthouse-gnosis.service

echo "done, lighthouse ${LIGHTHOUSE_VER} installed successfully"
