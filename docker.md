# Running dynamicd daemon in docker

## Prerequisites

To reduce the size of the docker context to an absolute minimum, please clone a fresh copy of this repository. Things work a little differently to the vagrant process, and build artefacts from the vagrant workflow in `./apps/dynamic-private` will significantly increase the space needed to perform a docker build.

You must have read access to the [`dynamic-private`](https://github.com/duality-solutions/dynamic-private) repository

Docker / Docker for Mac / Docker for Windows must be installed

The `~/.dynamic` folder in the container will be mapped to folder `./.dynamic` in this folder. To avoid sharing issues on MacOS, ensure that this folder is checked out somewhere in `/Users` (see https://docs.docker.com/docker-for-mac/#file-sharing for further information)

## Building the docker image

You may be able to skip this step and download a pre-built docker image. See below.

In a bash shell, change to this directory.

The docker image can be built by running the bash script:

    ./docker-build.sh

This will first checkout the `dynamic-private` submodule into `./apps/dynamic-private/`, then build a new docker image tagged as `dynamicd-testing:latest`. The build process can take a significant amount of time.

### Saving a built image to file

This step is only necessary for sharing the built image

    mkdir -p ./docker-images
    docker save dynamicd-testing:latest | gzip -9 > ./docker-images/dynamicd-testing-docker-image.tar.gz

As this involves gzipping about 2GiB of data down to ~500MiB, so it might take some time

### Restoring a built image from file

If a pre-built image is available, it can be restored with

    cat ./docker-images/dynamicd-testing-docker-image.tar.gz | gzip -d | docker load 

## Running the docker image

If already running in vagrant, take down the vagrant machine with `vagrant halt`, otherwise you might encounter port conflicts.

Now:

    ./docker-run.sh

wait for about ten seconds and ensure that directory `./.dynamic` is created (this directory is mounted into to the docker image) and that `./.dynamic/dynamic.conf` looks like this (except for `rpcuser` and `rpcpassword`, which will be different for each user):

    #Do not use special characters with username/password
    rpcuser=someusername
    rpcpassword=somepassword
    #rpcport=33350
    #port=33300
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

If everything is working correctly, the RPC endpoint will be exposed on `localhost` port `33450` and can be connected to from node using the [`bitcoin-core`](https://www.npmjs.com/package/bitcoin-core) NPM package:

    const bitcoin = require("bitcoin-core");
    const bc = new bitcoin({
        host: "localhost", 
        port: "33450", 
        username: "someusername",  #use rpcuser value from ./.dynamic/dynamic.conf
        password: "somepassword"   #use rpcpassword value from ./.dynamic/dynamic.conf
    })
    bc.command("getinfo").then(r => console.log(r))

## stopping the docker instance

    ./docker-stop.sh

