#!/usr/bin/env bash
git submodule update --init "$@"
pushd apps/dynamic
git submodule update --init --recursive
popd
