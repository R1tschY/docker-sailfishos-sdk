#!/usr/bin/env bash
set -euo pipefail

# dotenv
export $(egrep -v '^#' env | xargs -d '\n')

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
TESTS_DIR="${SCRIPT_DIR}/tests"
CONTAINER_TESTS_DIR=/home/nemo/tests

docker run \
    --rm \
    -v=${TESTS_DIR}:${CONTAINER_TESTS_DIR} \
    -w=${CONTAINER_TESTS_DIR} \
    $SDK_IMAGE:$TARGET_VERSION \
    ${CONTAINER_TESTS_DIR}/test_qt_build.sh \
    $TARGET_VERSION
