# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Enterprise-grade AI Assistant contexts (`CLAUDE.md`, `AGENT.md`, `.cursorrules`).
- `container-structure-test` configuration for robust image verification.
- Pre-commit hooks (`hadolint`, `yamllint`).
- Comprehensive `.gitignore`, `CODE_OF_CONDUCT.md`, and `Makefile`.
- Centralized `docker/` directory for all Dockerfiles.

### Changed
- Refactored GitHub Actions to use strictly-pinned SHA-256 actions and dependencies.
- Updated Dockerfiles to use strict bash `pipefail` with proper SIGPIPE handling.
- Automated tagging now strictly uses OCI annotations via `docker/metadata-action`.

### Security
- Integrated OpenSSF Scorecard.
- Fixed root permissions across all internal CI/CD steps.
