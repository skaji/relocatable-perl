FROM centos:6.4
MAINTAINER Shoichi Kaji <skaji@cpan.org>

RUN yum install -y gcc make
RUN mkdir /tmp/build /tmp/artifact

RUN cd /tmp/build && wget -q http://www.cpan.org/src/5.0/perl-5.20.0.tar.gz
RUN cd /tmp/build && tar xzf perl-5.20.0.tar.gz
RUN cd /tmp/build/perl-5.20.0 && \
    ./Configure -Dprefix=/opt/perl -Duserelocatableinc -des &>> /tmp/artifact/perl-build.log && \
    make &>> /tmp/artifact/perl-build.log && \
    make test &>> /tmp/artifact/perl-build.log && \
    make install &>> /tmp/artifact/perl-build.log

ADD misc/change-shebang.pl /opt/perl/bin/change-shebang.pl
ADD misc/config_heavy.patch.pl /tmp/build/config_heavy.patch.pl
RUN /opt/perl/bin/perl /tmp/build/config_heavy.patch.pl /opt/perl/lib/5.20.0/x86_64-linux/Config_heavy.pl
RUN /opt/perl/bin/change-shebang.pl /opt/perl/bin/*
RUN cd /opt && tar czf /tmp/artifact/perl.tar.gz perl

CMD ["sleep", "infinity"]
