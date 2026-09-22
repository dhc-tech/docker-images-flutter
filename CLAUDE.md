# Claude / AI Assistant Guidelines

If you are Claude, Cursor, or another AI coding assistant, follow these rules when editing this codebase:

## Coding Standards
1. **Strict Shell:** Always use `SHELL ["/bin/bash", "-eo", "pipefail", "-c"]` in Dockerfiles when using pipes to satisfy Hadolint `DL4006`.
2. **Pipes and SIGPIPE:** If using `yes | ...`, gracefully handle SIGPIPE (exit code 141) by inspecting `PIPESTATUS`, e.g.: `yes | cmd || [ "${PIPESTATUS[1]}" -eq 0 ]`.
3. **No Root Files:** Do not place new Dockerfiles at the root. All Dockerfiles belong in `docker/`.
4. **Yaml Format:** Follow `.yamllint` rules. Do not arbitrarily reformat long commands to 80 chars, as `line-length` is disabled.

## Context
When asked to modify the CI/CD pipeline, always check:
- `build-and-push.yml` for publishing.
- `pr-check.yml` for local branch testing.
- `.dockerignore` to ensure the context remains small.
