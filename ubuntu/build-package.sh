#!/usr/bin/env bash

SRCDIR="$PWD/ubuntu/pkgsrc"
PKGDIR="$PWD/ubuntu/dist"

export VERSION="$(git log -1 --format=%ct)-$(git rev-parse --short HEAD)"
export DESTDIR="$PKGDIR/rsyslog_$VERSION"

sudo rm -rf $PKGDIR && \
    mkdir -p $DESTDIR && \
    cp -R $SRCDIR/* $DESTDIR && \
    cat "$SRCDIR/DEBIAN/control" | envsubst '$VERSION' > "$DESTDIR/DEBIAN/control" && \
    ./autogen.sh --enable-openssl --enable-imdtls \
		 --enable-omdtls --enable-libzstd \
		 --enable-liblogging-stdlog && \
    make && make install && \
    sudo chown -R root:root $DESTDIR && \
    dpkg-deb --build $DESTDIR
