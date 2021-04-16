# syntax = docker/dockerfile:1-experimental

ARG SDK_TOOLING_IMAGE

FROM $SDK_TOOLING_IMAGE
LABEL Author="Richard Liebscher <r1tschy@posteo.de>"
LABEL org.opencontainers.image.source https://github.com/R1tschY/docker-sailfishos-sdk

ARG TARGET_VERSION
ARG TARGET_AARCH64_NAME

RUN --mount=source=target,target=/target set -ex &&\
 sdk-assistant -y create SailfishOS-$TARGET_VERSION-aarch64 /target/$TARGET_AARCH64_NAME &&\
 sudo rm -rf /srv/mer/targets/SailfishOS-$TARGET_VERSION-aarch64/var/cache/zypp/* &&\
 sudo rm -rf /var/cache/zypp/*