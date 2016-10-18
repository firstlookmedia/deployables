#!/bin/bash

pushd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null

. ./environment.sh

env | grep DEPLOY

popd > /dev/null
