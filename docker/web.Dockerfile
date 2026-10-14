# Web build image: base + Google Chrome. See scripts/install-web.sh.
ARG BASE_IMAGE=flutter-base:build
FROM ${BASE_IMAGE}

SHELL ["/bin/bash", "-eo", "pipefail", "-c"]

ENV CHROME_EXECUTABLE=/usr/bin/google-chrome-stable

RUN --mount=type=bind,source=docker/scripts,target=/scripts \
    bash /scripts/install-web.sh
