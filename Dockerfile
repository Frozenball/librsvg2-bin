FROM ubuntu:18.04
MAINTAINER Teemu Kokkonen <teemu.kokkonen@planbrothers.io>
RUN apt-get update
RUN cd / && \
  mkdir temp && \
  mkdir target && \
  cd temp && \
  apt-get --download-only -y install librsvg2-bin && \
  cp /var/cache/apt/archives/librsvg2-bin* . && \
  dpkg-deb -x librsvg2*.deb tmpdir && \
  dpkg-deb --control librsvg2*.deb tmpdir/DEBIAN && \
  sed -i -E 's/libgtk(.+?), ?//g' tmpdir/DEBIAN/control && \
  sed -i -E 's/Description: /Description: REMOVED libgtk. /g' tmpdir/DEBIAN/control && \
  dpkg -b tmpdir /target
RUN (dpkg -I /target/librsvg2-bin*.deb | grep "Description: REMOVED libgtk") && \
  (dpkg -I /target/librsvg2-bin*.deb | grep "Depends" | grep -v "libgtk")
