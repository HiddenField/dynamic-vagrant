#!/usr/bin/env bash
git submodule update --init "$@"
pushd apps/dynamic-private
git submodule update --init --recursive
popd
