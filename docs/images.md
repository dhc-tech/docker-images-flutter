# Images and tags

All images are published to `ghcr.io/dhc-tech/<image>`. Every platform image
is a stage of one `docker/Dockerfile` that shares a common base (Ubuntu,
Flutter, Firebase CLI) and installs its toolchain with the scripts in
`docker/scripts/`, so a toolchain is identical in the single-platform image and
in `flutter`. The base is a build stage only and is not published.

## Contents

| Image | Contents (all include Ubuntu 26.04 with a pinned digest, git, curl, Flutter SDK and Firebase CLI) |
|---|---|
| `flutter-android` | JDK 21, Android command-line tools, platforms 34, 35, 37 and Flutter's `compileSdk`, build-tools 34-37, CMake 3.22.1, the NDK version Flutter pins |
| `flutter-web` | Google Chrome stable (amd64 only), `CHROME_EXECUTABLE` set |
| `flutter-linux` | clang, cmake, ninja, pkg-config, GTK 3, liblzma, Linux desktop enabled |
| `flutter` | Android + Web + Linux together |

Android licenses are accepted and `ANDROID_HOME`, `ANDROID_NDK_HOME` and
`PATH` are set. The compileSdk and NDK versions are read from the Flutter SDK
at build time (`/opt/flutter-compilesdk-version.txt`,
`/opt/flutter-ndk-version.txt`), so they always match what Flutter expects.

## Tags

| Tag | Meaning | Moves? |
|---|---|---|
| `<version>` e.g. `3.47.7` | Exact Flutter release | Never |
| `<major.minor>` e.g. `3.47`, `<major>` e.g. `3` | Latest release in that line | On new release |
| `pinned` | Same build as the current `<version>` | On new release |
| `stable`, `latest` | Flutter's current stable release | On new release |

Only stable releases are built. Flutter's `beta` and `main` channels are not
published.
