#!/bin/bash

DIR=$(dirname $(readlink -f "$0"))
. ${DIR}/tools.sh

KUBECTL=/usr/bin/kubectl
NAMESPACE="vault"
VAULT_IMAGE="vdrizheruk/vault:0.6.4"

while [ -z ${SRV_CONTAINER_POOL} ] || [ 0 -eq ${#SRV_CONTAINER_POOL} ]; do
  note "Please specify pool for service containers (by default it's must be a cluster name):"
  read SRV_CONTAINER_POOL
done

while [ -z ${VAULT_IMAGE} ] || [ 0 -eq ${#VAULT_IMAGE} ]; do
  note "Please specify Vault image:"
  read VAULT_IMAGE
done

REPLICAS_COUNT=1
TIMESTAMP=`dd if=/dev/urandom bs=128 count=1 2>/dev/null | LC_ALL=C tr -dc 'a-z' | fold -w 4 | head -n 1 | awk '{print tolower($0)}'`

MEMORY_LIMIT="128M"
MEMORY_REQUESTED="128M"

CPU_LIMIT="100m"
CPU_REQUESTED="100m"


${KUBECTL} delete namespace ${NAMESPACE}
${KUBECTL} create namespace ${NAMESPACE}


info "Creating Vault Service..."
SRV_TPL=`cat ${DIR}/vault/tpl/srv.json`
SRV_TPL=${SRV_TPL//%TIMESTAMP%/${TIMESTAMP}}
echo ${SRV_TPL} | ${KUBECTL} --namespace=${NAMESPACE} create -f - || error "Can't create Vault Service."


info "Creating Vault Replication Controller..."
RC_TPL=`cat ${DIR}/vault/tpl/rc.json`
RC_TPL=${RC_TPL//%SRV_CONTAINER_POOL%/${SRV_CONTAINER_POOL}}
RC_TPL=${RC_TPL//%IMAGE%/${VAULT_IMAGE}}
RC_TPL=${RC_TPL//%TIMESTAMP%/${TIMESTAMP}}
RC_TPL=${RC_TPL//%REPLICAS_COUNT%/${REPLICAS_COUNT}}
RC_TPL=${RC_TPL//%MEMORY_LIMIT%/${MEMORY_LIMIT}}
RC_TPL=${RC_TPL//%MEMORY_REQUESTED%/${MEMORY_REQUESTED}}
RC_TPL=${RC_TPL//%CPU_LIMIT%/${CPU_LIMIT}}
RC_TPL=${RC_TPL//%CPU_REQUESTED%/${CPU_REQUESTED}}
echo ${RC_TPL} | ${KUBECTL} --namespace=${NAMESPACE} create -f - || error "Can't create Vault Replication Controller."
