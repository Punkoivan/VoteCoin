#!/usr/bin/env bash

cd "$(dirname "$(readlink -f "$0")")"    #'"%#@!

sudo dnf install \
      git pkgconfig automake autoconf ncurses-devel python \
      python-zmq wget gtest-devel gcc gcc-c++ libtool patch

./fetch-params.sh || exit 1

./build.sh --disable-tests --disable-rust -j$(nproc) || exit 1

if [ ! -r ~/.votecoin/votecoin.conf ]; then
   mkdir -p ~/.votecoin
   echo "addnode=mainnet.votecoin.site" >~/.votecoin/votecoin.conf
   echo "rpcuser=username" >>~/.votecoin/votecoin.conf
   echo "rpcpassword=`head -c 32 /dev/urandom | base64`" >>~/.votecoin/votecoin.conf
fi

cd ../src/
cp -f zcashd votecoind
cp -f zcash-cli votecoin-cli
cp -f zcash-tx votecoin-tx
