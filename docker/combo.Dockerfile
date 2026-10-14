# Combo image (published as `flutter`): base + Android + Web + Linux desktop,
# built from the same install scripts as the single-platform images so the
# toolchains can never drift apart.
#
# iOS, macOS and Windows builds are not possible from a Linux container —
# they need the real OS toolchain.
ARG BASE_IMAGE=flutter-base:build
FROM ${BASE_IMAGE}

SHELL ["/bin/bash", "-eo", "pipefail", "-c"]

ENV ANDROID_HOME=/opt/android-sdk \
    ANDROID_SDK_ROOT=/opt/android-sdk \
    ANDROID_NDK_HOME=/opt/android-sdk/ndk-bundle \
    ANDROID_NDK_ROOT=/opt/android-sdk/ndk-bundle \
    ANDROID_CMDLINE_TOOLS_VERSION=15859902 \
    CHROME_EXECUTABLE=/usr/bin/google-chrome-stable
ENV PATH="${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_NDK_HOME}:${PATH}"

RUN --mount=type=bind,source=docker/scripts,target=/scripts \
    bash /scripts/install-android.sh
RUN --mount=type=bind,source=docker/scripts,target=/scripts \
    bash /scripts/install-web.sh
RUN --mount=type=bind,source=docker/scripts,target=/scripts \
    bash /scripts/install-linux.sh
