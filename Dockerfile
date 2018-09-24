FROM centos:centos6

RUN yum install -y gcc make tar curl patch bzip2 xz && \
  rm -rf /var/cache/yum/* && \
  yum clean all
RUN mkdir /tmp/build /artifact
RUN curl -fsSL https://github.com/skaji/relocatable-perl/releases/download/5.26.2.0/perl-x86_64-linux.tar.gz | tar xzf - --strip-components 1 -C /usr/local

RUN /usr/local/bin/perl -e 'mkdir $_ for grep !-d, @ARGV' /usr/local/lib64 /usr/local/lib /lib/x86_64-linux-gnu /lib64 /lib /usr/lib/x86_64-linux-gnu /usr/lib64 /usr/lib

ADD relocatable-perl-build /tmp/build/relocatable-perl-build
ADD BUILD_VERSION /tmp/build/BUILD_VERSION
RUN /usr/local/bin/perl /tmp/build/relocatable-perl-build --perl_version `cat /tmp/build/BUILD_VERSION` --prefix /opt/perl && \
  curl --compressed -fsSL https://git.io/cpm | /opt/perl/bin/perl - install -g App::cpanminus App::ChangeShebang && \
  rm -rf ~/.perl-cpm && \
  /opt/perl/bin/change-shebang -f /opt/perl/bin/* && \
  cp -r /opt/perl /tmp/perl-x86_64-linux && \
  cd /tmp && \
  tar cf perl-x86_64-linux.tar perl-x86_64-linux && \
  gzip -9 --stdout perl-x86_64-linux.tar > /artifact/perl-x86_64-linux.tar.gz && \
  xz   -9 --stdout perl-x86_64-linux.tar > /artifact/perl-x86_64-linux.tar.xz && \
  rm -rf /tmp/perl-x86_64-linux*

CMD ["sleep", "infinity"]
