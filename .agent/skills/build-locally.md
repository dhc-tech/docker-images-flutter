# Skill: Build Docker Images Locally

If the user asks you to test the image build locally, use the Makefile:

```bash
make build-android      # builds flutter-base:build first, then flutter-android:build
make test-web           # build + container-structure-test (base + web)
make test-all           # every image
make build-combo FLUTTER_REF=3.47.7
```

Images: `android`, `web`, `linux`, `combo`. Install logic lives in `docker/scripts/install-*.sh`.
