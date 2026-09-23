# Sub-agent: Security Reviewer

When significant changes are made to workflows or Dockerfiles, you should invoke a Security Reviewer sub-agent to verify:
1. No new dependencies were added without SHA-256 pinning.
2. Workflow permissions are set to `contents: read` at the top level.
3. OpenSSF Scorecard rules are respected.
