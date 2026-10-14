#!/usr/bin/env bash
# Linux desktop toolchain — https://docs.flutter.dev/platform-integration/linux/building
set -euo pipefail

apt-get update
apt-get install -y --no-install-recommends \
    clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev
apt-get clean
rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

flutter config --enable-linux-desktop
flutter precache --linux
