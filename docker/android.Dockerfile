# Android build image: base + Android SDK/NDK/platforms. See scripts/install-android.sh.
ARG BASE_IMAGE=flutter-base:build
FROM ${BASE_IMAGE}

SHELL ["/bin/bash", "-eo", "pipefail", "-c"]

ENV ANDROID_HOME=/opt/android-sdk \
    ANDROID_SDK_ROOT=/opt/android-sdk \
    ANDROID_NDK_HOME=/opt/android-sdk/ndk-bundle \
    ANDROID_NDK_ROOT=/opt/android-sdk/ndk-bundle \
    ANDROID_CMDLINE_TOOLS_VERSION=15859902
ENV PATH="${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_NDK_HOME}:${PATH}"

RUN --mount=type=bind,source=docker/scripts,target=/scripts \
    bash /scripts/install-android.sh
