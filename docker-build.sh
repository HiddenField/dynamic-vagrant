#!/usr/bin/env bash
usage() { 
    echo "docker-build.sh [-n]" 1>&2; 
    echo " -n Do not update to latest submodule(s) from remote. Use committed submodule version and update to that version" 1>&2
    exit 1; 
}
UPDATE_REMOTE="-r"
UPDATE_SUBMODULES=true
while getopts "nshc:" o; do
    case "${o}" in
        n)
            echo "Not updating submodules from remote"
            unset UPDATE_REMOTE
            ;;
        s)
            echo "Not updating submodules"
            UPDATE_SUBMODULES=false
            ;;
        c)
            COMMITID=${OPTARG}
            ;;
        h)
            usage
            ;;
        *)
            usage
            ;;
    esac
done
if [ "${UPDATE_SUBMODULES}" == "true" ]; then
    echo "Updating submodules"
    if ! [ -z ${COMMITID+x} ]; then 
        EXTRAPARAM="-c ${COMMITID}"
    fi
    ./update-submodules.sh ${UPDATE_REMOTE} ${EXTRAPARAM}
fi


docker build --rm -f "dockerfile" -t dynamicd-testing:latest .
