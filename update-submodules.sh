#!/usr/bin/env bash
while getopts "rc:" o; do
    case "${o}" in
        c)
            COMMITID=${OPTARG}
            ;;
        r)
            UPDATE_REMOTE="--remote"
            ;;
    esac
done
if [ -z ${COMMITID+x} ]; 
    then 
        git submodule update --init ${UPDATE_REMOTE}
        pushd apps/dynamic
        git submodule update --init --recursive
        popd
    else
        pushd apps/dynamic
        git checkout ${COMMITID}
        git submodule update --init --recursive
        popd
fi
