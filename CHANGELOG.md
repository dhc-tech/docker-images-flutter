# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

