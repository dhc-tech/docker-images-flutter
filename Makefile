IMAGES := android web linux combo
FLUTTER_REF ?= $(shell cat FLUTTER_VERSION)

.PHONY: help install-hooks lint build-base build-all test-all clean $(addprefix build-,$(IMAGES)) $(addprefix test-,$(IMAGES)) test-base

help:
	@echo "make install-hooks   - install pre-commit hooks"
	@echo "make lint            - run pre-commit on all files"
	@echo "make build-base      - build flutter-base:build (FLUTTER_REF=$(FLUTTER_REF))"
	@echo "make build-<image>   - build flutter-<image>:build, image = $(IMAGES)"
	@echo "make test-<image>    - build + container-structure-test, image = base $(IMAGES)"
	@echo "make build-all       - build every image"
	@echo "make test-all        - test every image"
	@echo "make clean           - remove local images"

install-hooks:
	pre-commit install

lint:
	pre-commit run --all-files

build-base:
	docker build -t flutter-base:build -f docker/base.Dockerfile --build-arg FLUTTER_REF=$(FLUTTER_REF) .

$(addprefix build-,$(IMAGES)): build-%: build-base
	docker build -t flutter-$*:build -f docker/$*.Dockerfile --build-arg BASE_IMAGE=flutter-base:build .

test-base: build-base
	container-structure-test test --image flutter-base:build --config tests/base.yaml

# combo runs every platform's tests.
test-combo: build-combo
	container-structure-test test --image flutter-combo:build $(addprefix --config tests/,base.yaml android.yaml web.yaml linux.yaml)

$(addprefix test-,android web linux): test-%: build-%
	container-structure-test test --image flutter-$*:build --config tests/base.yaml --config tests/$*.yaml

build-all: $(addprefix build-,$(IMAGES))

test-all: test-base $(addprefix test-,$(IMAGES))

clean:
	docker rmi -f flutter-base:build $(addsuffix :build,$(addprefix flutter-,$(IMAGES))) 2>/dev/null || true
	docker image prune -f
