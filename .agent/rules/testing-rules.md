# Testing Rules
1. **Container Structure Tests:** Every Docker image must have an associated `tests/<image>.yaml` file.
2. **Automated Validation:** All images must be validated using Google's `container-structure-test` binary before being published or merged.
3. **No Brittle Tests:** Only test the presence of necessary binaries (e.g., `flutter --version`, `java --version`) and expected ENV variables. Do not test exact outputs that might break on minor updates.
