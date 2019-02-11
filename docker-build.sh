#!/usr/bin/env bash
./update-submodules.sh
docker build --rm -f "dockerfile" -t dynamicd-testing:latest .
