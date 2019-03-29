#!/usr/bin/env bash
set -euo pipefail

SDK_VERSION="2.0"
TARGET_VERSION="3.0.2.8"
SDK_NAME="Sailfish_OS-$TARGET_VERSION-Platform_SDK_Chroot-i486.tar.bz2"
SDK_URL="http://releases.sailfishos.org/sdk/installers/$SDK_VERSION/$SDK_NAME"

# Import it as a docker base image & build the full image
echo "Importing base image"
docker import "$SDK_URL" "coderus/sailfishos-platform-sdk-base:$TARGET_VERSION"
docker tag "coderus/sailfishos-platform-sdk-base:$TARGET_VERSION" "coderus/sailfishos-platform-sdk-base:latest"
echo "Importing base image: DONE"

echo "Pushing to docker hub"
docker push "coderus/sailfishos-platform-sdk-base:$TARGET_VERSION"
docker push "coderus/sailfishos-platform-sdk-base:latest"
echo "Pushing to docker hub: DONE"

echo "Building image"
docker build \
    --build-arg "SDK_VERSION=$SDK_VERSION" \
    --build-arg "TARGET_VERSION=$TARGET_VERSION" \
    -t "coderus/sailfishos-platform-sdk:$TARGET_VERSION" .
docker tag "coderus/sailfishos-platform-sdk:$TARGET_VERSION" "coderus/sailfishos-platform-sdk:latest"
echo "Building image: DONE"

echo "Pushing to docker hub"
docker push "coderus/sailfishos-platform-sdk:$TARGET_VERSION"
docker push "coderus/sailfishos-platform-sdk:latest"
echo "Pushing to docker hub: DONE"
