#!/bin/sh

git --version
git checkout master
git pull origin master
docker-compose up --build --exit-code-from game .