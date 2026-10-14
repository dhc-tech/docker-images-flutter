# Supply chain

- GitHub Actions are pinned to full commit SHAs; Dependabot keeps them current.
- The Ubuntu base image is pinned to a SHA256 digest in `docker/Dockerfile`,
  the only place it is referenced.
- Android command-line tools, the Firebase CLI and `container-structure-test`
  are pinned to exact versions.
- Published images carry provenance and SBOM attestations.
- Image metadata uses `docker/metadata-action` (OCI labels, SemVer tags).
- Workflow tokens default to `contents: read`; write access is granted per job.
- Hadolint, Yamllint, CodeQL and the OpenSSF Scorecard run in CI.

Report vulnerabilities as described in [SECURITY.md](../SECURITY.md).
