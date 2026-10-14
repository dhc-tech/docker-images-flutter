# Contributing

1. Branch from `main` (`git checkout -b feature/your-change`).
2. Install the hooks once: `pip install pre-commit && pre-commit install`.
3. Make your change, then run `make test-<image>` for any image you touched
   (see [docs/development.md](docs/development.md)).
4. Open a PR and fill in the template.

Toolchain changes go in `docker/scripts/install-<platform>.sh` with a matching
check in `tests/<platform>.yaml`, never copied into a Dockerfile.

## Review and merge

`main` requires one approving review. PR labels and the auto-merge lifecycle are
described in [docs/automation.md](docs/automation.md). `FLUTTER_VERSION` is
bumped only by the bot.

Report security issues via [SECURITY.md](SECURITY.md), not a public issue.
