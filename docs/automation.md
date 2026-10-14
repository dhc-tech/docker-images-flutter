# Automation

## Who can open a PR that merges itself

- `check-flutter-version.yml`: the Flutter version bump.
- Dependabot: GitHub Actions versions (including `.github/actions/*`) and the
  Ubuntu base image digest, grouped into one PR per ecosystem.

A human PR is never auto-merged without one approving human review.

## PR lifecycle labels

| Label | Meaning |
|---|---|
| `needs-approval` | Applied when a PR is opened or updated |
| `waiting-for-green` | Approved, CI still running |
| `ci-failed` | A check failed; merge is blocked |
| `automerge` | Approved and all checks green; queued for squash merge |

Merging is done by `auto-merge.yml` with `BOT_PAT`, squash and
`--delete-branch`. Bot PRs are auto-approved with the same credentials and
wait for all checks before merging.

`labeler.yml` also labels PRs by changed paths (`docker`, `github-actions`,
`documentation`, `testing`, ...). `stale.yml` closes inactive issues and PRs
after 37 days.

## Required checks

`Hadolint`, `Yamllint`, `build-check`, and `build-check-platforms (android)`,
`(web)`, `(linux)`. Do not rename these jobs: renaming leaves the required
check unsatisfiable until branch protection is edited by hand.

The build jobs call `.github/actions/build-and-test`, which skips the slow
build when nothing the image is built from has changed, so unrelated PRs still
report the check quickly.
