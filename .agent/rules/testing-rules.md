# Testing Rules
1. **Container Structure Tests:** Every image has a `tests/<image>.yaml` (`base`, `android`, `web`, `linux`); the `combo` image runs all of them.
2. **Automated Validation:** All images must be validated using Google's `container-structure-test` binary before being published or merged.
3. **No Brittle Tests:** Only test the presence of necessary binaries (e.g., `flutter --version`, `java --version`) and expected ENV variables. Do not test exact outputs that might break on minor updates.
