#!/usr/bin/env bash
set -euxo pipefail

export TARGET_VERSION="3.3.0.14"

export BASE_IMAGE="r1tschy/sailfishos-platform-sdk-base"
export BUILD_IMAGE="r1tschy/sailfishos-platform-sdk"

mkdir -p target

echo "⚙️ Building base images"
cp *.ks target/
docker run --rm \
    --privileged \
    --network=host \
    -v $(pwd):/mnt \
    -w /mnt \
    -e RELEASE=$TARGET_VERSION \
    coderus/sailfishos-baseimage \
    /mnt/build-envs.sh 


# Fix uid/gid for userns feature (used by circleci)
# if [ ! -f "target/fixed-baseimage.tar.bz2" ] ; then
#   echo "🔧 Fixing base image user id"
#   ./fix-baseimg-uid.py "target/baseimage.tar.bz2" "target/fixed-baseimage.tar.bz2"
# fi

echo "⚙️ Building images"

docker import "target/chroot-i486.tar.gz" "$BASE_IMAGE:$TARGET_VERSION"
docker tag "$BASE_IMAGE:$TARGET_VERSION" "$BASE_IMAGE:latest"

docker build \
    -f Dockerfile_tooling \
    --build-arg "TARGET_VERSION=$TARGET_VERSION" \
    -t "$BUILD_IMAGE-tooling:$TARGET_VERSION" \
    -t "$BUILD_IMAGE-tooling:latest" \
    .

docker build \
    -f Dockerfile_i486 \
    --build-arg "TARGET_VERSION=$TARGET_VERSION" \
    -t "$BUILD_IMAGE:$TARGET_VERSION-i486" \
    -t "$BUILD_IMAGE:i486" \
    .

docker build \
    -f Dockerfile_armv7hl \
    --build-arg "TARGET_VERSION=$TARGET_VERSION" \
    -t "$BUILD_IMAGE:$TARGET_VERSION-armv7hl" \
    -t "$BUILD_IMAGE:armv7hl" \
    .

docker build \
    -f Dockerfile_all \
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
