# Development

## Layout

```
docker/
  Dockerfile           multi-stage, one stage per image:
                         base     Ubuntu + git + Firebase CLI + Flutter (not published)
                         android  base + install-android.sh   -> flutter-android
                         web      base + install-web.sh       -> flutter-web
                         linux    base + install-linux.sh     -> flutter-linux
                         combo    android + web + linux       -> flutter
  docker-bake.hcl      builds and tags all four images in one go (used by build-and-push.yml)
  scripts/             one install script per toolchain
tests/                 container-structure-test configs: base, android, web, linux
docs/                  documentation
FLUTTER_VERSION        version for every image tag (bot-managed)
Makefile               local build and test
.github/
  actions/build-and-test/   build + test one image (used by pr-check.yml)
  workflows/                see releases.md and automation.md
```

All Dockerfiles live in `docker/`, none at the repo root.

## Build and test locally

Needs Docker and [container-structure-test](https://github.com/GoogleContainerTools/container-structure-test).

```bash
make build-web                       # builds the web stage as flutter-web:build
make test-android                    # build + base and android tests
make test-all
make build-combo FLUTTER_REF=3.47.7  # override the Flutter version
make help
```

Images: `android`, `web`, `linux`, `combo`. `combo` runs every image's tests.

## Changing a toolchain

1. Edit `docker/scripts/install-<platform>.sh`. Both the platform image and
   `combo` pick it up; never copy install logic into a Dockerfile.
2. Add or update the check in `tests/<platform>.yaml`. Test that binaries run
   and env vars are set; avoid exact version output that breaks on minor bumps.
3. Run `make test-<platform>` and `make test-combo`.

If you add an image, add a stage to `docker/Dockerfile`, a target to
`docker/docker-bake.hcl`, and entries in the Makefile `IMAGES`, `pr-check.yml`,
the cleanup workflow and the health check.

## Lint

```bash
pip install pre-commit && pre-commit install
pre-commit run --all-files     # Hadolint, Yamllint, whitespace
```

## Conventions

- Dockerfiles use `SHELL ["/bin/bash", "-eo", "pipefail", "-c"]`; scripts use
  `set -euo pipefail`.
- For `yes | cmd`, tolerate SIGPIPE with `|| [ "${PIPESTATUS[1]}" -eq 0 ]`.
- YAML follows `.yamllint` (line length disabled).
- Keep `.dockerignore` tight so the build context stays small.
