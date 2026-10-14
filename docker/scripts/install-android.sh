#!/usr/bin/env bash
# Android toolchain: JDK, SDK command-line tools, platforms, build-tools, NDK.
# Expects ANDROID_HOME, ANDROID_CMDLINE_TOOLS_VERSION and FLUTTER_HOME from
# the Dockerfile ENV. Everything is baked in so consuming CI never downloads
# SDK components at build time.
set -euo pipefail

apt-get update
apt-get install -y --no-install-recommends openjdk-21-jdk-headless
apt-get clean
rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

mkdir -p "${ANDROID_HOME}/cmdline-tools"
curl -fsSLo /tmp/cmdline-tools.zip \
    "https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_CMDLINE_TOOLS_VERSION}_latest.zip"
unzip -q /tmp/cmdline-tools.zip -d "${ANDROID_HOME}/cmdline-tools"
mv "${ANDROID_HOME}/cmdline-tools/cmdline-tools" "${ANDROID_HOME}/cmdline-tools/latest"
rm /tmp/cmdline-tools.zip

export PATH="${ANDROID_HOME}/cmdline-tools/latest/bin:${PATH}"

# `yes` gets SIGPIPE (141) when sdkmanager stops reading — only fail if
# sdkmanager itself (PIPESTATUS[1]) failed.
yes | sdkmanager --licenses >/dev/null || [ "${PIPESTATUS[1]}" -eq 0 ]

# compileSdk and NDK are read from the cloned Flutter SDK's own constants —
# the same values `flutter.compileSdkVersion` / `flutter.ndkVersion` resolve
# to in a project's build.gradle — so bumping FLUTTER_REF installs the
# matching versions with no edit here.
gradle_utils="${FLUTTER_HOME}/packages/flutter_tools/lib/src/android/gradle_utils.dart"
compile_sdk=$(grep -oE "compileSdkVersionInt = [0-9]+" "${gradle_utils}" | grep -oE "[0-9]+")
ndk_version=$(grep -oE "ndkVersion = '[0-9.]+'" "${gradle_utils}" | grep -oE "[0-9.]+")
test -n "${compile_sdk}" && test -n "${ndk_version}"

echo "Installing Android platforms, build-tools and NDK ${ndk_version} (compileSdk ${compile_sdk})"
sdkmanager \
    "platform-tools" \
    "cmake;3.22.1" \
    "platforms;android-${compile_sdk}" \
    "platforms;android-37.0" \
    "platforms;android-35" \
    "platforms;android-34" \
    "build-tools;37.0.0" \
    "build-tools;36.0.0" \
    "build-tools;35.0.0" \
    "build-tools;34.0.0" \
    "ndk;${ndk_version}"

# Stable path for ANDROID_NDK_HOME regardless of the NDK version installed.
ln -s "${ANDROID_HOME}/ndk/${ndk_version}" "${ANDROID_HOME}/ndk-bundle"
echo "${compile_sdk}" > /opt/flutter-compilesdk-version.txt
echo "${ndk_version}" > /opt/flutter-ndk-version.txt

flutter precache --android
flutter doctor -v

rm -rf "${ANDROID_HOME}/.temp" /root/.android/cache
