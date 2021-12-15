#!/bin/bash
set -e

TAG="0.1"
CACHE_OPTION= #"--no-cache"
IMAGE_NAME="unimrcp-asterisk"
CONTAINER_NAME="unimrcp-asterisk-container-${RANDOM}"

docker build ${CACHE_OPTION} -t ${IMAGE_NAME}:${TAG} scripts/

#docker run --name ${CONTAINER_NAME} ${IMAGE_NAME} bin/bash
