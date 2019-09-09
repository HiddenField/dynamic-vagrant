# Running dynamicd daemon in docker

## Prerequisites

To reduce the size of the docker context to an absolute minimum, please clone a fresh copy of this repository. Things work a little differently to the vagrant process, and build artefacts from the vagrant workflow in `./apps/dynamic` will significantly increase the space needed to perform a docker build.

You must have read access to the [`dynamic`](https://github.com/duality-solutions/Dynamic) repository

Docker / Docker for Mac / Docker for Windows must be installed

The `~/.dynamic` folder in the container will be mapped to folder `./.dynamic` in this folder. To avoid sharing issues on MacOS, ensure that this folder is checked out somewhere in `/Users` (see https://docs.docker.com/docker-for-mac/#file-sharing for further information)

## Building the docker image

You may be able to skip this step and download a pre-built docker image. See below.

In a bash shell, change to this directory.

The docker image can be built by running the bash script:

    ./docker-build.sh

This will first update the `dynamic` submodule in `./apps/dynamic/` to the current version.

> If you don't want to update submodules to latest remote version, you can issue 
> 
>     ./docker-build.sh -n
> 

This will build a new docker image tagged as `dynamicd-testing:latest`. 

The build process can take a significant amount of time.

>  If flag `-n` is used, this will not pull the latest version of https://github.com/duality-solutions/Dynamic into `./apps/dynamic/` before building, and instead pull the currently committed version of the submodule at `./apps/dynamic/` will be pulled before builing
> 
> If it isn't supplied, the HEAD commit of the branch described by the submodule ( https://github.com/duality-solutions/Dynamic ) at `./apps/dynamic/` will be pulled before building. I.e. This will build the *latest* version of https://github.com/duality-solutions/Dynamic
> 
> Usually, you'll want to omit the `-n` option for "latest version", so to build (both from scratch, and/or rebuild), the command will usually be `./docker-build.sh` .
>
> Alternatively, if you want to use a specific commit/branch/tag of the dynamic repository, you can:
>
>     ./docker-build.sh -c v2.4.25
>
> This will check-out the `v2.4.25` tag and refresh the submodules of dynamicd according to what's stored in that commit. This can be useful when matching the docker build to prebuilt binaries.

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

...wait for about ten seconds and ensure that `./.dynamic/dynamic.conf` exists and that directory `./.dynamic/privatenet` directory has been created. If yes, this is a strong indication that everything is working correctly.

If everything is working correctly, the RPC endpoint will be exposed on `localhost` port `33650` and can be connected to from node using the [`bitcoin-core`](https://www.npmjs.com/package/bitcoin-core) NPM package:

    const bitcoin = require("bitcoin-core");
    const bc = new bitcoin({
        host: "localhost", 
        port: "33650", 
        username: "someusername",  #use rpcuser value from ./.dynamic/dynamic.conf
        password: "somepassword"   #use rpcpassword value from ./.dynamic/dynamic.conf
    })
    bc.command("getinfo").then(r => console.log(r))

You can check "sync" status by issuing command

    docker exec dynamicd dynamic-cli dnsync status

When all synced, you can expect a response that looks like this:

    {
        "AssetID": 999,
        "AssetName": "DYNODE_SYNC_FINISHED",
        "AssetStartTime": 1544715953,
        "Attempt": 0,
        "IsBlockchainSynced": true,
        "IsDynodeListSynced": true,
        "IsWinnersListSynced": true,
        "IsSynced": true,
        "IsFailed": false
    }

You can view the dynamicd debug log with

    docker exec dynamicd tail -f /root/.dynamic/privatenet/debug.log

## extracting the binary build artefacts from the docker image

While the docker image is running:

    mkdir -p ./docker-build-artefacts
    docker exec dynamicd cat dist/dynamicd > ./docker-build-artefacts/dynamicd
    docker exec dynamicd cat dist/dynamic-cli > ./docker-build-artefacts/dynamic-cli
    chmod +x ./docker-build-artefacts/dynamicd
    chmod +x ./docker-build-artefacts/dynamic-cli

see [docker-get-build-artefacts.sh](docker-get-build-artefacts.sh)


## stopping the docker instance

    ./docker-stop.sh

