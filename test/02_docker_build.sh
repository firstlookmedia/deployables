#!/bin/bash

pushd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null
. ./environment.sh $( dirname "${BASH_SOURCE[0]}" )
popd > /dev/null

output=$(
	DEPLOY_DOCKERFILE="${DEPLOY_DOCKERFILE}" \
	DEPLOY_DOCKER_LOCAL_TAG="${DEPLOY_DOCKER_LOCAL_TAG}" \
	./bin/deployables docker_build 2>&1
)

if [[ $? == 0 ]] ; then
	echo "[ok] docker_build succeeded"
else
	echo "[error] docker_build failed"
	echo "$output"
	exit 1
fi
