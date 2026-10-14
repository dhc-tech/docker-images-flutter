# Flutter CI images, one stage per image:
#
#   base     Ubuntu + git + Firebase CLI + Flutter SDK (never published)
#   android  base + Android SDK/NDK          -> ghcr.io/<owner>/flutter-android
#   web      base + Chrome                   -> ghcr.io/<owner>/flutter-web
#   linux    base + Linux desktop toolchain  -> ghcr.io/<owner>/flutter-linux
#   combo    android + web + linux           -> ghcr.io/<owner>/flutter
#
# Build one with `--target <stage>` (see Makefile); CI builds all of them in
# one `docker buildx bake` (docker/docker-bake.hcl) so the base stage is built
# once and shared. Toolchain logic lives in docker/scripts/install-*.sh.
#
# iOS, macOS and Windows builds are not possible from a Linux container.
#
# FLUTTER_REF: a git tag (e.g. 3.47.2) or branch name (stable/beta/main).

FROM ubuntu:26.04@sha256:f144425ff09be612d6d9ad965196e9cdc23dae1f42110a8a11a3e9a8198759f7 AS base

SHELL ["/bin/bash", "-eo", "pipefail", "-c"]

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANGUAGE=en_US:en

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl ca-certificates unzip xz-utils git gnupg locales \
    && locale-gen en_US.UTF-8 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Pinned rather than /bin/linux/latest so a rebuild gets the same CLI.
# https://github.com/firebase/firebase-tools/releases
ENV FIREBASE_CLI_VERSION=15.30.0
RUN curl -fsSL "https://firebase.tools/bin/linux/v${FIREBASE_CLI_VERSION}" -o /usr/local/bin/firebase \
    && chmod +x /usr/local/bin/firebase \
    && firebase --version

ARG FLUTTER_REF=stable
ENV FLUTTER_HOME=/opt/flutter
ENV PATH="${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin:${PATH}"

# No precache here: which artifacts to fetch (--android/--web/--linux) is what
# differs per image, so each install script precaches its own.
RUN git clone --depth 1 --branch "${FLUTTER_REF}" https://github.com/flutter/flutter.git "${FLUTTER_HOME}"

# Records the ref this image was built for so a pipeline can assert against it.
RUN echo "${FLUTTER_REF}" > /opt/flutter-ref.txt


FROM base AS android

ENV ANDROID_HOME=/opt/android-sdk \
    ANDROID_SDK_ROOT=/opt/android-sdk \
    ANDROID_NDK_HOME=/opt/android-sdk/ndk-bundle \
    ANDROID_NDK_ROOT=/opt/android-sdk/ndk-bundle \
    ANDROID_CMDLINE_TOOLS_VERSION=15859902
ENV PATH="${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_NDK_HOME}:${PATH}"

RUN --mount=type=bind,source=docker/scripts,target=/scripts \
    bash /scripts/install-android.sh


FROM base AS web

ENV CHROME_EXECUTABLE=/usr/bin/google-chrome-stable

RUN --mount=type=bind,source=docker/scripts,target=/scripts \
    bash /scripts/install-web.sh


FROM base AS linux

RUN --mount=type=bind,source=docker/scripts,target=/scripts \
    bash /scripts/install-linux.sh


# Built on top of android so that stage is shared, not rebuilt.
FROM android AS combo

ENV CHROME_EXECUTABLE=/usr/bin/google-chrome-stable

RUN --mount=type=bind,source=docker/scripts,target=/scripts \
    bash /scripts/install-web.sh
RUN --mount=type=bind,source=docker/scripts,target=/scripts \
    bash /scripts/install-linux.sh
