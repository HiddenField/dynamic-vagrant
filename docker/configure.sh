#!/usr/bin/env bash
if [ ! -f ~/.dynamic/dynamic.conf ]; then
    cp /dynamic/dynamic.default.conf ~/.dynamic/dynamic.conf
fi
