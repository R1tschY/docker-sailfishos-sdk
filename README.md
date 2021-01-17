*Dockerized [Sailfish OS Platform SDK](https://sailfishos.org/wiki/Platform_SDK)*

See also:
* [Docker Hub](https://hub.docker.com/r/r1tschy/sailfishos-platform-sdk)
* [GitHub Container Registry](https://github.com/users/R1tschY/packages/container/package/sailfishos-platform-sdk)
* [GitHub Action](https://github.com/R1tschY/sailfish-sdk-action)

## Tags

* `armv7hl` and `i486` target: `$SAILFISH_OS_RELEASE$-armv7hl`, `$SAILFISH_OS_RELEASE$`, `latest`
* Only `armv7hl` target: `$SAILFISH_OS_RELEASE$-armv7hl`, `armv7hl`
* Only `i486` target: `$SAILFISH_OS_RELEASE$-i486`, `i486`

## Summary

The goal of this repository is to package the
[Sailfish OS platform SDK](https://sailfishos.org/wiki/Platform_SDK) as a Docker image.

This image can be used to invoke all the command-line tools shipped in the SDK. It is not really
a replacement of Jolla's VM based SDK, as the image has no integration with Qt Creator, nor can
it deploy automatically to the emulator.

Instead this image can be used when automation are needed, for instance in CI. However, you can 
still use it in your daily developement workflow by invoking the tools and the deployment steps 
manually.

- `sailfishos-platform-sdk-base` contains the SDK, without any installed target or tooling
- `sailfishos-platform-sdk` contains the SDK and installed targets for `armv7hl` and `i486`
  - tags exist for images with only `armv7hl` or `i486` target

## Build

You must have Docker installed and started.

You must also be connected to the Internet in order to build the image.

```sh
./build.sh
```

## Usage

Build RPM in current directory:
```sh
docker run \
    -v $PWD:/home/mersdk/project \
    --workdir /home/mersdk/project \
    r1tschy/sailfishos-platform-sdk:3.4.0.24-armv7hl \
    mb2 -t SailfishOS-3.4.0.24-armv7hl build
```

## Credits

- [EvilJazz](https://github.com/evilJazz/sailfishos-buildengine) for the inspiration
- [SfietKonstantin](https://github.com/SfietKonstantin/docker-sailfishos-sdk) for the initial version of scripts
- [CODeRUS](https://github.com/CODeRUS/docker-sailfishos-sdk)

