#!/bin/bash

DIR=$(dirname $(readlink -f "$0"))
. ${DIR}/tools.sh

KUBECTL=/usr/bin/kubectl
NAMESPACE="elastic"
IMAGE="vdrizheruk/elastic:2.4.1"

while [ -z ${SRV_CONTAINER_POOL} ] || [ 0 -eq ${#SRV_CONTAINER_POOL} ]; do
  note "Please specify pool for service containers (by default it's must be a cluster name):"
  read SRV_CONTAINER_POOL
done

while [ -z ${IMAGE} ] || [ 0 -eq ${#IMAGE} ]; do
  note "Please specify Elastic image:"
  read IMAGE
done

REPLICAS_COUNT=1
TIMESTAMP=`dd if=/dev/urandom bs=128 count=1 2>/dev/null | LC_ALL=C tr -dc 'a-z' | fold -w 4 | head -n 1 | awk '{print tolower($0)}'`

MEMORY_LIMIT="2048M"
MEMORY_REQUESTED="2048M"

CPU_LIMIT="2000m"
CPU_REQUESTED="2000m"


${KUBECTL} delete namespace ${NAMESPACE}
${KUBECTL} create namespace ${NAMESPACE}


info "Creating Elastic Service..."
SRV_TPL=`cat ${DIR}/elastic/tpl/srv.json`
SRV_TPL=${SRV_TPL//%TIMESTAMP%/${TIMESTAMP}}
echo ${SRV_TPL} | ${KUBECTL} --namespace=${NAMESPACE} create -f - || error "Can't create Elastic Service."


info "Creating Elastic Replication Controller..."
RC_TPL=`cat ${DIR}/elastic/tpl/rc.json`
RC_TPL=${RC_TPL//%SRV_CONTAINER_POOL%/${SRV_CONTAINER_POOL}}
RC_TPL=${RC_TPL//%IMAGE%/${IMAGE}}
RC_TPL=${RC_TPL//%TIMESTAMP%/${TIMESTAMP}}
RC_TPL=${RC_TPL//%REPLICAS_COUNT%/${REPLICAS_COUNT}}
RC_TPL=${RC_TPL//%MEMORY_LIMIT%/${MEMORY_LIMIT}}
RC_TPL=${RC_TPL//%MEMORY_REQUESTED%/${MEMORY_REQUESTED}}
RC_TPL=${RC_TPL//%CPU_LIMIT%/${CPU_LIMIT}}
RC_TPL=${RC_TPL//%CPU_REQUESTED%/${CPU_REQUESTED}}
echo ${RC_TPL} | ${KUBECTL} --namespace=${NAMESPACE} create -f - || error "Can't create Elastic Replication Controller."

