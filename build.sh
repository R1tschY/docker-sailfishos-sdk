#!/usr/bin/env bash
set -euo pipefail

export SDK_VERSION="2.2.4"
export TARGET_VERSION="3.1.0.12"
export SDK_NAME="Sailfish_OS-$TARGET_VERSION-Platform_SDK_Chroot-i486.tar.bz2"
export SDK_URL="http://releases.sailfishos.org/sdk/installers/$SDK_VERSION/$SDK_NAME"

export BASE_IMAGE="r1tschy/sailfishos-platform-sdk-base"
export BUILD_IMAGE="r1tschy/sailfishos-platform-sdk"

if [ ! -f "$SDK_NAME" ] ; then
  echo "⬇️ Downloading base image"
  wget "$SDK_URL"
fi

# Fix uid/gid for userns feature (used by circleci)
if [ ! -f "Fixed-$SDK_NAME" ] ; then
  echo "🔧 Fixing base image user id"
  ./fix-baseimg-uid.py "$SDK_NAME" "Fixed-$SDK_NAME"
fi

echo "🚧 Building images"

docker import "Fixed-$SDK_NAME" "$BASE_IMAGE:$TARGET_VERSION"
docker tag "$BASE_IMAGE:$TARGET_VERSION" "$BASE_IMAGE:latest"

docker build \
    -f Dockerfile_tooling \
    --build-arg "SDK_VERSION=$SDK_VERSION" \
    --build-arg "TARGET_VERSION=$TARGET_VERSION" \
    -t "$BUILD_IMAGE-tooling:$TARGET_VERSION" \
    -t "$BUILD_IMAGE-tooling:latest" \
    .

docker build \
    -f Dockerfile_armv7hl \
    --build-arg "SDK_VERSION=$SDK_VERSION" \
    --build-arg "TARGET_VERSION=$TARGET_VERSION" \
    -t "$BUILD_IMAGE:$TARGET_VERSION-armv7hl" \
    -t "$BUILD_IMAGE:armv7hl" \
    .
docker build \
    -f Dockerfile_i486 \
    --build-arg "SDK_VERSION=$SDK_VERSION" \
    --build-arg "TARGET_VERSION=$TARGET_VERSION" \
    -t "$BUILD_IMAGE:$TARGET_VERSION-i486" \
    -t "$BUILD_IMAGE:i486" \
    .
docker build \
    -f Dockerfile_all \
    --build-arg "SDK_VERSION=$SDK_VERSION" \
    --build-arg "TARGET_VERSION=$TARGET_VERSION" \
    -t "$BUILD_IMAGE:$TARGET_VERSION" \
    -t "$BUILD_IMAGE:latest" \
    .
    
echo "⬆️ Pushing to docker hub"
docker push "$BASE_IMAGE:$TARGET_VERSION"
docker push "$BASE_IMAGE:latest"
docker push "$BUILD_IMAGE:$TARGET_VERSION"
docker push "$BUILD_IMAGE:$TARGET_VERSION-armv7hl"
docker push "$BUILD_IMAGE:$TARGET_VERSION-i486"
docker push "$BUILD_IMAGE:latest"
docker push "$BUILD_IMAGE:armv7hl"
docker push "$BUILD_IMAGE:i486"
