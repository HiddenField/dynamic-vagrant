# dynamic-vagrant
Vagrant files to setup ubuntu VM for Dynamic node build

## Setup and Build notes

Pull the `dynamic` submodule with

    git submodule update --recursive --remote

Run:

    vagrant up

SSH into vagrant:

    vagrant ssh

run:

    cd apps/dynamic
    ./autogen.sh && ./configure --without-gui --disable-tests --disable-bench && make

## Configuration
You will need to create a dynamic configuration file at: `~/.dynamic/dynamic.conf` on the vagrant VM

Copy the config from `./docker/dynamic.default.conf` into this file.

## Running commands

Running Server - `./src/dynamicd --daemon`

Stopping Server - `./src/dynamic-cli stop`

Help - `./src/dynamic-cli help`

## RPC Calls

See - https://en.bitcoin.it/wiki/API_reference_(JSON-RPC)

