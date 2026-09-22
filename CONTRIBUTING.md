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
5. Wait for the automated CI quality gates to pass.
