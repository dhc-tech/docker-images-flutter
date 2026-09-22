# Flutter CI image — Web only. Built FROM base.Dockerfile (Ubuntu +
# Firebase CLI + Flutter SDK) plus real Chrome — no Android SDK, no
# Linux desktop toolchain.
#
# BASE_IMAGE: the locally-built base.Dockerfile image tag — see
# build-and-push.yml, which builds base.Dockerfile first and passes its
# tag in here.
ARG BASE_IMAGE
FROM ${BASE_IMAGE}

# Real Chrome for `flutter test --platform chrome` /
# `flutter drive -d web-server` — https://docs.flutter.dev/testing/integration-tests.
#
# Deliberately NOT `apt-get install chromium` — on Ubuntu 19.10+ (this
# image included) that package is a transitional wrapper that shells out
# to snap at runtime, and snap does not work inside a Docker container:
# the apt install itself succeeds (so this would silently pass a Docker
# build), but the resulting `chromium` binary fails the moment anything
# actually launches it. Installing Google's own .deb repo instead gives a
# real, self-contained binary — no snap involved. See e.g.
# https://www.stablebuild.com/blog/install-chromium-in-an-ubuntu-docker-container.
RUN curl -fsSL https://dl.google.com/linux/linux_signing_key.pub \
        | gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
        > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends google-chrome-stable \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* \
    # Build-time smoke test — proves the binary genuinely runs (not just
    # that `apt install` exited 0), so a regression like the snap-wrapper
    # issue above fails the Docker build immediately instead of surfacing
    # only when a consuming project's own `flutter test --platform
    # chrome` run breaks.
    && google-chrome-stable --headless --disable-gpu --no-sandbox --version

# https://docs.flutter.dev/testing/integration-tests — Flutter looks for
# this exact env var to drive headless Chrome.
ENV CHROME_EXECUTABLE=/usr/bin/google-chrome-stable

RUN flutter doctor -v \
    && flutter precache --web
