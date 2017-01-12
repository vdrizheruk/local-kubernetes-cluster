#!/bin/bash
DIR=$(dirname $(readlink -f $0))
. ${DIR}/tools.sh

IMAGE_NAME="vdrizheruk/vault"
IMAGE_TAG="0.6.4"
IMAGE=`echo "${IMAGE_NAME}:${IMAGE_TAG}" | sed -e 's/[\.\:\/&]/\\\\&/g'`

if [ 0 -lt `docker images | grep '${IMAGE}' | wc -l $1` ]; then
    docker -- pull `echo ${IMAGE} | sed -e 's/\\\\//g'`
fi

build "${DIR}/vault"  ${IMAGE_NAME} ${IMAGE_TAG}

echo
info "To push this image to the docker registry please run:"
echo "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
echo

exit 0
