#!/usr/bin/bash
if command -v docker 2>&1 >/dev/null; then
    BUILD_CMD="docker build"
elif command -v buildah 2>&1 >/dev/null; then
    BUILD_CMD="buildah bud"
elif command -v podman 2>&1 >/dev/null; then
    BUILD_CMD="podman build"
else
    echo "No docker, buildah, or podman found! Exiting."
    exit 1
fi

if [ -n "$KC_VERSION" ]; then
    $BUILD_CMD . -f Containerfile \
        -t kairos-conduit:$KC_VERSION \
        --build-arg KC_VERSION=$KC_VERSION
else
    $BUILD_CMD . -f Containerfile \
        -t kairos-conduit \
        --build-arg KC_VERSION=local
fi
