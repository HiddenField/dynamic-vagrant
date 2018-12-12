#!/usr/bin/env bash
if [ ! -f ~/.dynamic/dynamic.conf ]; then
    dynamicd --daemon
    sleep 5
    dynamic-cli stop
    echo -e 'testnet=1\ndaemon=1\nserver=1\nrpcbind=0.0.0.0\nrpcallowip=0.0.0.0/0\naddnode=159.203.17.98\naddnode=18.214.64.9\naddnode=178.128.144.29\naddnode=206.189.30.176\naddnode=178.128.180.138\naddnode=178.128.63.114\naddnode=138.197.167.18' >> ~/.dynamic/dynamic.conf
    sed '/^\(rpc\)\?port\=/s/^/#/' -i ~/.dynamic/dynamic.conf
fi
