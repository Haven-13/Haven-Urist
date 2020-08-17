#!/bin/sh

mkdir /byond
chown $RUN_AS:$RUN_AS /byond $BUILD_DIR $BUILD_TARGET.rsc

gosu $RUN_AS ./scripts/server_dd_wrapper.sh
