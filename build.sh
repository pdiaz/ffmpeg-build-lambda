#!/usr/bin/env bash

set -ev
NUM_CORES=2
COMMIT_MSG=$(git --no-pager log -1 --oneline)

DOCKER_TAG="ffmpeg-build:lambda"

# Build the image
docker build \
	--tag "${DOCKER_TAG}-build" \
	--target build \
	.

DIST_DIR=$PWD/dist
mkdir -p ${DIST_DIR}
docker run -v ${DIST_DIR}:/vol "${DOCKER_TAG}-build" /bin/sh -c 'cp /opt/ffmpeg/bin/* /vol'

tar -czvf "$PWD/ffmpeg-build-lambda.tar.gz" -C ${DIST_DIR} .
