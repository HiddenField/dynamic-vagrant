#!/usr/bin/env bash
mkdir -p ./docker-images
docker save dynamicd-testing:latest | gzip -9 > ./docker-images/dynamicd-testing-docker-image.tar.gz
