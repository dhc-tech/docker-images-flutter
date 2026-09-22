# Flutter CI image — Android only. Built FROM base.Dockerfile (Ubuntu +
# Firebase CLI + Flutter SDK) plus the Android SDK — no Chrome, no Linux
# desktop toolchain, so an Android-only build (e.g. `flutter build apk`)
# doesn't pay for tooling it never uses.
#
# BASE_IMAGE: the locally-built base.Dockerfile image tag — see
# build-and-push.yml, which builds base.Dockerfile first and passes its
# tag in here.
ARG BASE_IMAGE
FROM ${BASE_IMAGE}

SHELL ["/bin/bash", "-eo", "pipefail", "-c"]

RUN apt-get update \
    && apt-get install -y --no-install-recommends openjdk-21-jdk-headless \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# https://developer.android.com/studio#command-line-tools-only — pinned to
# an exact build (15859902) rather than a "latest" URL, so this image is
# reproducible and doesn't silently pick up a new cmdline-tools release.
ENV ANDROID_HOME=/opt/android-sdk
ENV ANDROID_SDK_ROOT=${ANDROID_HOME}
ENV ANDROID_CMDLINE_TOOLS_VERSION=15859902
ENV PATH="${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${PATH}"

RUN mkdir -p "${ANDROID_HOME}/cmdline-tools" \
    && curl -sSLo /tmp/cmdline-tools.zip \
        "https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_CMDLINE_TOOLS_VERSION}_latest.zip" \
    && unzip -q /tmp/cmdline-tools.zip -d "${ANDROID_HOME}/cmdline-tools" \
    && mv "${ANDROID_HOME}/cmdline-tools/cmdline-tools" "${ANDROID_HOME}/cmdline-tools/latest" \
    && rm /tmp/cmdline-tools.zip

# No hardcoded platforms;android-<N> or build-tools;<N> here on purpose —
# guessing a specific version number is exactly what broke earlier (37
# doesn't exist as a real published platform). Instead: accept every SDK
# license up front, and let the Android Gradle Plugin's own official
# auto-download mechanism install whatever exact compileSdk/build-tools
# version a given consuming project's build.gradle.kts actually asks for,
# the first time it's built — https://developer.android.com/studio/intro/update#download-with-gradle.
# This image works unmodified for any project's SDK level, current or
# future, without ever needing a version bump here.
RUN yes | sdkmanager --licenses || [ "${PIPESTATUS[1]}" -eq 0 ] \
    && sdkmanager "platform-tools" \
    && rm -rf "${ANDROID_HOME}/.temp" /root/.android/cache

# cmake for native/NDK builds — not covered by Gradle's own auto-download,
# and Flutter has no official pinned constant for it (unlike compileSdk/
# ndkVersion below), so this is a plain static version.
RUN yes | sdkmanager --licenses || [ "${PIPESTATUS[1]}" -eq 0 ] \
    && sdkmanager "cmake;3.22.1" \
    && rm -rf "${ANDROID_HOME}/.temp" /root/.android/cache

RUN yes | flutter doctor --android-licenses || [ "${PIPESTATUS[1]}" -eq 0 ] \
    && flutter doctor -v \
    && flutter precache --android

# compileSdk platform + NDK are both installed dynamically here, read
# straight out of the just-cloned Flutter SDK's own official constants
# (packages/flutter_tools/lib/src/android/gradle_utils.dart) instead of
# hardcoded version numbers — the exact same values android/app/
# build.gradle.kts resolves to via `compileSdk = flutter.compileSdkVersion`
# and `ndkVersion = flutter.ndkVersion`. Bumping FLUTTER_REF to a release
# with different defaults automatically installs the matching platform/NDK
# here too — no separate Dockerfile bump needed when Flutter's own pins
# change.
RUN GRADLE_UTILS="${FLUTTER_HOME}/packages/flutter_tools/lib/src/android/gradle_utils.dart" \
    && COMPILE_SDK=$(grep -oE "compileSdkVersionInt = [0-9]+" "${GRADLE_UTILS}" | grep -oE "[0-9]+") \
    && NDK_VERSION=$(grep -oE "ndkVersion = '[0-9.]+'" "${GRADLE_UTILS}" | grep -oE "[0-9.]+") \
    && test -n "${COMPILE_SDK}" && test -n "${NDK_VERSION}" \
    && echo "Installing Flutter's official compileSdk: android-${COMPILE_SDK}, NDK: ${NDK_VERSION}" \
    && sdkmanager "platforms;android-${COMPILE_SDK}" "ndk;${NDK_VERSION}" \
    && echo "${COMPILE_SDK}" > /opt/flutter-compilesdk-version.txt \
    && echo "${NDK_VERSION}" > /opt/flutter-ndk-version.txt \
    && rm -rf "${ANDROID_HOME}/.temp" /root/.android/cache
