# dynamic-vagrant
Vagrant files to setup ubuntu VM for Dynamic node build

## Setup and Build notes

Run:
    vagrant up

Clone duality-private repo into the apps folder

SSH into vagrant:
    vagrant ssh

run:
    cd apps/dynamic-private
    ./autogen.sh && ./configure --without-gui --disable-tests --disable-bench && make

## Configuration
Dynamic configuration can be found in vagrant: ~/.dynamic/dynamic.conf

Add the following to conf:

testnet=1
daemon=1
server=1
rpcbind=0.0.0.0
rpcallowip=0.0.0.0/0
addnode=159.203.17.98
addnode=18.214.64.9
addnode=178.128.144.29
addnode=206.189.30.176
addnode=178.128.180.138
addnode=178.128.63.114
addnode=138.197.167.18

## Running commands

Running Server - ./src/dynamicd --daemon
Stopping Server - ./src/dynamic-cli stop
Help - ./src/dynamic-cli help


