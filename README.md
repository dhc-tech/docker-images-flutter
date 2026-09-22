# docker-images-flutter

A self-owned Flutter CI Docker image — built from scratch on plain
Ubuntu, no third-party Android/Flutter base image. Installs the Android
SDK command-line tools, Google Chrome, and the Linux desktop toolchain
directly from their official sources, then Flutter itself. Every version
this image ever ships is resolved **dynamically from
[github.com/flutter/flutter](https://github.com/flutter/flutter)
directly** — nothing here is a hand-picked or hardcoded Flutter version;
see [How versions are resolved](#how-versions-are-resolved) below.

Builds **Android, Web, and Linux desktop**. Does **not** and cannot build
iOS, macOS, or Windows — those need the real OS + toolchain (Xcode on
macOS, MSVC on Windows). That's an Apple/Microsoft platform requirement,
not something this image chooses to omit, and no Docker/Linux container
anywhere can do it.

## Tags

Published to `ghcr.io/dhc-tech/flutter` (public — pull it with no
registry credentials):

| Tag | What it is | Pick this if you want... | Rebuilds |
|---|---|---|---|
| `stable` | Flutter's official **stable** channel — always the same build as the current `<version>`/`pinned` tag below | The version most people should build against day to day | Automatically, the moment flutter/flutter's `stable` branch is tagged with a new version — see below |
| `<version>` (e.g. `3.47.2`) / `pinned` | The exact version number of the current stable release, immutable — never silently changes under you | Reproducible builds: the same tag always means the same Flutter build, unlike `stable` which moves forward over time | Automatically, the moment flutter/flutter's `stable` branch is tagged with a new version — see below |

In short: `stable` tracks whatever Flutter currently calls its stable
release (moves over time, ~quarterly); `<version>`/`pinned` freezes that
same release at one exact number (never moves). Only these two are
published here — Flutter's `beta` and `main` channels are intentionally
not built, to keep this image's surface to what's actually recommended
for day-to-day and reproducible builds. See
[docs.flutter.dev/release/upgrade](https://docs.flutter.dev/release/upgrade)
for Flutter's own explanation of its channels.

There is no `latest` tag — `stable` already means exactly that (Flutter's
own current stable release), so a separate `latest` alias would only
duplicate `stable` under a second name and invite confusion about which
one to use.

## How versions are resolved

Nothing in this repo hardcodes "the current Flutter version" as a
judgment call — every tag traces back to flutter/flutter's own repository
state:

`check-flutter-version.yml` runs every 5 minutes. It asks the GitHub API
which commit `flutter/flutter`'s `stable` branch currently points at,
then which tag (if any) points at that exact same commit — that tag name
*is* the real, official version number Flutter itself assigned to that
release, straight from `github.com/flutter/flutter`, not a third-party
manifest or a guess. If that differs from the version recorded in
`FLUTTER_VERSION`, it opens a PR bumping the file.

Both `stable` and `<version>`/`pinned` are then built and pushed
**together, from that same `FLUTTER_VERSION` value**, only when that PR
merges (see `build-and-push.yml`) — not on a separate poll of
flutter/flutter's `stable` branch. This is deliberate: the branch's HEAD
commit can move without a new version being tagged yet, and rebuilding
the image on every incidental commit there would mean frequent,
pointless rebuilds that don't correspond to an actual new release.

## Fully automated release flow

Two trusted bots can open a PR here — neither a human PR is ever
auto-merged, even if it happens to touch the same files:

- **`check-flutter-version.yml`** — detects flutter/flutter tagged a new
  stable release and opens a PR (labeled `automated-flutter-bump`)
  bumping `FLUTTER_VERSION`.
- **Dependabot** (`.github/dependabot.yml`) — opens its own PRs bumping
  GitHub Actions versions used in the workflows, and the `ubuntu:24.04`
  base image in the Dockerfile.

For either:

1. `pr-check.yml` builds the Dockerfile against the change (no push) to
   confirm it actually builds before anything merges — for a
   workflow-only Dependabot PR that can't affect the image, it skips the
   actual build and passes immediately instead.
2. `auto-merge.yml` — checks the PR's live author/label (not the
   `opened` event's payload, which isn't reliably populated with a label
   set at PR-creation time) — enables GitHub's native auto-merge, which
   completes the merge the moment `pr-check.yml` passes. Runs on
   `pull_request_target` specifically because Dependabot PRs always get a
   hard-restricted, read-only token on plain `pull_request` regardless of
   repository settings. No manual click required end to end.
3. Merging a `FLUTTER_VERSION` bump to `main` triggers
   `build-and-push.yml`'s `build` job, publishing the new
   `<version>`/`pinned`/`stable` tags together.

This entire chain was verified with a real test run, not just designed on
paper: a manually-lowered `FLUTTER_VERSION` was detected, a real PR was
opened, built, and auto-merged with zero manual steps once the one-time
repo settings below were in place.

### One-time repo setup this flow depends on

Already configured on this repo — noted here in case it's ever recreated:

- **Settings → Actions → General → Workflow permissions**: "Read and
  write permissions" + "Allow GitHub Actions to create and approve pull
  requests" — without this, `gh pr create` fails with *"GitHub Actions is
  not permitted to create or approve pull requests."*
- **Settings → General → Pull Requests → "Allow auto-merge"** — without
  this, `gh pr merge --auto` has nothing to enable.
- **Branch protection on `main`**: required status check `build-check`
  (from `pr-check.yml`), strict (branch must be up to date) — this is
  also what makes `git push origin main` fail for anything but a proper
  PR merge.
- A label named `automated-flutter-bump` must exist on the repo (`gh
  label create`) before `check-flutter-version.yml` can apply it.

## Usage

Pick a tag based on what you actually want — same 2 options as the table
above, spelled out as copy-pasteable `image:` lines:

**Most people, most of the time — track official Flutter stable:**
```yaml
image: ghcr.io/dhc-tech/flutter:stable
```
Always builds against whatever Flutter itself currently calls its stable
release. Moves forward automatically (~quarterly, within ~5 min of it
actually changing) — you never touch this line again.

**Reproducible builds — freeze one exact Flutter version forever:**
```yaml
image: ghcr.io/dhc-tech/flutter:3.47.2
```
Never changes. Use this if you need every build to use the *exact* same
Flutter SDK build over build, and are fine manually bumping the tag
yourself when you deliberately want to move to a newer Flutter version.
`pinned` (no version number) always points at the same commit as the
current `<version>` tag, if you'd rather not track the number at all.

### Checking exactly what Flutter version a tag contains

Every image — including the mutable `stable` tag, which doesn't carry a
version in its own name — carries an
`org.opencontainers.image.version` label recording the exact commit it
was built from, so you never have to guess:

```bash
docker inspect --format '{{ index .Config.Labels "org.opencontainers.image.version" }}' ghcr.io/dhc-tech/flutter:stable
```

or without pulling the image, via the GHCR API:

```bash
docker manifest inspect ghcr.io/dhc-tech/flutter:stable
```

## CI usage examples

Copy-pasteable snippets for running this image as the build container in a
few common CI systems — swap the tag for whichever one you picked in
[Usage](#usage) above.

**GitHub Actions:**
```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/dhc-tech/flutter:stable
    steps:
      - uses: actions/checkout@v7
      - run: flutter build apk
```

**GitLab CI:**
```yaml
build:
  image: ghcr.io/dhc-tech/flutter:stable
  script:
    - flutter build apk
```

## Repo layout

- `Dockerfile` — the image itself. `FLUTTER_REF` build arg selects the
  git ref (a version tag or a channel branch name) to install.
- `FLUTTER_VERSION` — single source of truth for both the `pinned` and
  `stable` tags' version; only ever changed by `check-flutter-version.yml`'s
  bot PRs.
- `.github/dependabot.yml` — keeps Actions versions and the base image
  current.
- `.github/workflows/` — the workflows described above.
