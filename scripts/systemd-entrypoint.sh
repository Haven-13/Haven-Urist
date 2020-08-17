#!/bin/sh

DD_ARGS="-close" # added to the DreamDaemon in docker-entrypoint.sh
RUN_BRANCH=master

git --version
git pull origin
git checkout $RUN_BRANCH
docker-compose down
docker-compose up --build --exit-code-from game
