#!/usr/bin/env bash
./update-submodules.sh --remote
docker build --rm -f "dockerfile" -t dynamicd-testing:latest .
