#!/bin/bash -e

function build_env {
    if [ ! -f "/mnt/target/${1%%.*}-$2.tar.gz" ]; then
        echo "Create ${1%%.*}-$2.tar.gz"
        mic create fs \
            -v \
            -d \
            --arch=$2 \
            --outdir=/mnt/target \
            --tokenmap=ARCH:$2,RELEASE:$3 \
            --pack-to=@NAME@-$2.tar.gz \
            "$1"
    fi
}

build_env chroot.ks i486 $RELEASE
build_env tooling.ks i486 $RELEASE
build_env target.ks i486 $RELEASE
build_env target.ks armv7hl $RELEASE