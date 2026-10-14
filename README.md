# docker-images-flutter

[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/dhc-tech/docker-images-flutter/badge)](https://scorecard.dev/viewer/?uri=github.com/dhc-tech/docker-images-flutter)
[![Docker Images](https://github.com/dhc-tech/docker-images-flutter/actions/workflows/build-and-push.yml/badge.svg)](https://github.com/dhc-tech/docker-images-flutter/actions/workflows/build-and-push.yml)
[![CI Build](https://github.com/dhc-tech/docker-images-flutter/actions/workflows/pr-check.yml/badge.svg)](https://github.com/dhc-tech/docker-images-flutter/actions/workflows/pr-check.yml)
[![Release](https://img.shields.io/github/v/release/dhc-tech/docker-images-flutter?color=blue&label=release)](https://github.com/dhc-tech/docker-images-flutter/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Prebuilt Flutter CI images on plain Ubuntu. The Android SDK and NDK, Chrome,
the Linux desktop toolchain, Flutter and the Firebase CLI are installed when
the image is built, so your pipeline pulls a ready image and spends no time
installing SDKs. New Flutter stable releases are detected and published
automatically.

Builds **Android, Web and Linux desktop**. iOS, macOS and Windows need the real
OS and toolchain and cannot be built in any Linux container.

## Pick an image

Public on `ghcr.io/dhc-tech`, no registry credentials needed.

| Image | Contains | Use it to build |
|---|---|---|
| `flutter-android` | Flutter, Android SDK + NDK, JDK 21 | Android only |
| `flutter-web` | Flutter, headless Chrome | Web only |
| `flutter-linux` | Flutter, Linux desktop toolchain | Linux desktop only |
| `flutter` | Everything above | Several platforms in one pipeline |

```yaml
# GitHub Actions
container:
  image: ghcr.io/dhc-tech/flutter-android:stable
```

`:stable` follows Flutter's stable channel. For reproducible builds use an
exact version such as `:3.47.7`.

## Documentation

| | |
|---|---|
| [Images and tags](docs/images.md) | What each image contains, tag meanings |
| [Usage](docs/usage.md) | GitHub Actions, GitLab, Bitbucket, caching, checking the version |
| [Releases](docs/releases.md) | How versions are detected and published |
| [Automation](docs/automation.md) | PR labels, auto-merge, bots, required checks |
| [Development](docs/development.md) | Repo layout, building and testing locally, adding a toolchain |
| [Supply chain](docs/supply-chain.md) | Pinning, attestations, scanning |

Project files: [Contributing](CONTRIBUTING.md) · [Changelog](CHANGELOG.md) ·
[Security](SECURITY.md) · [Code of Conduct](CODE_OF_CONDUCT.md) ·
[AI assistant rules](AGENTS.md)
