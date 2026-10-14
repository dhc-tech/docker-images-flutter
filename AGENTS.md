# Instructions for AI coding assistants

Applies to Claude, Cursor and any other assistant. Human contributors: see
[CONTRIBUTING.md](CONTRIBUTING.md) and [docs/](docs/README.md).

## What this repo is

Automated Flutter CI Docker images (`flutter-android`,
`flutter-web`, `flutter-linux`, `flutter`) published to GHCR. The release cycle
(version bump, auto-merge, build, push, release) is fully automated.

## Structure

- `docker/Dockerfile` — one multi-stage file (`base`, `android`, `web`, `linux`, `combo`); toolchain logic is in `docker/scripts/install-*.sh`; `docker/docker-bake.hcl` publishes all images in one build. No Dockerfiles at the repo root. `base` is a build stage only and is never published.
- `tests/<image>.yaml` — container-structure-test; `combo` runs all of them.
- `FLUTTER_VERSION` — only changed by `check-flutter-version.yml`.
- `docs/` — documentation. Update the matching doc when behaviour changes.

Full layout: [docs/development.md](docs/development.md).

## Rules

1. **Do not break automation.** No manual steps in the release path.
2. **Pin everything.** Base images by SHA256 digest, Actions by commit SHA. No floating `@v2` or `:latest` in workflows.
3. **Tags:** `<version>` and `pinned` are immutable; `stable`, `latest`, `<major>`, `<major.minor>` move.
4. **Shell:** `SHELL ["/bin/bash", "-eo", "pipefail", "-c"]` in Dockerfiles; `set -euo pipefail` in scripts. For `yes | cmd` use `|| [ "${PIPESTATUS[1]}" -eq 0 ]`.
5. **YAML:** follow `.yamllint`; do not reflow long commands.
6. **Verify:** run `pre-commit run --all-files` and `make test-<image>` for any image you touched.
7. **Tests:** every image has `tests/<image>.yaml`; test that binaries run and env vars exist, not exact version output.
8. **Workflows:** token permissions `contents: read` at top level, write per job. Keep `.dockerignore` tight. Do not rename the required checks `build-check` and `build-check-platforms`. When changing CI, check `build-and-push.yml`, `pr-check.yml`, `.github/actions/build-and-test` and `auto-merge.yml`.
9. **Security review** for workflow or Dockerfile changes: no unpinned dependencies, minimal permissions, Scorecard rules respected.

## Git and PRs

- Keep the maintainer's configured git identity; never put personal email addresses in repo files.
- Commits and PR descriptions carry no AI attribution lines.
- `main` requires 1 approving human review; never try to bypass it. Merge lifecycle and labels: [docs/automation.md](docs/automation.md).
