.PHONY: help install-hooks lint test-combo test-base build-combo build-base build-android build-web build-linux

# Default target
help:
	@echo "Available commands:"
	@echo "  make install-hooks    - Install pre-commit hooks"
	@echo "  make lint             - Run pre-commit checks on all files (Hadolint, Yamllint, etc.)"
	@echo "  make build-combo      - Build the main 'flutter' combo image"
	@echo "  make build-base       - Build the 'flutter-base' image (required for platforms)"
	@echo "  make build-android    - Build the 'flutter-android' image"
	@echo "  make build-web        - Build the 'flutter-web' image"
	@echo "  make build-linux      - Build the 'flutter-linux' image"
	@echo "  make test-combo       - Run container-structure-test on the combo image"
	@echo "  make test-base        - Run container-structure-test on the base image"

install-hooks:
	pre-commit install

lint:
	pre-commit run --all-files

build-combo:
	docker build -t flutter:build -f docker/Dockerfile .

build-base:
	docker build -t flutter-base:build -f docker/base.Dockerfile .

build-android: build-base
	docker build -t flutter-android:local -f docker/android.Dockerfile --build-arg BASE_IMAGE=flutter-base:build .

build-web: build-base
	docker build -t flutter-web:local -f docker/web.Dockerfile --build-arg BASE_IMAGE=flutter-base:build .

build-linux: build-base
	docker build -t flutter-linux:local -f docker/linux.Dockerfile --build-arg BASE_IMAGE=flutter-base:build .

test-combo: build-combo
	container-structure-test test --image flutter:build --config tests/flutter-combo.yaml

test-base: build-base
	container-structure-test test --image flutter-base:build --config tests/flutter-base.yaml
