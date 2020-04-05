#!/bin/bash -e

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