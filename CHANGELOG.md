# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
- One install script per toolchain (`docker/scripts/install-{android,web,linux}.sh`) shared by the platform and combo images; `docker/Dockerfile` renamed to `docker/combo.Dockerfile`.
- `flutter-base` is now published and every image is built on it (single Ubuntu digest, single Flutter clone).
- `build-and-push.yml` split into a version job, a reusable `_build-image.yml`, and a release job; all images now get provenance and SBOM.
- `pr-check.yml` builds and tests every image through the `build-and-test` composite action.
- Tests split per image (`tests/{base,android,web,linux}.yaml`); `container-structure-test` pinned to v1.22.1.
- Makefile uses pattern rules (`make test-android`, `make build-all`, ...).

### Fixed
- `ANDROID_NDK_HOME` now points at the `ndk-bundle` symlink instead of a hardcoded NDK version.
- GitHub release notes listed the same tag three times instead of `<version>`, `<major.minor>`, `<major>`.

## [3.47.7] - 2026-10-14

### Added
- Official enterprise-grade Docker release for Flutter 3.47.7 (`flutter`, `flutter-android`, `flutter-web`, `flutter-linux`).
- Fully automated branch deletion (`--delete-branch`) on auto-merge to keep repository clean.
- PAT-backed auto-merges (`BOT_PAT`) allowing downstream Docker build and release pipelines to trigger seamlessly.
- Support for on-demand version specification (`inputs.version`) in manual build workflow triggers.
- Pre-installed Android SDK platforms (34, 35, 36, 37.0), build-tools (34.0.0 through 37.0.0), and official NDK (r28) with `ANDROID_NDK_HOME` for zero-runtime-download builds.
- Automated weekly image health check diagnostic workflow (`.github/workflows/image-health-check.yml`).
- High-performance caching GitHub Actions workflow example with Gradle & Pub cache in `README.md`.
- Productive developer Makefile targets (`make build-all`, `make test-all`, `make clean`).
- Real-time Docker Images build & release badge in `README.md`.
- Automated GHCR package cleanup workflow (`.github/workflows/cleanup-ghcr-packages.yml`) to purge untagged digests and intermediate layers while preserving the 3.47+ series tags.

### Fixed
- Fixed BuildKit attestation error on `build-platforms` docker driver.
- Fixed image reference in GitHub release asset body.


### Added
- Automated `needs-approval` and `automerge` label lifecycle via GitHub Actions.
- Automated AI code review integration (CodeRabbit & Sourcery).
- Aesthetic badge suite to `README.md` (CI Build, Hadolint, Yamllint, Release, License).

### Security
- Pinned `ARG BASE_IMAGE` in all platform Dockerfiles (`android`, `linux`, `web`) to immutable `@sha256` digests, achieving 100% container image pinning for OpenSSF Scorecard.
- Hardened branch protection rules with required last-push approval, linear history enforcement, and conversation resolution.

## [3.47.5] - 2026-09-23

### Added
- Official enterprise-grade Docker release for Flutter 3.47.5 (`flutter`, `flutter-android`, `flutter-web`, `flutter-linux`).
- SLSA Level 3 provenance attestations (`*.intoto.jsonl`) and Sigstore bundles attached to release assets.
- OpenSSF Scorecard supply-chain audit workflow with elevated security score.

