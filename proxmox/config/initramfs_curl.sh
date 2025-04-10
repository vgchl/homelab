#!/bin/sh -e

PREREQS=""
case $1 in
prereqs) echo "${PREREQS}"; exit 0;;
esac
. /usr/share/initramfs-tools/hook-functions

copy_exec /usr/bin/curl /bin

echo "nameserver 10.3.1.1\n" > ${DESTDIR}/etc/resolv.conf

mkdir -p $DESTDIR/usr/share
cp -ar /usr/share/ca-certificates $DESTDIR/usr/share/
cp -ar /etc/ssl $DESTDIR/etc/