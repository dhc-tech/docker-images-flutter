# Linux desktop build image: base + GTK/clang/cmake/ninja. See scripts/install-linux.sh.
ARG BASE_IMAGE=flutter-base:build
FROM ${BASE_IMAGE}

SHELL ["/bin/bash", "-eo", "pipefail", "-c"]

RUN --mount=type=bind,source=docker/scripts,target=/scripts \
    bash /scripts/install-linux.sh
