#!/usr/bin/env bash

# This is a stripped down version of Baystation12's old run-test.sh
# Only CODE and ICON test cases remain with their required dependecies.
#
# Additionally. The comment block here is not the original version. It is also
# stripped down to only the relevant bits about it.
# - martin

# This is the entrypoint to the testing system, written for Baystation12 and
# inspired by Rust's configure system
#
# The general structure of the test execution is as follows:
# - find_code:              Look for the project root directory and fail fast if
#                           it can't be found. Assumes that it is in . or ..;
#                           custom locations can be specified in CODEPATH
#                           environment variable.
# - run_configured_tests:   Evaluate TEST variable, call into appropriate test
#                           runner function.
# - run_all_tests:          Run every test group in sequence.
# - run_xxx_tests:          Run the tests for $xxx, doing any necessary setup
#                           first, including calling find_xxx_deps.
# - find_xxx_deps:          Using need_cmd, ensure that programs needed to run
#                           tests that are part of $xxx are available.
# - need_cmd:               Checks availability of command passed as the single
#                           argument. Fails fast if it's not available.
# - err:                    Prints arguments as text, exits indicating failure.
# - warn:                   Prints arguments as text, indicating a warning
#                           condition.
# - msg:                    Used by all printing, formats text nicely.
# - run_test:               Runs a test. The first argument is the friendly name
#                           of the test. The remaining arguments are the shell
#                           command(s) to run. If a test fails, a global counter
#                           is incremented and a warning is emitted.
# - run_test_fail:          Exactly as run_test, but considers failure of the
#                           command to be a successful test.
# - run_test_ci:            Gates run_test to only run test when being run on a
#                           CI platform. This is used to gate tests that are
#                           destructive in some manner.
# - exec_test:              Called by run_test{,fail}, actually executes the
#                           test and returns its resulti.
# - check_fail:             Called at the end of the run, prints final report
# and sets exit status appropriately.
#
# Good luck!
# - xales

# Global counter of failed tests
FAILED=0
# List of names of failed tests
FAILED_BYNAME=()
# Global counter of passed tests
PASSED=0

# Version of Node to install for tgui
NODE_VERSION=4

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

function run_test_ci {
    if [[ "$CI" == "true" ]]
    then run_test "$@"
    else msg_meh "skipping \"$1\""
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

function find_code_deps {
    need_cmd grep
    need_cmd md5sum
    need_cmd python3
    need_cmd pip
}

function find_icon_deps {
    need_cmd python3
}

function find_code {
    if [[ -z ${CODEPATH+x} ]]; then
        if [[ -d ./code ]]
        then CODEPATH=.
        else if [[ -d ../code ]]
            then CODEPATH=..
            fi
        fi
    fi
    cd $CODEPATH
    if [[ ! -d ./code ]]
    then err "invalid CODEPATH: $PWD"
    else msg "found code at $PWD"
    fi
}

function run_code_quality_tests {
    msg "*** Running Code Quality Checks ***"
    find_code_deps
    pip install --user PyYaml -q
    pip install --user beautifulsoup4 -q
    shopt -s globstar
    run_test_fail "maps contain no step_[xy]" "grep 'step_[xy]' maps/**/*.dmm"
    run_test_fail "no invalid spans" "grep -En \"<\s*span\s+class\s*=\s*('[^'>]+|[^'>]+')\s*>\" **/*.dm"
    run_test "check tags" "python3 ./tools/TagMatcher/tag-matcher.py ."
    run_test "check color hex" "python3 ./tools/ColorHexChecker/color-hex-checker.py ."
    run_test "check punctuation" "python3 ./tools/PunctuationChecker/punctuation-checker.py ."

    run_test_ci "check globals build" "python3 ./tools/GenerateGlobalVarAccess/gen_globals.py $TARGET_PROJECT_NAME.dme code/_helpers/global_access.dm"
#   run_test "check globals unchanged" "md5sum -c - <<< '5eaa581969e84a62c292a7015fee8960 *code/_helpers/global_access.dm'"
}

function run_icon_validity_tests {
    msg "*** Running Icon Validity Checks ***"
    find_icon_deps
    run_test "check icon state limit" "python3 ./tools/dmitool/check_icon_state_limit.py ."
}

function run_all_tests {
    run_code_quality_tests
    run_icon_validity_tests
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]
then
	find_code
	run_all_tests
	check_fail
fi
