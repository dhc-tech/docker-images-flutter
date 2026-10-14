# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

