#!/usr/bin/env bash
set -euxo pipefail

# env
export $(egrep -v '^#' env | xargs -d '\n')
export DOCKER_BUILDKIT=1

echo "== ⚙️ Building base images"
if [ ! -d target ]
then
    mkdir -p target
    cp *.ks target/
    docker run --rm \
        --privileged \
        -v $PWD:/mnt \
        -w /mnt \
        -e RELEASE=$TARGET_VERSION \
        coderus/sailfishos-baseimage \
        /mnt/build-envs.sh 
fi


echo "== ⚙️ Building images"

#docker import "target/chroot-i486.tar.gz" "$SDK_BASE_IMAGE:$TARGET_VERSION"
docker tag "$SDK_BASE_IMAGE:$TARGET_VERSION" "$SDK_BASE_IMAGE:latest"

docker build \
    -f tooling.Dockerfile \
    --build-arg "TARGET_VERSION=$TARGET_VERSION" \
    --build-arg "SDK_BASE_IMAGE=$SDK_BASE_IMAGE" \
    -t "$SDK_TOOLING_IMAGE:$TARGET_VERSION" \
    -t "$SDK_TOOLING_IMAGE:latest" \
    .

docker build \
    -f i486.Dockerfile \
    --build-arg "TARGET_VERSION=$TARGET_VERSION" \
    --build-arg "SDK_TOOLING_IMAGE=$SDK_TOOLING_IMAGE" \
    -t "$SDK_IMAGE:$TARGET_VERSION-i486" \
    -t "$SDK_IMAGE:i486" \
    .

docker build \
    -f armv7hl.Dockerfile \
    --build-arg "TARGET_VERSION=$TARGET_VERSION" \
    --build-arg "SDK_TOOLING_IMAGE=$SDK_TOOLING_IMAGE" \
    -t "$SDK_IMAGE:$TARGET_VERSION-armv7hl" \
    -t "$SDK_IMAGE:armv7hl" \
    .

docker build \
    -f all.Dockerfile \
    --build-arg "TARGET_VERSION=$TARGET_VERSION" \
    --build-arg "SDK_IMAGE=$SDK_IMAGE" \
    -t "$SDK_IMAGE:$TARGET_VERSION" \
    -t "$SDK_IMAGE:latest" \
    .

echo "== ⬆️ Pushing to docker hub"
docker push "$SDK_BASE_IMAGE:$TARGET_VERSION"
docker push "$SDK_BASE_IMAGE:latest"
docker push "$SDK_IMAGE:$TARGET_VERSION"
docker push "$SDK_IMAGE:$TARGET_VERSION-armv7hl"
docker push "$SDK_IMAGE:$TARGET_VERSION-i486"
docker push "$SDK_IMAGE:latest"
docker push "$SDK_IMAGE:armv7hl"
docker push "$SDK_IMAGE:i486"
