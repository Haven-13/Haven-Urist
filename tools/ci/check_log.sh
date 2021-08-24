#!/bin/bash

source tools/ci/check_code.sh

need_cmd grep

run_test "check tests passed" "grep 'All Unit Tests Passed' $1"
run_test "check no runtimes" "grep 'Caught 0 Runtimes' $1"
run_test_fail "check no runtimes 2" "grep 'runtime error:' $1"
run_test_fail "check no scheduler failures" "grep 'Process scheduler caught exception processing' $1"
run_test_fail "check no warnings" "grep 'WARNING:' $1"
run_test_fail "check no failures" "grep 'ERROR:' $1"

check_fail
