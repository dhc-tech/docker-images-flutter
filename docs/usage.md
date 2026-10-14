# Usage

Choose an image from [images.md](images.md), then a tag.

```yaml
image: ghcr.io/dhc-tech/flutter-android:stable   # follows Flutter stable
image: ghcr.io/dhc-tech/flutter-android:3.47.7   # frozen, reproducible
```

## CI examples

**GitHub Actions**
```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/dhc-tech/flutter-android:stable
    steps:
      - uses: actions/checkout@v4
      - run: flutter build apk
```

**GitHub Actions with Gradle and pub caching**
```yaml
    steps:
      - uses: actions/checkout@v4
      - uses: actions/cache@v4
        with:
          path: |
            ~/.gradle/caches
            ~/.gradle/wrapper
            ~/.pub-cache
          key: ${{ runner.os }}-flutter-${{ hashFiles('**/pubspec.lock') }}
          restore-keys: ${{ runner.os }}-flutter-
      - run: flutter pub get
      - run: flutter build apk --release
```

**GitLab CI**
```yaml
build:
  image: ghcr.io/dhc-tech/flutter-android:stable
  script:
    - flutter build apk
```

**Bitbucket Pipelines**
```yaml
pipelines:
  default:
    - step:
        image: ghcr.io/dhc-tech/flutter-android:stable
        script:
          - flutter build apk
```

For web tests use `flutter-web` (`flutter test --platform chrome`).

## Which Flutter version is in an image?

```bash
docker run --rm ghcr.io/dhc-tech/flutter-android:stable cat /opt/flutter-ref.txt
docker run --rm ghcr.io/dhc-tech/flutter-android:stable flutter --version
```
