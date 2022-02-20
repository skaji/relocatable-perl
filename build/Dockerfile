FROM centos:centos6 as builder

RUN sed -i 's/^#baseurl=/baseurl=/g; s/^mirrorlist=/#mirrorlist=/g; s/http:\/\/mirror.centos.org/https:\/\/vault.centos.org/g' /etc/yum.repos.d/CentOS-Base.repo
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
RUN curl -fsSL --compressed -o /cpm https://git.io/cpm
COPY build/relocatable-perl-build build/cpm.yml BUILD_VERSION /
RUN /perl/bin/perl /cpm install -g
RUN /perl/bin/perl /relocatable-perl-build --perl_version $(cat /BUILD_VERSION) --prefix /opt/perl
RUN /opt/perl/bin/perl /cpm install -g App::cpanminus App::ChangeShebang
RUN /opt/perl/bin/change-shebang -f /opt/perl/bin/*
RUN cp -r /opt/perl /tmp/perl-x86_64-linux
RUN set -eux; \
  cd /tmp; \
  tar cf perl-x86_64-linux.tar perl-x86_64-linux; \
  gzip -9 --stdout perl-x86_64-linux.tar > /perl-x86_64-linux.tar.gz; \
  xz   -9 --stdout perl-x86_64-linux.tar > /perl-x86_64-linux.tar.xz; \
  true
