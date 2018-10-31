#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then
    echo This script needs to be run as the super user.
    echo     $ sudo $0
    exit 1
fi

# Abort script on errors.
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -xeuo pipefail


# Install docker
# Based on https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
apt-get update
apt-get install -y docker-ce
usermod -aG docker `logname`


# Install docker-compose
# Based on https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-ubuntu-18-04
curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose


# Is this needed?
# Build hdfs-mount
#git clone http://github.com/Microsoft/hdfs-mount --recursive
#cd /tmp/hdfs-mount;
#make -i;
#sudo mv hdfs-mount /usr/local/bin
#sed -i 's/#user_allow_other/user_allow_other/' /etc/fuse.conf


# Install Terraform
wget -O /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.11.8/terraform_0.11.8_linux_amd64.zip
unzip -o /tmp/terraform.zip -d /opt/terraform
rm -f /usr/local/bin/terraform
ln -s /opt/terraform/terraform /usr/local/bin/terraform


# Install Terraform and Packer
wget -O /tmp/packer.zip https://releases.hashicorp.com/packer/1.3.1/packer_1.3.1_linux_amd64.zip
unzip -o /tmp/packer.zip -d /opt/packer
rm -f /usr/local/bin/packer; ln -s /opt/packer/packer /usr/local/bin/packer

