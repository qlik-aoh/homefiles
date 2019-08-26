#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then
    echo This script needs to be run as the super user.
    echo     $ sudo $0
    exit 1
fi

# Abort script on errors.
# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -xeuo pipefail


# Make sure we have the latest package list
apt-get update

# LLVM
apt-get install -y libllvm-7-ocaml-dev libllvm7 llvm-7 llvm-7-dev llvm-7-doc llvm-7-examples llvm-7-runtime
# Clang and co
apt-get install -y clang-7 clang-tools-7 clang-7-doc libclang-common-7-dev libclang-7-dev libclang1-7 clang-format-7 python-clang-7
# libfuzzer
apt-get install -y libfuzzer-7-dev
# lldb
apt-get install -y lldb-7
# lld (linker)
apt-get install -y lld-7
# libc++
apt-get install -y libc++-7-dev libc++abi-7-dev
# OpenMP
apt-get install -y libomp-7-dev
# tidy and format
apt-get install -y clang-format-7 clang-tidy-7

# Add to alternatives with high prio and use as default
update-alternatives --install /usr/bin/clang clang /usr/bin/clang-7 150 --slave /usr/bin/clang++ clang++ /usr/bin/clang++-7
update-alternatives --auto clang

update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-7 150
update-alternatives --auto clang-tidy
 
update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-7 150 --slave /usr/bin/git-clang-format git-clang-format /usr/bin/clang-format-7
update-alternatives --auto clang-format
 
update-alternatives --install /usr/bin/lldb lldb /usr/bin/lldb-7 150
update-alternatives --auto lldb

# Set clang as default compiler
update-alternatives --install /usr/bin/cc cc /usr/bin/clang-7 100
update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++-7 100
update-alternatives --auto c++

# Install LLVM linker lld and set it as default linker
#apt-get install -y lld
update-alternatives --install /usr/bin/ld ld /usr/bin/x86_64-linux-gnu-ld 20
update-alternatives --install /usr/bin/ld ld /usr/bin/lld-7 100
update-alternatives --auto ld

# Set the link archiver to the LLVM version
update-alternatives --install /usr/bin/ar ar /usr/bin/x86_64-linux-gnu-ar 20
update-alternatives --install /usr/bin/ar ar /usr/bin/llvm-ar-7 100
update-alternatives --auto ar

# Install cmake
pip install cmake

# Install coco-cpp
apt-get install -y coco-cpp

# Install libbz2
apt-get install -y libbz2-1.0 libbz2-dev


# Install golang
add-apt-repository -y ppa:longsleep/golang-backports
apt-get update
apt-get install -y golang-go
sudo -u `logname` echo export GO111MODULE=on >> ~/.bashrc


# Install gradle pre-requisites, followed by gradle itself
apt-get install -y openjdk-8-jdk wget unzip
update-ca-certificates -f
/var/lib/dpkg/info/ca-certificates-java.postinst configure

wget -P /tmp https://services.gradle.org/distributions/gradle-4.10.2-bin.zip
mkdir -p /opt/gradle
unzip -d /opt/gradle -o /tmp/gradle-4.10.2-bin.zip
rm /tmp/gradle-4.10.2-bin.zip
sudo -u `logname` echo export GRADLE_HOME=/opt/gradle/gradle-4.10.2 >> ~/.bashrc
ln -s -f /opt/gradle/gradle-4.10.2/bin/* /usr/local/bin/


# We are using an old version of libssl
apt-get install zlib1g-dev
curl -O http://launchpadlibrarian.net/348438503/libssl1.0.0_1.0.2g-1ubuntu15_amd64.deb
curl -O http://launchpadlibrarian.net/348438498/libssl-dev_1.0.2g-1ubuntu15_amd64.deb
dpkg -i libssl-dev_1.0.2g-1ubuntu15_amd64.deb libssl1.0.0_1.0.2g-1ubuntu15_amd64.deb
rm -f libssl1.0.0_1.0.2g-1ubuntu15_amd64.deb
rm -f libssl-dev_1.0.2g-1ubuntu15_amd64.deb

# Prevent updates
sudo apt-mark hold libssl1.0.0 libssl-dev

