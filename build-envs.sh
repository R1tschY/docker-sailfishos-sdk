#!/bin/bash -e

/mnt/build-env.sh chroot.ks i486 $RELEASE
/mnt/build-env.sh tooling.ks i486 $RELEASE
/mnt/build-env.sh target.ks i486 $RELEASE
/mnt/build-env.sh target.ks armv7hl $RELEASE