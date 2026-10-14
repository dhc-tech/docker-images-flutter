# Publishes every image from one build graph, so the base stage and the
# android stage are built once and shared. Used by build-and-push.yml:
#   docker buildx bake -f docker/docker-bake.hcl --push
# Values come from the environment (set by the workflow).

variable "OWNER" {
  default = "dhc-tech"
}
variable "FLUTTER_REF" {
  default = "stable"
}
variable "MAJOR_MINOR" {
  default = ""
}
variable "MAJOR" {
  default = ""
}
variable "IS_LATEST" {
  default = false
}
variable "SOURCE" {
  default = "https://github.com/dhc-tech/docker-images-flutter"
}
variable "REVISION" {
  default = ""
}

# <version>, <major.minor>, <major>; plus latest/pinned/stable for the
# version currently in FLUTTER_VERSION.
function "tags" {
  params = [image]
  result = concat(
    [
      "ghcr.io/${OWNER}/${image}:${FLUTTER_REF}",
      "ghcr.io/${OWNER}/${image}:${MAJOR_MINOR}",
      "ghcr.io/${OWNER}/${image}:${MAJOR}",
    ],
    IS_LATEST ? [
      "ghcr.io/${OWNER}/${image}:latest",
      "ghcr.io/${OWNER}/${image}:pinned",
      "ghcr.io/${OWNER}/${image}:stable",
    ] : []
  )
}

function "labels" {
  params = [description]
  result = {
    "org.opencontainers.image.description" = description
    "org.opencontainers.image.licenses"    = "MIT"
    "org.opencontainers.image.source"      = SOURCE
    "org.opencontainers.image.revision"    = REVISION
    "org.opencontainers.image.version"     = FLUTTER_REF
  }
}

group "default" {
  targets = ["android", "web", "linux", "combo"]
}

target "_common" {
  context    = "."
  dockerfile = "docker/Dockerfile"
  args       = { FLUTTER_REF = FLUTTER_REF }
  attest     = ["type=provenance,mode=min", "type=sbom"]
}

target "android" {
  inherits = ["_common"]
  target   = "android"
  tags     = tags("flutter-android")
  labels   = labels("Flutter Docker image for CI/CD (android)")
}

target "web" {
  inherits = ["_common"]
  target   = "web"
  tags     = tags("flutter-web")
  labels   = labels("Flutter Docker image for CI/CD (web)")
}

target "linux" {
  inherits = ["_common"]
  target   = "linux"
  tags     = tags("flutter-linux")
  labels   = labels("Flutter Docker image for CI/CD (linux)")
}

target "combo" {
  inherits = ["_common"]
  target   = "combo"
  tags     = tags("flutter")
  labels   = labels("Flutter Docker image for CI/CD (Android + Web + Linux)")
}
