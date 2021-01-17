# syntax = docker/dockerfile:1-experimental

ARG SDK_TOOLING_IMAGE

FROM $SDK_TOOLING_IMAGE
LABEL Author="Richard Liebscher <r1tschy@posteo.de>"

ARG TARGET_VERSION
ARG TARGET_ARMV7HL_NAME

RUN --mount=source=target,target=/target set -ex &&\
 sdk-assistant -y create SailfishOS-$TARGET_VERSION-armv7hl /target/$TARGET_ARMV7HL_NAME &&\
 sudo rm -rf /srv/mer/targets/SailfishOS-$TARGET_VERSION-armv7hl/var/cache/zypp/* &&\
 sudo rm -rf /var/cache/zypp/*