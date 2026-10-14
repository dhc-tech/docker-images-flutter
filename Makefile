IMAGES := android web linux combo
FLUTTER_REF ?= $(shell cat FLUTTER_VERSION)

.PHONY: help install-hooks lint build-all test-all clean $(addprefix build-,$(IMAGES)) $(addprefix test-,$(IMAGES))

help:
	@echo "make install-hooks   - install pre-commit hooks"
	@echo "make lint            - run pre-commit on all files"
	@echo "make build-<image>   - build flutter-<image>:build, image = $(IMAGES)"
	@echo "make test-<image>    - build + container-structure-test, image = $(IMAGES)"
	@echo "make build-all       - build every image"
	@echo "make test-all        - test every image"
	@echo "make clean           - remove local images"
	@echo "FLUTTER_REF=$(FLUTTER_REF) (override: make build-web FLUTTER_REF=3.47.2)"

install-hooks:
	pre-commit install

lint:
	pre-commit run --all-files

$(addprefix build-,$(IMAGES)): build-%:
	docker build -f docker/Dockerfile --target $* -t flutter-$*:build --build-arg FLUTTER_REF=$(FLUTTER_REF) .

# combo runs every platform's tests.
test-combo: build-combo
	container-structure-test test --image flutter-combo:build $(addprefix --config tests/,base.yaml android.yaml web.yaml linux.yaml)

$(addprefix test-,android web linux): test-%: build-%
	container-structure-test test --image flutter-$*:build --config tests/base.yaml --config tests/$*.yaml

build-all: $(addprefix build-,$(IMAGES))

test-all: $(addprefix test-,$(IMAGES))

clean:
	docker rmi -f $(addsuffix :build,$(addprefix flutter-,$(IMAGES))) 2>/dev/null || true
	docker image prune -f
