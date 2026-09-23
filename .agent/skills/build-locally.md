# Skill: Build Docker Images Locally

If the user asks you to test the image build locally, use this skill:

```bash
# Build the base image first (required for platform images)
docker build -t flutter-base:build -f docker/base.Dockerfile .

# Build a specific platform
docker build -t flutter-android:local -f docker/android.Dockerfile --build-arg BASE_IMAGE=flutter-base:build .
```
