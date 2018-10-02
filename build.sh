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

# Make a dist image (multi-stage)
docker build \
	--cache-from "${DOCKER_TAG}-build" \
	--tag "${DOCKER_TAG}-dist" \
	--tag "${DOCKER_TAG}-${TRAVIS_TAG}" \
	--tag "${DOCKER_TAG}" \
	--target dist \
	.

DIST_DIR=$PWD/dist
mkdir -p ${DIST_DIR}
docker run -v ${DIST_DIR}:/vol ${DOCKER_TAG} /bin/sh -c 'cp /opt/ffmpeg/bin/* /opt/ffmpeg/COPYING.GPLv3 /vol'

tar -czvf "$PWD/ffmpeg-build-lambda.tar.gz" -C ${DIST_DIR} .

