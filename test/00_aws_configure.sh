#!/bin/bash

pushd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null
. ./environment.sh $( dirname "${BASH_SOURCE[0]}" )
popd > /dev/null

output=$(
    DEPLOY_AWS_PROFILE=${DEPLOY_AWS_PROFILE} \
    DEPLOY_AWS_ACCOUNT=${DEPLOY_AWS_ACCOUNT} \
    ./bin/deployables aws_configure 2>&1
)

if [[ $? == 0 ]] ; then
    echo "[ok] aws_configure succeeded"
else
    echo "[error] aws_configure failed"
    echo "$output"
    exit 1
fi
