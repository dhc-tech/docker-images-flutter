# Releases

Every image tag traces back to the `FLUTTER_VERSION` file, which is only ever
changed by a bot.

## How a new Flutter version is detected

`check-flutter-version.yml` runs every 15 minutes. It asks the GitHub API which
commit `flutter/flutter`'s `stable` branch points at and which tag points at
that same commit. That tag is Flutter's own version number. If it differs from
`FLUTTER_VERSION`, the workflow opens a PR (label `automated-flutter-bump`)
updating the file.

The branch head can move before a version is tagged, so images are rebuilt
only when this PR merges, never on a poll of the branch.

## Release flow

1. `pr-check.yml` builds and tests the affected images, no push.
2. `auto-merge.yml` approves and merges the bot PR once checks pass (see
   [automation.md](automation.md)).
3. The merge to `main` triggers `build-and-push.yml`:
   - `version` resolves the version and tags.
   - `base` builds and pushes `flutter-base`.
   - `images` builds `flutter`, `flutter-android`, `flutter-web` and
     `flutter-linux` on top of it, in parallel, using `_build-image.yml`.
   - `release` creates the GitHub release.

A manual run (`workflow_dispatch`) accepts a `version` input to build a
specific Flutter version; it does not move `latest`, `pinned` or `stable`.

Other workflows: `image-health-check.yml` pulls the published `:stable` images
weekly and runs `flutter doctor -v`; `cleanup-ghcr-packages.yml` removes
untagged package versions older than 7 days every Sunday (tagged versions and
attestation/multi-arch child manifests are kept; manual runs default to dry-run).

## One-time repository setup

- Settings, Actions, General: **read and write permissions** and **allow
  GitHub Actions to create and approve pull requests**.
- Settings, General, Pull Requests: **allow auto-merge**.
- Branch protection on `main`: required checks `Hadolint`, `Yamllint`,
  `build-check` and `build-check-platforms (android|web|linux)`, one approving
  review, linear history, branches up to date.
- Secret `GH_PAT_WORKFLOW` (used as `BOT_PAT`) so merges made by the bot still
  trigger the release workflow.
