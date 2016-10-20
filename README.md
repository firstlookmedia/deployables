
# deployables

A basket of deploy scripts.

Initially developed for building docker images and deploying updated task definitions to ECS via CircleCI.

## Sample circle.yml

##### Standard deploy for develop and master branches and release tags

```
machine:
   environment:
        DEPLOY_APP_NAME: "myapp"
        DEPLOY_ECR_HOST: "1234567890.dkr.ecr.us-east-1.amazonaws.com"
        DEPLOY_ECR_ACCOUNT: "1234567890"
        DEPLOY_DOCKER_LOCAL_TAG: "myapp:local"
        DEPLOY_AWS_ROLE: "ops-admin"
        DEPLOY_TASK_DEF_TEMPLATE: "./taskdefs/myapp.txt"
        DEPLOY_SHA1: "${CIRCLE_SHA1}"

[...]

deployment:

    develop:
        branch: develop
        commands:
            - ./node_modules/deployables/bin/deployables docker_build
            - >
                DEPLOY_AWS_ACCOUNT="321987654"
                ./node_modules/deployables/bin/deployables ecs_deploy


    staging:
        branch: master
        commands:
            - ./node_modules/deployables/bin/deployables docker_build
            - >
                DEPLOY_AWS_ACCOUNT="9876543210"
                DEPLOY_PUSH_SECONDARY_TAG="staging"
                ./node_modules/deployables/bin/deployables ecs_deploy

    release:
        tag: /release-.*/
        commands:
            - >
                DEPLOY_AWS_ACCOUNT="654987321"
                DEPLOY_RETAG_AND_PUSH=1
                DEPLOY_RETAG_REMOTE_TAG="staging"
                DEPLOY_RETAG_TARGET_TAG="release"
                ./node_modules/deployables/bin/deployables ecs_deploy
```

#### Deploy one image to multiple service targets

This version uses `DEPLOY_ECS_FAMILIES` to specify multiple child tasks definitions.

```
machine:
   environment:
        DEPLOY_APP_NAME: "myapp"
        DEPLOY_ECS_FAMILIES: "foo bar"
        DEPLOY_ECR_HOST: "1234567890.dkr.ecr.us-east-1.amazonaws.com"
        DEPLOY_ECR_ACCOUNT: "1234567890"
        DEPLOY_SHA1: "${CIRCLE_SHA1}"

[...]

deployment:

    develop:
        branch: develop
        commands:
            - ./node_modules/deployables/bin/deployables docker_build
            - >
                DEPLOY_DEBUG=1
                DEPLOY_AWS_ACCOUNT="321987654"
                DEPLOY_PUSH_SECONDARY_TAG="master"
                DEPLOY_TASK_DEF_TEMPLATE="./taskdefs/myapp-master-FAMILY.txt"
                ./node_modules/deployables/bin/deployables ecs_deploy
```

Note: The `-FAMILY-` in `DEPLOY_TASK_DEF_TEMPLATE` will be replaced by the values of `DEPLOY_ECS_FAMILIES`.

In other words, the example above will load ./taskdefs/myapp-master-__foo__.txt and ./taskdefs/myapp-master-__bar__.txt.


## Public Functions

#### `docker_build`

* Uses `DEPLOY_DOCKERFILE` and `DEPLOY_DOCKER_LOCAL_TAG` to call `docker build ...`


#### `ecs_deploy`

* Main function for tagging images and deploying updated task definitions

Note: This function


## Environment Variables Reference

### Input Variables

<dl>

<dt>DEPLOY_APP_NAME</dt>
<dd>Name of the application and ECS service, e.g. "myapp"</dd>

<dt>DEPLOY_AWS_ACCOUNT</dt>
<dd>AWS account number used for deploy, e.g. "123456789"</dd>

<dt>DEPLOY_AWS_CONFIG</dt>
<dd>Path to aws config file for appending profile info, default "~/.aws/config"</dd>

<dt>DEPLOY_AWS_PROFILE</dt>
<dd>AWS profile name used to make awscli calls, default "deployables"</dd>

<dt>DEPLOY_AWS_REGION</dt>
<dd>AWS region used for deploys, default "us-east-1"</dd>

<dt>DEPLOY_AWS_ROLE</dt>
<dd>Pre-existing AWS role used for deploys, default "ops-admin"</dd>

<dt>DEPLOY_AWS_SOURCE_PROFILE:</dt>
<dd>`source_profile` for `DEPLOY_AWS_PROFILE`, default "default"</dd>

<dt>DEPLOY_DEBUG</dt>
<dd>Enable verbose output of scripts using bash's `set -x`, e.g. "1"</dd>

<dt>DEPLOY_DOCKERFILE</dt>
<dd>Path to Dockerfile used by `docker_build`, default "./Dockerfile"</dd>

<dt>DEPLOY_DOCKER_LOCAL_TAG</dt>
<dd>Tag used by `docker_build` for local image, default: `$DEPLOY_APP_NAME`</dd>

<dt>DEPLOY_ECR_HOST</dt>
<dd>Hostname for ECR repository, e.g. "1234567890.dkr.ecr.us-east-1.amazonaws.com"</dd>

<dt>DEPLOY_ECR_ACCOUNT</dt>
<dd>ECR repository's AWS account number, e.g. "1234567890"</dd>

<dt>DEPLOY_ECS_FAMILIES</dt>
<dd>Used to deploy one image to multiple task definitions</dd>

<dt>DEPLOY_PUSH_SECONDARY_TAG</dt>
<dd>Tag and push the local image with a secondary tag, e.g. "staging"</dd>

<dt>DEPLOY_RETAG_AND_PUSH:</dt>
<dd>Pull and retag a remote image, and then deploy that tag, e.g. "1"</dd>

<dt>DEPLOY_RETAG_REMOTE_TAG</dt>
<dd>Existing remote tag pulled when using `DEPLOY_RETAG_AND_PUSH`, e.g. "staging"</dd>

<dt>DEPLOY_RETAG_TARGET_TAG</dt>
<dd>New tag used when using `DEPLOY_RETAG_AND_PUSH`, e.g. "release"</dd>

<dt>DEPLOY_SHA1</dt>
<dd>Typically set to commit hash using `$CIRCLE_SHA1`, default `$( date +%s | md5 )`</dd>

<dt>DEPLOY_TASK_DEF_TEMPLATE</dt>
<dd>Path to task definition templates, e.g. `./taskdefs/myapp.txt`</dd>

</dl>

### Task Definition Template Variables

Variables set by `ecs_deploy_task()` when running `envsubst` against `DEPLOY_TASK_DEF_TEMPLATE`.

<dl>

<dt>DEPLOY_IMAGE_NAME</dt>
<dd>The name of the Docker image passed in to `ecs_deploy_task()`</dd>

<dt>DEPLOY_SUBFAMILY</dt>
<dd>The subfamily of the service passed in to `ecs_deploy_task()`</dd>

</dl>

