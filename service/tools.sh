#!/bin/bash
function build {
    local IMAGE_ID
    local WD
    WD=$(pwd)
    cd $1
    docker build -t "${2}:${3}" .
    cd ${WD}
}
function info {
    printf "\033[0;36m${1}\033[0m \n"
}
function note {
    printf "\033[0;33m${1}\033[0m \n"
}
function success {
    printf "\033[0;32m${1}\033[0m \n"
}
function sucess {
    success $1
}
function warning {
    printf "\033[0;95m${1}\033[0m \n"
}
function error {
    printf "\033[0;31m${1}\033[0m \n"
    exit 1
}
