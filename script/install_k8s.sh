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

# Make sure we have the latest package list
apt-get update

# 1. Install docker (https://docs.docker.com/install/linux/docker-ce/ubuntu/)
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# Make sure libcurl4 is installed
apt install -y libcurl4 curl
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"

# Install docker
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io
gpasswd -a ${SUDO_USER} docker
if [[ -f /usr/bin/docker-credential-secretservice ]]; then
    mv /usr/bin/docker-credential-secretservice /usr/bin/docker-credential-secretservice_x
fi
sudo -u ${SUDO_USER} mkdir -p ${SUDO_USER_HOME}/.docker


# 2. Install kubectl
snap install kubectl --classic

# Shell completion for bash
if [[ ! -f /etc/bash_completion.d/kubectl ]]; then
    kubectl completion bash > /etc/bash_completion.d/kubectl
fi


# 3. Install helm
snap install helm --classic

# Shell completion for bash
if [[ ! -f /etc/bash_completion.d/helm ]]; then
    helm completion bash > /etc/bash_completion.d/helm
fi



# 4. Install minikube
#    https://github.com/kubernetes/minikube/blob/master/docs/vmdriver-none.md
curl -Lo /tmp/minikube \
  https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && sudo install /tmp/minikube /usr/local/bin/
if [[ -f "/tmp/minikube" ]]; then
    rm /tmp/minikube
fi
sudo -u ${SUDO_USER} mkdir -p ${SUDO_USER_HOME}/.kube ${SUDO_USER_HOME}/.minikube
sudo -u ${SUDO_USER} touch ${SUDO_USER_HOME}/.kube/config

# https://stackoverflow.com/questions/51280172/how-to-use-kubectl-command-instead-of-sudo-kubectl
sudo chown -R ${SUDO_USER} ${SUDO_USER_HOME}/.kube


# 5. Install socat
apt-get -y install socat


