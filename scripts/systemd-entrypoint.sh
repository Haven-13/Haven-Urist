#!/bin/sh

SERVER_PORT=8000
SERVER_DD_ARGS="-trusted -verbose -close" # added to the DreamDaemon in docker-entrypoint.sh
RUN_BRANCH=master

git --version
git pull origin
git checkout $RUN_BRANCH
docker-compose down
docker-compose up --build --exit-code-from game
