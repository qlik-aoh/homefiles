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


# Install clang 6.0 as default clang
apt-get install -y clang-6.0 clang-6.0-doc libclang-common-6.0-dev libclang-6.0-dev libclang1-6.0 libclang1-6.0-dbg   \
	       libllvm6.0 libllvm6.0-dbg lldb-6.0 llvm-6.0 llvm-6.0-dev llvm-6.0-doc llvm-6.0-examples \
	       llvm-6.0-runtime clang-format-6.0 python-clang-6.0 libfuzzer-6.0-dev clang-tidy-6.0
 
update-alternatives --install /usr/bin/clang clang /usr/bin/clang-6.0 100 --slave /usr/bin/clang++ clang++ /usr/bin/clang++-6.0
update-alternatives --install /usr/bin/clang-tidy clang-tidy /usr/bin/clang-tidy-6.0 100
update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-6.0 100 --slave /usr/bin/git-clang-format git-clang-format /usr/bin/clang-format-6.0
update-alternatives --install /usr/bin/lldb lldb /usr/bin/lldb-6.0 100


# Install libc++
apt-get install -y libc++-dev libc++abi-dev


# Set clang as default compiler
update-alternatives --install /usr/bin/cc cc /usr/bin/clang-6.0 100
update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++-6.0 100
update-alternatives --set c++ /usr/bin/clang++-libc++ 


# Install LLVM linker lld and set it as default linker
apt-get install -y lld
update-alternatives --install /usr/bin/ld ld /usr/bin/x86_64-linux-gnu-ld 20
update-alternatives --install /usr/bin/ld ld /usr/bin/lld 100


# Set the link archiver to the LLVM version
update-alternatives --install /usr/bin/ar ar /usr/bin/x86_64-linux-gnu-ar 20
update-alternatives --install /usr/bin/ar ar /usr/bin/llvm-ar-4.0 100


# Install cmake
apt-get install -y cmake

# Install coco-cpp
apt-get install -y coco-cpp

# Install golang
apt-get install -y golang-go

# Install libbz2
apt-get install -y libbz2-1.0 libbz2-dev


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

