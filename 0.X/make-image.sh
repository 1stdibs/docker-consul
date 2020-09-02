#!/bin/bash
SCRIPT_NAME="$(basename ${BASH_SOURCE[0]})"
pushd $(dirname ${BASH_SOURCE[0]}) > /dev/null
SCRIPT_DIR=$(pwd)

function usage {
cat <<-EOF
Usage: ${SCRIPT_NAME}  <consul source directory>

Description:
   
    This script will build a docker container with a build from the consul source code directory provided.
EOF
}

function err {
    tput bold
    tput setaf 1

    echo "$@" 1>&2

    tput sgr0
}

if test -z "$1"
then
    err "$(usage)"
    exit 1
fi

function main {
    declare sdir="$1"

    ${sdir}/build-support/scripts/dibs-build.sh

    if test $? -ne 0
    then
        err "error building consul"
        exit 1
    fi

    cp ${sdir}/pkg/bin/linux_amd64/consul ${SCRIPT_DIR}/

    docker build --no-cache -t dibs-consul ${SCRIPT_DIR}

    rm -rf ${SCRIPT_DIR}/consul

    return $?
}

main "$@"
exit $?
