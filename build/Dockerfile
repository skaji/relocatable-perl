FROM ubuntu:18.04 AS static-libcrypt

RUN set -eux; \
  export DEBIAN_FRONTEND=noninteractive; \
  apt-get update; \
  apt-get install -y \
    ca-certificates \
    curl \
    gcc \
    libc6-dev \
    make \
    patch \
    perl \
    tar \
    wget \
    xz-utils \
    ;

ARG LIBXCRYPT_VERSION=4.4.36

RUN set -eux; \
  cd /tmp; \
  curl -fsSL -o libxcrypt-${LIBXCRYPT_VERSION}.tar.xz https://github.com/besser82/libxcrypt/releases/download/v${LIBXCRYPT_VERSION}/libxcrypt-${LIBXCRYPT_VERSION}.tar.xz; \
  tar xf libxcrypt-${LIBXCRYPT_VERSION}.tar.xz; \
  cd libxcrypt-${LIBXCRYPT_VERSION}; \
  ./configure --with-pic --disable-shared; \
  make; \
  mv .libs/libcrypt.a /; \
  :

# XXX We use ubuntu:18.04 because its gcc is configured with --enable-default-pie
FROM ubuntu:18.04 AS builder

RUN set -eux; \
  export DEBIAN_FRONTEND=noninteractive; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    ca-certificates \
    gcc \
    libc6-dev \
    make \
    patch \
    tar \
    wget \
    xz-utils \
    ;
RUN mkdir -p \
    /lib \
    /lib/$(uname -m)-linux-gnu \
    /lib64 \
    /usr/lib \
    /usr/lib/$(uname -m)-linux-gnu \
    /usr/lib64 \
    /usr/local/lib \
    /usr/local/lib64 \
    ;
RUN wget -q -O - https://raw.githubusercontent.com/skaji/relocatable-perl/main/perl-install | bash -s /perl
RUN wget -q -O /cpm https://raw.githubusercontent.com/skaji/cpm/main/cpm
RUN --mount=type=bind,target=src /perl/bin/perl /cpm install -g --cpmfile src/build/cpm.yml

RUN rm -f /usr/lib/$(uname -m)-linux-gnu/libcrypt.so
COPY --from=static-libcrypt /libcrypt.a  /tmp/libcrypt.a
RUN cp -f /tmp/libcrypt.a /usr/lib/$(uname -m)-linux-gnu/libcrypt.a

RUN --mount=type=bind,target=src /perl/bin/perl src/build/relocatable-perl-build --perl_version $(cat src/BUILD_VERSION) --prefix /opt/perl

RUN ln -sf /lib/$(uname -m)-linux-gnu/libcrypt.so.1 /usr/lib/$(uname -m)-linux-gnu/libcrypt.so

RUN /opt/perl/bin/perl /cpm install -g App::cpanminus App::ChangeShebang
RUN /opt/perl/bin/change-shebang -f /opt/perl/bin/*
RUN set -eux; \
  cd /tmp; \
  _ARCHNAME=$(if [ $(uname -m) = x86_64 ]; then echo amd64; else echo arm64; fi); \
  cp -r /opt/perl perl-linux-$_ARCHNAME; \
  tar cf perl-linux-$_ARCHNAME.tar perl-linux-$_ARCHNAME; \
  gzip -9 --stdout perl-linux-$_ARCHNAME.tar > /perl-linux-$_ARCHNAME.tar.gz; \
  xz   -9 --stdout perl-linux-$_ARCHNAME.tar > /perl-linux-$_ARCHNAME.tar.xz; \
  :

FROM scratch
COPY --from=builder /perl-linux-*.tar.gz /
COPY --from=builder /perl-linux-*.tar.xz /
