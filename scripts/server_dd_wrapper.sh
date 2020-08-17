#! /bin/bash

SERVER_PORT=8000
SERVER_DD_ARGS="-trusted -verbose -close"

[[ -e reboot_called ]] && rm reboot_called
# Reboot or start server
echo "Starting Dream Daemon using a wrapper shell script."
DreamDaemon $BUILD_TARGET.dmb $SERVER_PORT $SERVER_DD_ARGS &
pid=$!
trap "cleanup $pid" EXIT

echo "Wrapper will now enter a loop waiting for a signal..."
# Wait for end of round or server death
while [[ ! -e reboot_called ]] && ps -p $pid > /dev/null; do
    sleep 15
done
echo "Reboot signal file found, terminating the DD instance..."
[[ -e reboot_called ]] && kill -s SIGTERM $pid
echo "Done!"