#!/bin/sh

[[ ! -e SERVER_PORT ]] && SERVER_PORT=8000
[[ ! -e RUN_BRANCH ]] && RUN_BRANCH=master

git --version
git pull origin
git checkout $RUN_BRANCH
docker build --tag havenurist:latest
docker run \
    --network="host" \
    --name havenurist \
    -p $SERVER_PORT:$SERVER_PORT \
    --mount type=bind, source="/bin/config" target="/home/ah13-srv-usr/config" \
    --mount type=bind, source="/bin/data" target="/home/ah13-srv-usr/data" \
    havenurist:latest
docker rm --force havenurist
