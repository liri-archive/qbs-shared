#!/bin/bash

set -e

source /usr/local/share/liri-travis/functions

# Configure qbs
travis_start "qbs_setup"
msg "Setup qbs..."
qbs setup-toolchains --detect
qbs setup-qt $(which qmake) travis-qt5
qbs config profiles.travis-qt5.baseProfile $CC
travis_end "qbs_setup"

# Build
travis_start "build"
msg "Build..."
qbs -d build -j $(nproc) --all-products profile:travis-qt5 \
    project.prefix:/usr
travis_end "build"
