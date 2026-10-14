# Shared base layer for every image: Ubuntu, Firebase CLI and the Flutter
# SDK. android/web/linux/combo.Dockerfile build FROM this (BASE_IMAGE
# build-arg) and add only their own toolchain via docker/scripts/.
# Published as `flutter-base`, so each image build pulls it instead of
# redoing the Flutter clone.
#
# FLUTTER_REF: a git tag (e.g. 3.47.2) or branch name (stable/beta/main).
FROM ubuntu:26.04@sha256:f144425ff09be612d6d9ad965196e9cdc23dae1f42110a8a11a3e9a8198759f7

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

# Firebase CLI (standalone Linux binary), pinned to an exact released
# version rather than /bin/linux/latest — reproducible: a rebuild of this
# same Dockerfile always gets the same CLI, instead of silently picking up
# whatever firebase-tools shipped that day.
# https://github.com/firebase/firebase-tools/releases
ENV FIREBASE_CLI_VERSION=15.30.0
RUN curl -fsSL "https://firebase.tools/bin/linux/v${FIREBASE_CLI_VERSION}" -o /usr/local/bin/firebase \
    && chmod +x /usr/local/bin/firebase \
    && firebase --version

ARG FLUTTER_REF=stable
ENV FLUTTER_HOME=/opt/flutter
ENV PATH="${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin:${PATH}"

# No `flutter doctor`/`flutter precache` here — precache needs to know
# which platform artifacts to fetch (--android/--web/--linux), which is
# exactly what differs per platform image. Each platform Dockerfile
# precaches only its own artifacts after this.
RUN git clone --depth 1 --branch "${FLUTTER_REF}" https://github.com/flutter/flutter.git "${FLUTTER_HOME}"

# Bake in the exact ref this image was built for, so a build using it can
# assert against it the same way a consuming pipeline's own version check
# does — a stale/wrong image is a build-time failure, not a silent
# wrong-SDK build.
RUN echo "${FLUTTER_REF}" > /opt/flutter-ref.txt
