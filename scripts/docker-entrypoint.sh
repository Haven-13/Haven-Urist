#!/bin/sh

mkdir /byond
chown $RUN_AS:$RUN_AS /byond $BUILD_DIR baystation12.rsc

gosu $RUN_AS DreamDaemon baystation12.dmb 8000 -trusted -verbose $DD_ARGS
