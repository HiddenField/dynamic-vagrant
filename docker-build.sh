#!/usr/bin/env bash
usage() { 
    echo "docker-build.sh [-n]" 1>&2; 
    echo " -n Do not update to latest submodule(s) from remote. Use committed submodule version and update to that version" 1>&2
    exit 1; 
}
UPDATE_REMOTE="--remote"
while getopts "nh" o; do
    case "${o}" in
        n)
            echo "Not updating submodules from remote"
            unset UPDATE_REMOTE;;
        h)
            usage
            ;;
        *)
            usage
            ;;
    esac
done
./update-submodules.sh ${UPDATE_REMOTE}

docker build --rm -f "dockerfile" -t dynamicd-testing:latest .
