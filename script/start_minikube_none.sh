#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then
    echo This script needs to be run as the super user.
    echo     $ sudo $0
    exit 1
fi

if [[ ! $SUDO_USER ]]; then
    echo SUDO_USER is not set!
    exit 2
fi

SUDO_USER_HOME=$(eval echo ~$SUDO_USER)

# Abort script on errors.
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -xeuo pipefail

export MINIKUBE_WANTUPDATENOTIFICATION=false
export MINIKUBE_WANTREPORTERRORPROMPT=false
export MINIKUBE_HOME=$SUDO_USER_HOME
export CHANGE_MINIKUBE_NONE_USER=true
export KUBECONFIG=$SUDO_USER_HOME/.kube/config

minikube start --vm-driver=none --extra-config=kubelet.resolv-conf=/run/systemd/resolve/resolv.conf
