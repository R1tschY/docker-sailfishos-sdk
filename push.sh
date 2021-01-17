#!/usr/bin/env bash
set -euxo pipefail

# dotenv
export $(egrep -v '^#' env | xargs -d '\n')

echo "== ⬆️ Pushing to Docker Hub"
docker push "$SDK_BASE_IMAGE:$TARGET_VERSION"
docker push "$SDK_BASE_IMAGE:latest"
docker push "$SDK_IMAGE:$TARGET_VERSION"
docker push "$SDK_IMAGE:$TARGET_VERSION-armv7hl"
docker push "$SDK_IMAGE:$TARGET_VERSION-i486"
docker push "$SDK_IMAGE:latest"
docker push "$SDK_IMAGE:armv7hl"
docker push "$SDK_IMAGE:i486"

echo "== ⬆️ Pushing to GitHub Container Registry"
docker tag "$SDK_BASE_IMAGE:$TARGET_VERSION" "$GITHUB_SDK_BASE_IMAGE:$TARGET_VERSION"
docker tag "$SDK_BASE_IMAGE:latest" "$GITHUB_SDK_BASE_IMAGE:latest"
docker tag "$SDK_TOOLING_IMAGE:$TARGET_VERSION" "$GITHUB_SDK_TOOLING_IMAGE:$TARGET_VERSION"
docker tag "$SDK_TOOLING_IMAGE:latest" "$GITHUB_SDK_TOOLING_IMAGE:latest"
docker tag "$SDK_IMAGE:$TARGET_VERSION-i486" "$GITHUB_SDK_IMAGE:$TARGET_VERSION-i486"
docker tag "$SDK_IMAGE:i486" "$GITHUB_SDK_IMAGE:i486"
docker tag "$SDK_IMAGE:$TARGET_VERSION-armv7hl" "$GITHUB_SDK_IMAGE:$TARGET_VERSION-armv7hl"
docker tag "$SDK_IMAGE:armv7hl" "$GITHUB_SDK_IMAGE:armv7hl"
docker tag "$SDK_IMAGE:$TARGET_VERSION" "$GITHUB_SDK_IMAGE:$TARGET_VERSION"
docker tag "$SDK_IMAGE:$TARGET_VERSION" "$GITHUB_SDK_IMAGE:$latest"

docker push "$GITHUB_SDK_BASE_IMAGE:$TARGET_VERSION"
docker push "$GITHUB_SDK_BASE_IMAGE:latest"
docker push "$GITHUB_SDK_IMAGE:$TARGET_VERSION"
docker push "$GITHUB_SDK_IMAGE:$TARGET_VERSION-armv7hl"
docker push "$GITHUB_SDK_IMAGE:$TARGET_VERSION-i486"
docker push "$GITHUB_SDK_IMAGE:latest"
docker push "$GITHUB_SDK_IMAGE:armv7hl"
docker push "$GITHUB_SDK_IMAGE:i486"
