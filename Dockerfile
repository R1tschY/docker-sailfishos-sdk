FROM r1tschy/sailfishos-platform-sdk-base
MAINTAINER Richard Liebscher <r1tschy@yahoo.de>

ARG SDK_VERSION
ARG TARGET_VERSION

COPY mer-tooling-chroot /home/nemo/mer-tooling-chroot

RUN set -ex;\
# Add nemo in sudoers without password
 chmod +w /etc/sudoers ;\
 echo "nemo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers ;\
 chmod -w /etc/sudoers

USER nemo
WORKDIR /home/nemo

RUN set -ex ;\
 sudo zypper ref ;\
 sudo zypper -qn in tar ;\
 curl -O https://releases.sailfishos.org/sdk/targets/Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Tooling-i486.tar.7z ;\
 7z x Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Tooling-i486.tar.7z ;\
 rm -f Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Tooling-i486.tar.7z ;\
 tar uf Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Tooling-i486.tar mer-tooling-chroot ;\
 sdk-assistant -y create SailfishOS-$TARGET_VERSION \
    Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Tooling-i486.tar ;\
 rm -f Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Tooling-i486.tar ;\
 sdk-assistant -y create SailfishOS-$TARGET_VERSION-armv7hl \
    https://releases.sailfishos.org/sdk/targets/Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Target-armv7hl.tar.7z ;\
 sdk-assistant -y create SailfishOS-$TARGET_VERSION-i486 \
    https://releases.sailfishos.org/sdk/targets/Sailfish_OS-$TARGET_VERSION-Sailfish_SDK_Target-i486.tar.7z ;\
 sudo rm -rf /var/cache/zypp/* ;\
 sudo rm -rf /srv/mer/targets/SailfishOS-$TARGET_VERSION-armv7hl/var/cache/zypp/* ;\
 sudo rm -rf /srv/mer/targets/SailfishOS-$TARGET_VERSION-i486/var/cache/zypp/* ;\
 \
 sudo find /srv -user 100000 -exec chown -h 1000 '{}' + ;\
 sudo find /srv -group 100000 -exec chgrp -h 1000 '{}' +
