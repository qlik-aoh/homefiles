#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then
    echo This script needs to be run as the super user.
    echo     $ sudo $0
    exit 1
fi

# Abort script on errors.
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -xeuo pipefail

# Install VSCode
# From https://code.visualstudio.com/docs/setup/linux
apt-get -y install apt-transport-https
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list
apt-get update
apt-get -y install code # or code-insiders

# Install sublime text
apt-get install -y apt-transport-https
apt-get install -y libgtk2.0.0
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
apt-add-repository "deb https://download.sublimetext.com/ apt/stable/"
apt-get update
apt install -y sublime-text


# AWS
apt-get install -y awscli
go get -u github.com/awslabs/amazon-ecr-credential-helper/ecr-login/cli/docker-credential-ecr-login

