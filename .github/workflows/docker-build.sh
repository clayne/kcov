#!/bin/sh

set -eu

if [ "${1:-}" = "alpine" ]; then
    BUILD_OS="alpine"
    BUILD_BASE="3.20"
elif [ "${1:-}" = "debian" ]; then
    BUILD_OS="debian"
    BUILD_BASE="bookworm-slim"
else
    echo "Usage: docker-build.sh alpine"
    echo "Usage: docker-build.sh debian"
    exit 1
fi

set -x

echo "Building for: ${BUILD_OS}"

# https://github.com/docker/buildx#building
docker buildx build \
    --build-arg VCS_REF="$(git rev-parse HEAD)" \
    --build-arg BUILD_DATE="$(date -u +"%Y-%m-%dT%H:%M:%SZ")" \
    --build-arg BUILD_OS="${BUILD_OS}" \
    --build-arg BUILD_BASE="${BUILD_BASE}" \
    --tag ${IMAGE_TAG:-kcov} \
    --progress ${PROGRESS_MODE:-plain} \
    --platform ${PLATFORM:-linux/amd64} \
    --pull \
    --${ACTION:-load} \
    .
