# syntax = docker/dockerfile:1-experimental

ARG SDK_IMAGE

FROM $SDK_IMAGE:armv7hl
LABEL Author="Richard Liebscher <r1tschy@posteo.de>"

ARG TARGET_VERSION

RUN --mount=source=target,target=/target set -ex &&\
 sdk-assistant -y create SailfishOS-$TARGET_VERSION-i486 /target/target-i486.tar.gz &&\
 sudo rm -rf /srv/mer/targets/SailfishOS-$TARGET_VERSION-i486/var/cache/zypp/* &&\
 sudo rm -rf /var/cache/zypp/*