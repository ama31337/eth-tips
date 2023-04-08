#!/bin/sh

. ./env.sh

git clone --recurse-submodules -j8 https://github.com/maticnetwork/erigon.git
cd erigon
git checkout ${ERIGON_POLYGON_VER}
make erigon

echo "done, erigon ${ERIGON_POLYGON_VER} installed successfully"
echo "-------"


