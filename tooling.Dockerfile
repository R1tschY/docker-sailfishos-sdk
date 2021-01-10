# syntax = docker/dockerfile:1-experimental

ARG SDK_BASE_IMAGE

FROM $SDK_BASE_IMAGE
LABEL Author="Richard Liebscher <r1tschy@posteo.de>"

ARG TARGET_VERSION

USER nemo
WORKDIR /home/nemo

RUN --mount=source=target,target=/target set -ex &&\
 sudo mkdir -m 0777 /host_targets &&\
 sdk-assistant -y create SailfishOS-$TARGET_VERSION /target/tooling-i486.tar.gz &&\
 sudo rm -rf /srv/mer/toolings/SailfishOS-$TARGET_VERSION/var/cache/zypp/*

