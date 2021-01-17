# syntax = docker/dockerfile:1-experimental

ARG SDK_BASE_IMAGE

FROM $SDK_BASE_IMAGE
LABEL Author="Richard Liebscher <r1tschy@posteo.de>"
LABEL org.opencontainers.image.source https://github.com/R1tschY/docker-sailfishos-sdk

ARG TOOLING_NAME
ARG TARGET_VERSION

RUN --mount=source=target,target=/target set -ex &&\
 sdk-assistant -y create SailfishOS-$TARGET_VERSION /target/$TOOLING_NAME &&\
 sudo rm -rf /srv/mer/toolings/SailfishOS-$TARGET_VERSION/var/cache/zypp/* &&\
 sudo rm -rf /var/cache/zypp/*

