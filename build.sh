#!/usr/bin/env bash
set -euo pipefail

SDK_VERSION="2.0"
TARGET_VERSION="3.0.2.8"
SDK_NAME="Sailfish_OS-$TARGET_VERSION-Platform_SDK_Chroot-i486.tar.bz2"
SDK_URL="http://releases.sailfishos.org/sdk/installers/$SDK_VERSION/$SDK_NAME"

BASE_IMAGE="r1tschy/sailfishos-platform-sdk-base"
BUILD_IMAGE="r1tschy/sailfishos-platform-sdk"

echo "Downloading base image"
wget "$SDK_URL"
echo "Downloading base image: DONE"

# Fix uid/gid for userns feature (used by circleci)
echo "Fixing base image"
./fix-baseimg-uid.py "$SDK_NAME" "Fixed-$SDK_NAME"
echo "Fixing base image: DONE"

# Import it as a docker base image & build the full image
echo "Importing base image"
docker import "Fixed-$SDK_NAME" "$BASE_IMAGE:$TARGET_VERSION"
rm "$SDK_NAME" "Fixed-$SDK_NAME"
docker tag "$BASE_IMAGE:$TARGET_VERSION" "$BASE_IMAGE:latest"
echo "Importing base image: DONE"

echo "Pushing to docker hub"
docker push "$BASE_IMAGE:$TARGET_VERSION"
docker push "$BASE_IMAGE:latest"
echo "Pushing to docker hub: DONE"

echo "Building image"
docker build \
    --build-arg "SDK_VERSION=$SDK_VERSION" \
    --build-arg "TARGET_VERSION=$TARGET_VERSION" \
    -t "$BUILD_IMAGE:$TARGET_VERSION" .
docker tag "$BUILD_IMAGE:$TARGET_VERSION" "$BUILD_IMAGE:latest"
echo "Building image: DONE"

echo "Pushing to docker hub"
docker push "$BUILD_IMAGE:$TARGET_VERSION"
docker push "$BUILD_IMAGE:latest"
echo "Pushing to docker hub: DONE"
