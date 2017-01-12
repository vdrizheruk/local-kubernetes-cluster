#!/bin/bash
DIR=$(dirname $(readlink -f $0))
. ${DIR}/tools.sh

IMAGE_NAME="vdrizheruk/elastic"
IMAGE_TAG="2.4.1"
IMAGE=`echo "${IMAGE_NAME}:${IMAGE_TAG}" | sed -e 's/[\.\:\/&]/\\\\&/g'`

if [ 0 -lt `docker images | grep '${IMAGE}' | wc -l $1` ]; then
    gcloud docker -- pull `echo ${IMAGE} | sed -e 's/\\\\//g'`
fi

build "${DIR}/elastic"  ${IMAGE_NAME} ${IMAGE_TAG}

echo
info "To push this image to the docker registry please run:"
echo "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
echo

exit 0
