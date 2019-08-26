#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then
    echo This script needs to be run as the super user.
    echo     $ sudo $0
    exit 1
fi

# Abort script on errors.
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -xeuo pipefail


# Mount EFS

apt-get update
apt-get install -y nfs-common

mkdir -p /mnt/efs
sudo -u `logname` ln -s -f /mnt/efs ~/

AWS_REGION=`hostname -d | awk -F'.' '{print $1}'`
if [ "$AWS_REGION"="eu-west-1" ] ; then
    EFS_SERVER=fs-33b43ffa.efs.eu-west-1.amazonaws.com
fi
if [ "$AWS_REGION"="us-east-1" ] ; then
    EFS_SERVER=fs-08886740.efs.us-east-1.amazonaws.com
fi

if [ "EFS_SERVER" ] ; then
    if ! grep /mnt/efs /etc/fstab ; then
	echo ${EFS_SERVER}:/ /home/ubuntu/efs nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport 0 0 >> /etc/fstab
    fi
    mount /mnt/efs
fi








