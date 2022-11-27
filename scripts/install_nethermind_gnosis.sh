#!/bin/sh

sudo apt-get update -y
sudo add-apt-repository ppa:nethermindeth/nethermind
sudo apt install nethermind -y
sudo bash -c 'echo "nethermind soft nofile 1000000" > /etc/security/limits.d/nethermind.conf'
ulimit -n 1000000

cd ~/
wget https://github.com/NethermindEth/nethermind/releases/download/1.14.3/nethermind-linux-amd64-1.14.3-7074612-20221003.zip # https://downloads.nethermind.io
sudo apt-get update && sudo apt-get install libsnappy-dev libc6-dev libc6 unzip -y
unzip ~/nethermind-linux-amd64-1.14.3-7074612-20221003.zip -d ~/nethermind-bin
#sudo cp ~/nethermind-bin/Nethermind.Runner /usr/bin/Nethermind.Runner

mkdir -p ${HOME}/nethermind/data
openssl rand -hex 32 | sudo tee ${HOME}/jwt.hex > /dev/null
cat ${HOME}/jwt.hex
