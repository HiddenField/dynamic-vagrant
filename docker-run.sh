#!/usr/bin/env bash
docker run --rm -d --name dynamicd -v `pwd`/.dynamic:/root/.dynamic -p 33650:33650 dynamicd-testing:latest
