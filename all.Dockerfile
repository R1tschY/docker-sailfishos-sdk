# syntax = docker/dockerfile:1-experimental

ARG SDK_IMAGE

FROM $SDK_IMAGE:armv7hl
LABEL Author="Richard Liebscher <r1tschy@posteo.de>"

ARG TARGET_VERSION
ARG TARGET_I486_NAME

RUN --mount=source=target,target=/target set -ex &&\
 sdk-assistant -y create SailfishOS-$TARGET_VERSION-i486 /target/$TARGET_I486_NAME &&\
 sudo rm -rf /srv/mer/targets/SailfishOS-$TARGET_VERSION-i486/var/cache/zypp/* &&\
 sudo rm -rf /var/cache/zypp/*