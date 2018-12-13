#!/usr/bin/env bash
git submodule update --recursive --remote
docker build --rm -f "dockerfile" -t dynamicd-testing:latest .
