#!/bin/sh -e

apt update
apt install -y \
    android-sdk-libsparse-utils \
    autoconf \
    automake \
    binfmt-support \
    cmake \
    debian-archive-keyring \
    debootstrap \
    device-tree-compiler \
    fdisk \
    g++-aarch64-linux-gnu \
    gcc-aarch64-linux-gnu \
    gcc-arm-none-eabi \
    libtool \
    make \
    pkg-config \
    python3-cryptography \
    python3-pyasn1-modules \
    python3-pycryptodome \
    qemu-user-static \
    unzip \
    wget 

# The ubuntu-22.04 runner's debian-archive-keyring predates bookworm, so fetch
# the bookworm release + archive keys and refuse them unless the release key's
# fingerprint matches.
KR=/usr/share/keyrings/debian-bookworm-build.gpg
TMPK=$(mktemp -d)
wget -qO ${TMPK}/release-12.asc https://ftp-master.debian.org/keys/release-12.asc
wget -qO ${TMPK}/archive-key-12.asc https://ftp-master.debian.org/keys/archive-key-12.asc
gpg --show-keys --with-colons ${TMPK}/release-12.asc | grep -q '^fpr:::::::::4D64FEC119C2029067D6E791F8D2585B8783D481:' \
    || { echo "bookworm release key fingerprint mismatch" >&2; exit 1; }
cat ${TMPK}/release-12.asc ${TMPK}/archive-key-12.asc | gpg --dearmor > ${KR}
rm -rf ${TMPK}
