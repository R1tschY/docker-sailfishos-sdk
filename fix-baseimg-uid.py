#!/usr/bin/env python3

import argparse
import io
import tarfile
from tarfile import TarFile, TarInfo


def fix_tar(src: TarFile, dest: TarFile):
    # srcfile: TarInfo

    for srcfile in iter(src.next, None):
        file = src.extractfile(srcfile) if srcfile.isreg() else None

        # fix uid/gid
        if srcfile.uid == 100000:
            srcfile.uid = 1000
        if srcfile.gid == 100000:
            srcfile.gid = 1000

        # change uid/gid in /etc/passwd and /etc/group
        if srcfile.name in {"./etc/passwd", "./etc/group"}:
            content = file.read().replace(b"100000", b"1000")
            file = io.BytesIO(content)
            srcfile.size = len(content)

        dest.addfile(srcfile, file)


def main():
    argparser = argparse.ArgumentParser()
    argparser.add_argument("src")
    argparser.add_argument("dest")
    args = argparser.parse_args()

    with tarfile.open(args.dest, "w:bz2") as dest:
        with tarfile.open(args.src, "r:*") as src:
            fix_tar(src, dest)


if __name__ == '__main__':
    main()
