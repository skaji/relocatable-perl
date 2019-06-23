FROM centos:centos6 as builder

RUN yum install -y \
    gcc \
    make \
    tar \
    curl \
    patch \
    xz
RUN mkdir -p \
    /lib \
    /lib/x86_64-linux-gnu \
    /lib64 \
    /usr/lib \
    /usr/lib/x86_64-linux-gnu \
    /usr/lib64 \
    /usr/local/lib \
    /usr/local/lib64
RUN curl -fsSL https://git.io/perl-install | bash -s /perl
COPY relocatable-perl-build BUILD_VERSION /
RUN /perl/bin/perl /relocatable-perl-build --perl_version $(cat /BUILD_VERSION) --prefix /opt/perl
RUN curl -fsSL https://git.io/cpm | /opt/perl/bin/perl - install -g App::cpanminus App::ChangeShebang
RUN /opt/perl/bin/change-shebang -f /opt/perl/bin/*
RUN cp -r /opt/perl /tmp/perl-x86_64-linux
RUN set -eux; \
  cd /tmp; \
  tar cf perl-x86_64-linux.tar perl-x86_64-linux; \
  gzip -9 --stdout perl-x86_64-linux.tar > /perl-x86_64-linux.tar.gz; \
  xz   -9 --stdout perl-x86_64-linux.tar > /perl-x86_64-linux.tar.xz; \
  true

FROM alpine
COPY --from=builder /perl-x86_64-linux.tar.gz /perl-x86_64-linux.tar.gz
COPY --from=builder /perl-x86_64-linux.tar.xz /perl-x86_64-linux.tar.xz
# ID=$(docker create skaji/relocatable-perl)
# docker cp $ID:/perl-x86_64-linux.tar.gz .
# docker cp $ID:/perl-x86_64-linux.tar.xz .
# docker rm $ID
