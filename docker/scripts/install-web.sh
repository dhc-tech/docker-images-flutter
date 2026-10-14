#!/usr/bin/env bash
# Web: real Google Chrome for `flutter test --platform chrome` and
# `flutter drive -d web-server`. Not apt `chromium` — on Ubuntu that is a
# snap wrapper which installs fine but cannot launch inside Docker.
set -euo pipefail

curl -fsSL https://dl.google.com/linux/linux_signing_key.pub \
    | gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
    > /etc/apt/sources.list.d/google-chrome.list
apt-get update
apt-get install -y --no-install-recommends google-chrome-stable
apt-get clean
rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

# Proves the binary actually launches, not just that apt exited 0.
google-chrome-stable --headless --disable-gpu --no-sandbox --version

flutter precache --web
