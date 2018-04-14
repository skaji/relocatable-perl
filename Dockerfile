FROM centos:centos6
MAINTAINER Shoichi Kaji <skaji@cpan.org>

RUN yum install -y gcc make tar curl patch bzip2 xz
RUN yum clean all
RUN mkdir /tmp/build /artifact
RUN curl -sSL https://github.com/skaji/relocatable-perl/releases/download/5.26.2.0/perl-x86_64-linux.tar.gz | tar xzf - --strip-components 1 -C /usr/local

RUN /usr/local/bin/perl -e 'mkdir $_ for grep !-d, @ARGV' /usr/local/lib64 /usr/local/lib /lib/x86_64-linux-gnu /lib64 /lib /usr/lib/x86_64-linux-gnu /usr/lib64 /usr/lib

ADD relocatable-perl-build /tmp/build/relocatable-perl-build
ADD BUILD_VERSION /tmp/build/BUILD_VERSION
RUN /usr/local/bin/perl /tmp/build/relocatable-perl-build --perl_version `cat /tmp/build/BUILD_VERSION` --prefix /opt/perl

RUN curl --compressed -sSL https://git.io/cpm | /opt/perl/bin/perl - install -g App::cpanminus App::ChangeShebang
RUN /opt/perl/bin/change-shebang -f /opt/perl/bin/*

RUN cp -r /opt/perl /tmp/perl-`/opt/perl/bin/perl -MConfig -e 'print $Config{archname}'`
RUN cd /tmp && tar czf /artifact/perl-`/opt/perl/bin/perl -MConfig -e 'print $Config{archname}'`.tar.gz  perl-`/opt/perl/bin/perl -MConfig -e 'print $Config{archname}'`
RUN cd /tmp && tar cJf /artifact/perl-`/opt/perl/bin/perl -MConfig -e 'print $Config{archname}'`.tar.xz  perl-`/opt/perl/bin/perl -MConfig -e 'print $Config{archname}'`

RUN rm -rf /tmp/perl-`/opt/perl/bin/perl -MConfig -e 'print $Config{archname}'`
RUN rm -rf /tmp/build

CMD ["sleep", "infinity"]
