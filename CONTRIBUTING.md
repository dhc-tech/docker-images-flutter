# Contributing Guidelines

Thank you for your interest in contributing to the Flutter Docker Images repository!

## Local Development & Testing

To ensure the highest quality of code and prevent CI failures, we enforce strict linting rules on all Dockerfiles and YAML workflows. 

**Before you commit or push any changes, you must run our local tests.** We use `pre-commit` to automate this.

### Setting up Pre-commit Hooks

1. Install `pre-commit` on your machine (requires Python):
   ```bash
   pip install pre-commit
   # Or using Homebrew on macOS: brew install pre-commit
   ```

2. Install the git hooks in this repository:
   ```bash
   pre-commit install
   ```

Now, every time you run `git commit`, `pre-commit` will automatically run:
- **Hadolint**: To ensure Dockerfile best practices are followed.
- **Yamllint**: To ensure GitHub Actions workflows are formatted correctly.
- **Standard checks**: Removes trailing whitespaces and fixes end-of-files.

If any check fails, the commit will be blocked. You must fix the errors and try committing again.

### Manual Testing

You can also run the checks manually on all files without committing:
```bash
pre-commit run --all-files
```

## Pull Request Process

1. Create a feature branch (`git checkout -b feature/your-feature-name`).
2. Make your changes and ensure `pre-commit` checks pass.
3. Push to your branch and open a Pull Request.
4. Fill out the provided Pull Request template completely.
5. Wait for the automated CI quality gates to pass (Docker tests, CodeQL, Hadolint, Yamllint).

### Approvals & Auto-merge Lifecycle
 
 - **Strict Branch Protection**: All PRs targeting `main` strictly require at least **1 approving review** from a maintainer/collaborator before they can be merged.
 - **`needs-approval` Label**: When any PR is opened or updated, GitHub Actions automatically applies the `needs-approval` label.
 - **Automated Approval & Check Lifecycle**:
   1. When an authorized maintainer submits an approving review, `needs-approval` is automatically removed.
   2. While CI checks are still in progress, the `waiting-for-green` label is applied.
   3. If any CI check fails, `waiting-for-green` is removed and `ci-failed` is applied, blocking merge.
   4. Once all CI checks are completely green and review is approved, `waiting-for-green` and `ci-failed` are removed, `automerge` is applied, and the PR is automatically queued for squash merge by `github-actions[bot]`.
 - **Bot PRs**: Bot PRs (Dependabot, automated Flutter bumps) are auto-approved via dedicated credentials and wait for all CI checks to pass green before merging.
