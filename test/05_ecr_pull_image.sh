#!/bin/bash

pushd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null
. ./environment.sh $( dirname "${BASH_SOURCE[0]}" )
popd > /dev/null

output=$(
    ./bin/deployables \
	    ecr_pull_image \
	      ${DEPLOY_DOCKER_REMOTE_TAG} \
  	    2>&1
)

if [[ $? == 0 ]] ; then
    echo "[ok] ecr_pull_image succeeded"
else
    echo "[error] ecr_pull_image failed"
    echo "$output"
    exit 1
fi
