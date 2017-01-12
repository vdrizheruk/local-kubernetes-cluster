#!/bin/sh

VAULT_CONFIG_DIR=/vault/config
VAULT_CONFIG=${VAULT_CONFIG_DIR}/config.json

echo "${VAULT_LOCAL_CONFIG}" > "${VAULT_CONFIG}"

/bin/vault server --config=${VAULT_CONFIG}
