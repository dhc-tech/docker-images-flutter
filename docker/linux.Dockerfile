# Flutter CI image — Linux desktop only. Built FROM base.Dockerfile
# (Ubuntu + Firebase CLI + Flutter SDK) plus the Linux desktop toolchain
# — no Android SDK, no Chrome.
#
# BASE_IMAGE: the locally-built base.Dockerfile image tag — see
# build-and-push.yml, which builds base.Dockerfile first and passes its
# tag in here.
ARG BASE_IMAGE=ubuntu:26.04@sha256:da6fc2be547864451aa253836dd926da33623312df4a9a243e35dc877c378a78
FROM ${BASE_IMAGE}

SHELL ["/bin/bash", "-eo", "pipefail", "-c"]

# https://docs.flutter.dev/platform-integration/linux/building
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

RUN flutter config --enable-linux-desktop \
    && flutter doctor -v \
    && flutter precache --linux
