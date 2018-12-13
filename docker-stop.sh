#!/usr/bin/env bash
docker exec dynamicd dynamic-cli stop
sleep 10
docker stop dynamicd
docker rm dynamicd
