# dynamic-vagrant
Vagrant files to setup ubuntu VM for Dynamic node build

## Setup and Build notes

Pull the `dynamic-private` submodule with

    git submodule update --recursive --remote

Run:

    vagrant up

SSH into vagrant:

    vagrant ssh

run:

    cd apps/dynamic-private
    ./autogen.sh && ./configure --without-gui --disable-tests --disable-bench && make

## Configuration
Dynamic configuration can be found in vagrant: `~/.dynamic/dynamic.conf`, if this has not been created, then

    ./src/dynamicd --daemon

wait for a few seconds

    ./src/dynamic-cli stop

and a configuration file should now be created at `~/.dynamic/dynamic.conf`

Comment out the following lines:

    rpcport=33350
    port=33300

so they look like this:

    #rpcport=33350
    #port=33300


then add the following to the end of the file:

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

Running Server - `./src/dynamicd --daemon`

Stopping Server - `./src/dynamic-cli stop`

Help - `./src/dynamic-cli help`

## RPC Calls

See - https://en.bitcoin.it/wiki/API_reference_(JSON-RPC)

