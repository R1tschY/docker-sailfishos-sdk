# syntax = docker/dockerfile:1-experimental

ARG SDK_TOOLING_IMAGE

FROM $SDK_TOOLING_IMAGE
LABEL Author="Richard Liebscher <r1tschy@posteo.de>"

ARG TARGET_VERSION

RUN --mount=source=target,target=/target set -ex &&\
 sdk-assistant -y create SailfishOS-$TARGET_VERSION-armv7hl /target/target-armv7hl.tar.gz &&\
 sudo rm -rf /srv/mer/targets/SailfishOS-$TARGET_VERSION-armv7hl/var/cache/zypp/* &&\
 sudo rm -rf /var/cache/zypp/*