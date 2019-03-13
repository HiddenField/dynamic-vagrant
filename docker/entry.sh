#!/usr/bin/env bash
exit_script() {
    trap - SIGTERM # clear the trap
    echo "received SIGTERM"
    STOPPING=true
}

trap exit_script SIGTERM

PID_FILE=${HOME}/.dynamic/privatenet/dynamicd.pid
(rm ${PID_FILE} || true) &>/dev/null 
REINDEX_MARKER_FILE=${HOME}/.dynamic_reindex
(rm ${REINDEX_MARKER_FILE} || true) &>/dev/null 

stop_dynamicd() {
    echo "stopping dynamicd";
    dynamic-cli stop;
    while [ -f "${PID_FILE}" ]
    do
        echo "waiting for pidfile to be deleted";
        sleep 1;
    done
    echo "dynamicd is terminated";
}

if [ ! -f ~/.dynamic/dynamic.conf ]; then
    cp /dynamic/dynamic.default.conf ~/.dynamic/dynamic.conf
fi
while [ -z ${STOPPING+x} ]
do
    if [ ! -f "${PID_FILE}" ]; then
        echo "no pid, starting dynamicd";
        dynamicd -daemon;
        echo "dynamicd pid is $(cat ${PID_FILE})";
    fi
    if [ -f "${REINDEX_MARKER_FILE}" ]; then
        (rm ${REINDEX_MARKER_FILE} || true) &>/dev/null 
        stop_dynamicd
        dynamicd -daemon -reindex -rescan;
        echo "dynamicd pid is $(cat ${PID_FILE})";
    fi
    sleep 1;
done
stop_dynamicd