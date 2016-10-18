#!/bin/bash

if [[ ! -z "${DEPLOY_DEBUG}" ]] ; then
	set -x
fi

export DEPLOY_APP_NAME="deployables"
export DEPLOY_ECS_FAMILIES="foo bar"

export DEPLOY_ECR_ACCOUNT=123456789
export DEPLOY_ECR_HOST="${DEPLOY_ECR_ACCOUNT}.dkr.ecr.us-east-1.amazonaws.com"

export DEPLOY_AWS_ACCOUNT=987654321
export DEPLOY_AWS_PROFILE=deployables-dev
export DEPLOY_AWS_ROLE="ops-admin"
export DEPLOY_AWS_SOURCE_PROFILE="circleci"


# step 1: docker build
export DEPLOY_DOCKERFILE="$@/Dockerfile"
export DEPLOY_DOCKER_LOCAL_TAG="${DEPLOY_APP_NAME}:local"

# step 2: docker tag for ecr
export DEPLOY_DOCKER_REMOTE_TAG="${DEPLOY_ECR_HOST}/${DEPLOY_APP_NAME}:test"

# step 3: docker pull and retag
export DEPLOY_DOCKER_TARGET_TAG="${DEPLOY_ECR_HOST}/${DEPLOY_APP_NAME}:retag"

# for 06_ecs_deploy.sh test
export DEPLOY_PUSH_SECONDARY_TAG="secondary"
export DEPLOY_TASK_DEF_TEMPLATE="$@/Dockerfile/task_def-FAMILY.txt"

# for macos, after running `brew install gettext`
export DEPLOY_ENVSUBST_COMMAND="/usr/local/Cellar/gettext/0.19.8.1/bin/envsubst"

