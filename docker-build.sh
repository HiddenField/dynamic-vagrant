#!/usr/bin/env bash
echo $1
usage() { 
    echo "docker-build.sh [-r]" 1>&2; 
    echo " -r update submodule from remote" 1>&2
    exit 1; 
}
while getopts "r" o; do
    case "${o}" in
        r)
            echo "updating submodules from remote"
            UPDATE_REMOTE="--remote";;
        *)
            usage
            ;;
    esac
done
./update-submodules.sh ${UPDATE_REMOTE}

docker build --rm -f "dockerfile" -t dynamicd-testing:latest .
