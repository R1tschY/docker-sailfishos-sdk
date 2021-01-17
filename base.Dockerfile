# syntax = docker/dockerfile:1-experimental

ARG SDK_BASE_IMAGE

FROM $SDK_BASE_IMAGE
LABEL Author="Richard Liebscher <r1tschy@posteo.de>"

ARG TARGET_VERSION

RUN set -ex &&\
 useradd -u 1001 -m mersdk &&\
 echo "mersdk ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/mersdk &&\
 chmod 0440 /etc/sudoers.d/mersdk &&\
 ssu dr adaptation0  # Repo needs auth

USER mersdk
WORKDIR /home/mersdk

COPY mer-tooling-chroot /home/mersdk/mer-tooling-chroot

CMD ["bash"]
