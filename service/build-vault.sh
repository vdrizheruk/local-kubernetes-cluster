#!/bin/bash
DIR=$(dirname $(readlink -f $0))
. ${DIR}/tools.sh

IMAGE_NAME="vdrizheruk/vault"
IMAGE_TAG="0.6.2"
IMAGE=`echo "${IMAGE_NAME}:${IMAGE_TAG}" | sed -e 's/[\.\:\/&]/\\\\&/g'`

cat "${DIR}/vault/Dockerfile.template" | sed -e "s/%VAULT_VERSION%/${IMAGE_TAG}/g" > "${DIR}/vault/Dockerfile"

if [ 0 -lt `docker images | grep '${IMAGE}' | wc -l $1` ]; then
    docker -- pull `echo ${IMAGE} | sed -e 's/\\\\//g'`
fi

build "${DIR}/vault"  ${IMAGE_NAME} ${IMAGE_TAG}

rm ${DIR}/vault/Dockerfile

echo
info "To push this image to the docker registry please run:"
echo "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
echo

exit 0
