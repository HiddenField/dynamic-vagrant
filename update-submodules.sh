#!/usr/bin/env bash
git submodule update --init "$@"
git submodule update --init --recursive
