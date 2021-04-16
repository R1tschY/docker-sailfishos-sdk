#!/usr/bin/env bash
set -euxo pipefail

# env
export $(egrep -v '^#' env | xargs -d '\n')
export DOCKER_BUILDKIT=1

SDK_NAME="Sailfish_OS-$TARGET_VERSION-Platform_SDK_Chroot-i486.tar.bz2"
SDK_URL="http://releases.sailfishos.org/sdk/installers/$SDK_VERSION/$SDK_NAME"

TOOLING_NAME="Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Tooling-i486.tar.7z"
TOOLING_TAR_NAME="Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Tooling-i486.tar"
TOOLING_URL="https://releases.sailfishos.org/sdk/targets/$TOOLING_NAME"

TARGET_ARMV7HL_NAME="Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Target-armv7hl.tar.7z"
TARGET_ARMV7HL_URL="https://releases.sailfishos.org/sdk/targets/$TARGET_ARMV7HL_NAME"

TARGET_I486_NAME="Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Target-i486.tar.7z"
TARGET_I486_URL="https://releases.sailfishos.org/sdk/targets/$TARGET_I486_NAME"

TARGET_AARCH64_NAME="Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Target-aarch64.tar.7z"
TARGET_AARCH64_URL="https://releases.sailfishos.org/sdk/targets/$TARGET_AARCH64_NAME"

echo "== ⚙️ Download zips"
mkdir -p target

if [ ! -f "target/$SDK_NAME" ] ; then
    curl "$SDK_URL" -o "target/$SDK_NAME"
fi

if [ ! -f "target/$TOOLING_NAME" ] ; then
    curl "$TOOLING_URL" -o "target/$TOOLING_NAME"
fi

if [ ! -f "target/$TARGET_ARMV7HL_NAME" ] ; then
    curl "$TARGET_ARMV7HL_URL" -o "target/$TARGET_ARMV7HL_NAME"
fi

if [ ! -f "target/$TARGET_I486_NAME" ] ; then
    curl "$TARGET_I486_URL" -o "target/$TARGET_I486_NAME"
fi

if [ ! -f "target/$TARGET_AARCH64_NAME" ] ; then
    curl "$TARGET_AARCH64_URL" -o "target/$TARGET_AARCH64_NAME"
fi

echo "== ⚙️ Building images"

docker import "target/$SDK_NAME" "$SDK_BASE_IMAGE-import:$TARGET_VERSION"
docker build \
    -f base.Dockerfile \
    --build-arg "TARGET_VERSION=$TARGET_VERSION" \
    --build-arg "SDK_BASE_IMAGE=$SDK_BASE_IMAGE-import:$TARGET_VERSION" \
    -t "$SDK_BASE_IMAGE:$TARGET_VERSION" \
    -t "$SDK_BASE_IMAGE:latest" \
    .
docker rmi "$SDK_BASE_IMAGE-import:$TARGET_VERSION"

docker build \
    -f tooling.Dockerfile \
    --build-arg "TARGET_VERSION=$TARGET_VERSION" \
    --build-arg "SDK_BASE_IMAGE=$SDK_BASE_IMAGE" \
    --build-arg "TOOLING_NAME=$TOOLING_NAME" \
    -t "$SDK_TOOLING_IMAGE:$TARGET_VERSION" \
    -t "$SDK_TOOLING_IMAGE:latest" \
    .

docker build \
    -f armv7hl.Dockerfile \
    --build-arg "TARGET_VERSION=$TARGET_VERSION" \
    --build-arg "SDK_TOOLING_IMAGE=$SDK_TOOLING_IMAGE" \
    --build-arg "TARGET_ARMV7HL_NAME=$TARGET_ARMV7HL_NAME" \
    -t "$SDK_IMAGE:$TARGET_VERSION-armv7hl" \
    -t "$SDK_IMAGE:armv7hl" \
    .


docker build \
    -f i486.Dockerfile \
    --build-arg "TARGET_VERSION=$TARGET_VERSION" \
    --build-arg "SDK_TOOLING_IMAGE=$SDK_TOOLING_IMAGE" \
    --build-arg "TARGET_I486_NAME=$TARGET_I486_NAME" \
    -t "$SDK_IMAGE:$TARGET_VERSION-i486" \
    -t "$SDK_IMAGE:i486" \
    .
    
docker build \
    -f aarch64.Dockerfile \
    --build-arg "TARGET_VERSION=$TARGET_VERSION" \
    --build-arg "SDK_TOOLING_IMAGE=$SDK_TOOLING_IMAGE" \
    --build-arg "TARGET_AARCH64_NAME=$TARGET_AARCH64_NAME" \
    -t "$SDK_IMAGE:$TARGET_VERSION-aarch64" \
    -t "$SDK_IMAGE:aarch64" \
    .

docker build \
    -f all.Dockerfile \
    --build-arg "TARGET_VERSION=$TARGET_VERSION" \
    --build-arg "SDK_IMAGE=$SDK_IMAGE" \
    --build-arg "TARGET_I486_NAME=$TARGET_I486_NAME" \
    -t "$SDK_IMAGE:$TARGET_VERSION" \
    -t "$SDK_IMAGE:latest" \
    .