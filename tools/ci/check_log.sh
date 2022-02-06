#!/bin/bash

function msg {
    echo -e "\t\e[34mtest\e[0m: $*"
}

function msg_bad {
    echo -e "\e[31m$*\e[0m"
}

function msg_good {
    echo -e "\e[32m$*\e[0m"
}

function msg_meh {
    echo -e "\e[33m$*\e[0m"
}

function warn {
    msg_meh "WARNING: $*"
}

function err {
    msg_bad "error: $*"
    exit 1
}

function fail {
    warn "test \"$1\" failed: $2"
    ((FAILED++))
    FAILED_BYNAME+=("$1")
}

function need_cmd {
    if command -v $1 >/dev/null 2>&1
    then msg "found '$1'"
    else err "program '$1' is missing, please install it"
    fi
}

function run_test {
    msg "running \"$1\""
    name=$1
    shift
    exec_test "$*"
    ret=$?
    if [[ ret -ne 0 ]]
    then fail "$name" $ret
    else ((PASSED++))
    fi
}

function run_test_fail {
    msg "running(fail) \"$1\""
    name=$1
    shift
    exec_test "$*"
    ret=$?
    if [[ ret -eq 0 ]]
    then fail "$name" $ret
    else ((PASSED++))
    fi
}

function check_fail {
    if [[ $FAILED -ne 0 ]]; then
        for t in "${FAILED_BYNAME[@]}"; do
            msg_bad "TEST FAILED: \"$t\""
        done
        err "$FAILED tests failed"
    else msg_good "$PASSED tests passed"
    fi
}

function exec_test {
    eval "$*"
    ret=$?
    return $ret
}

need_cmd grep

run_test "check tests passed" "grep 'All Unit Tests Passed' $1"
run_test "check no runtimes" "grep 'Caught 0 Runtimes' $1"
run_test_fail "check no runtimes 2" "grep 'runtime error:' $1"
run_test_fail "check no scheduler failures" "grep 'Process scheduler caught exception processing' $1"
run_test_fail "check no warnings" "grep 'WARNING:' $1"
run_test_fail "check no failures" "grep 'ERROR:' $1"

check_fail
