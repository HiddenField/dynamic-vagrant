#!/usr/bin/env bash
docker run -d --name dynamicd -v `pwd`/.dynamic:/root/.dynamic -p 33450:33450 dynamicd-testing:latest
