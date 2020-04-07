#!/usr/bin/env bash
set -euo pipefail

export TARGET_VERSION=$1

echo "== Preparing workspace"
mkdir -p ${HOME}/workspace/armv7hl
mkdir -p ${HOME}/workspace/i486
cd ${HOME}/tests
cp * ${HOME}/workspace/armv7hl
cp * ${HOME}/workspace/i486

echo "== Building for $TARGET_VERSION armv7hl"
cd ${HOME}/workspace/armv7hl
sb2 -t SailfishOS-$TARGET_VERSION-armv7hl qmake
sb2 -t SailfishOS-$TARGET_VERSION-armv7hl make
sb2 -t SailfishOS-$TARGET_VERSION-armv7hl ./test

echo "== Building for $TARGET_VERSION i486"
cd ${HOME}/workspace/i486
sb2 -t SailfishOS-$TARGET_VERSION-i486 qmake
sb2 -t SailfishOS-$TARGET_VERSION-i486 make
sb2 -t SailfishOS-$TARGET_VERSION-i486 ./test
