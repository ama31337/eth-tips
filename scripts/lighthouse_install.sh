#!/bin/sh

. ./env.sh

cd ~/ && wget https://github.com/sigp/lighthouse/releases/download/${LIGHTHOUSE_VER}/lighthouse-${LIGHTHOUSE_VER}-x86_64-unknown-linux-gnu.tar.gz
sudo tar -C /usr/local/bin -xvf lighthouse-${LIGHTHOUSE_VER}-x86_64-unknown-linux-gnu.tar.gz 
rm ~/*.tar.gz

echo "done, lighthouse ${LIGHTHOUSE_VER} installed successfully"
echo "-------"
lighthouse --version
