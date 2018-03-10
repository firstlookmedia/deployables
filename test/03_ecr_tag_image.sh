#!/bin/bash

pushd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null
. ./environment.sh $( dirname "${BASH_SOURCE[0]}" )
popd > /dev/null

output=$(
	./bin/deployables \
	    ecr_tag_image \
        ${DEPLOY_DOCKER_LOCAL_TAG} \
        ${DEPLOY_DOCKER_REMOTE_TAG} \
        2>&1
)

if [[ $? == 0 ]] ; then
    echo "[ok] ecr_tag_image succeeded"
else
    echo "[error] ecr_tag_image failed"
    echo "$output"
    exit 1
fi
