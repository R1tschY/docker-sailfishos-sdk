#!/usr/bin/env bash
set -euxo pipefail

# dotenv
export $(egrep -v '^#' env | xargs -d '\n')

echo "== ⬆️ Pushing to docker hub"
docker push "$SDK_BASE_IMAGE:$TARGET_VERSION"
docker push "$SDK_BASE_IMAGE:latest"
docker push "$SDK_IMAGE:$TARGET_VERSION"
docker push "$SDK_IMAGE:$TARGET_VERSION-armv7hl"
docker push "$SDK_IMAGE:$TARGET_VERSION-i486"
docker push "$SDK_IMAGE:latest"
docker push "$SDK_IMAGE:armv7hl"
docker push "$SDK_IMAGE:i486"
