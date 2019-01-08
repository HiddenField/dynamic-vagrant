#!/usr/bin/env bash
mkdir -p ./docker-build-artefacts
docker exec dynamicd cat dist/dynamicd >> ./docker-build-artefacts/dynamicd
docker exec dynamicd cat dist/dynamic-cli >> ./docker-build-artefacts/dynamic-cli
chmod +x ./docker-build-artefacts/dynamicd
chmod +x ./docker-build-artefacts/dynamic-cli
