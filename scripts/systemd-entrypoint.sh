#!/bin/sh

[[ ! -e SERVER_PORT ]] && SERVER_PORT=8000
[[ ! -e RUN_BRANCH ]] && RUN_BRANCH=master

git --version
git pull origin
git checkout $RUN_BRANCH
docker build --tag havenurist:latest .
docker run \
    --network="host" \
    --name hu \
    -p 8000:8000 \
    --mount type=bind,source="/home/ah13-srv-usr/config",target="/bin/config" \
    --mount type=bind,source="/home/ah13-srv-usr/data",target="/bin/data" \
    havenurist:latest
docker rm --force hu
