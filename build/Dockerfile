FROM centos:centos7 AS builder

# see https://gist.github.com/skaji/76203327b517cb44da88a4301de118d3
RUN sed -i 's/override_install_langs=en_US.UTF-8/override_install_langs=en_US.utf8/' /etc/yum.conf

# https://stackoverflow.com/questions/78692851/could-not-retrieve-mirrorlist-http-mirrorlist-centos-org-release-7arch-x86-6
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=https://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

RUN yum install -y \
    gcc \
    make \
    tar \
    curl \
    patch \
    xz
RUN mkdir -p \
    /lib \
    /lib/$(uname -m)-linux-gnu \
    /lib64 \
    /usr/lib \
    /usr/lib/$(uname -m)-linux-gnu \
    /usr/lib64 \
    /usr/local/lib \
    /usr/local/lib64
RUN curl -fsSL https://raw.githubusercontent.com/skaji/relocatable-perl/main/perl-install | bash -s /perl
RUN curl -fsSL --compressed -o /cpm https://raw.githubusercontent.com/skaji/cpm/main/cpm
RUN --mount=type=bind,target=src /perl/bin/perl /cpm install -g --cpmfile src/build/cpm.yml
RUN --mount=type=bind,target=src /perl/bin/perl src/build/relocatable-perl-build --perl_version $(cat src/BUILD_VERSION) --prefix /opt/perl
RUN /opt/perl/bin/perl /cpm install -g App::cpanminus App::ChangeShebang
RUN /opt/perl/bin/change-shebang -f /opt/perl/bin/*
RUN set -eux; \
  cd /tmp; \
  _ARCHNAME=$(if [[ $(uname -m) = x86_64 ]]; then echo amd64; else echo arm64; fi); \
  cp -r /opt/perl perl-linux-$_ARCHNAME; \
  tar cf perl-linux-$_ARCHNAME.tar perl-linux-$_ARCHNAME; \
  gzip -9 --stdout perl-linux-$_ARCHNAME.tar > /perl-linux-$_ARCHNAME.tar.gz; \
  xz   -9 --stdout perl-linux-$_ARCHNAME.tar > /perl-linux-$_ARCHNAME.tar.xz; \
  :

FROM scratch
COPY --from=builder /perl-linux-*.tar.gz /
COPY --from=builder /perl-linux-*.tar.xz /
