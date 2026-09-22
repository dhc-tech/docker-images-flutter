# 🤖 Agent System Instructions

Welcome, AI Agent! You are working in the `docker-images-flutter` repository. This file serves as your primary context for autonomous operation.

## Repository Purpose
This repository provides automated, multi-platform Docker images for Flutter CI/CD pipelines. It is designed with extreme 50-year-veteran DevOps standards, prioritizing supply chain security, optimization, and complete automation.

## Core Directives
1. **Never Break Automation:** The entire release cycle (version bump -> auto-merge -> docker push -> tag) is 100% automated via GitHub Actions. Do not introduce manual steps.
2. **Security First:** All dependencies (Base images, GitHub Actions) MUST be pinned to SHA-256 hashes. Do not use floating tags like `@v2` or `:latest` in internal workflow configurations.
3. **Immutability:** Docker tags like `3.24.2` and `pinned` are immutable. Only `stable` and `latest` move.
4. **Test Before Push:** Always ensure `pre-commit` hooks pass locally. We use Hadolint for Dockerfiles and Yamllint for Workflows.

## Architecture
- `docker/`: Contains all Dockerfiles. The `Dockerfile` is the combo image. `base.Dockerfile` is the shared layer for the platform-specific images (`android`, `web`, `linux`).
- `FLUTTER_VERSION`: The single source of truth for the currently built Flutter version.
- `.github/workflows/`: Contains the CI/CD pipeline. `check-flutter-version.yml` updates the version, `auto-merge.yml` merges it, and `build-and-push.yml` builds and pushes the images.

Refer to the `.agent/` directory for specific rules, skills, and sub-agent instructions.
