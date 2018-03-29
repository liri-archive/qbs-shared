#!/bin/bash

set -e

msg() {
    lightblue='\033[1;34m'
    reset='\e[0m'
    echo -e "${lightblue}$@${reset}"
}

# Install
msg "Install packages..."
apt-get install -y \
    g++ clang \
    git \
    qbs

# Configure qbs
msg "Setup qbs..."
qbs setup-toolchains --detect
qbs setup-qt $(which qmake) travis-qt5
qbs config profiles.travis-qt5.baseProfile $CC

# Build
msg "Build..."
qbs -d build -j $(nproc) --all-products profile:travis-qt5 \
    project.prefix:/usr
