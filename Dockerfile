FROM centos:6.4
MAINTAINER Shoichi Kaji <skaji@cpan.org>

RUN yum install -y gcc make
RUN mkdir /tmp/build /artifact

RUN cd /tmp/build && wget -q http://www.cpan.org/src/5.0/perl-5.20.0.tar.gz
RUN cd /tmp/build && tar xzf perl-5.20.0.tar.gz
RUN cd /tmp/build/perl-5.20.0 && ./Configure -Dprefix=/opt/perl -Duserelocatableinc -des &>> /artifact/perl-build.log
RUN cd /tmp/build/perl-5.20.0 && make &>> /artifact/perl-build.log
RUN cd /tmp/build/perl-5.20.0 && make test &>> /artifact/perl-build.log
RUN cd /tmp/build/perl-5.20.0 && make install &>> /artifact/perl-build.log

ADD misc/config_heavy.patch.pl /tmp/build/config_heavy.patch.pl
RUN /opt/perl/bin/perl /tmp/build/config_heavy.patch.pl /opt/perl/lib/5.20.0/`/opt/perl/bin/perl -MConfig -e 'print $Config{archname}'`/Config_heavy.pl
ADD misc/change-shebang.pl /opt/perl/bin/change-shebang.pl
RUN chmod 744 /opt/perl/bin/change-shebang.pl

RUN wget -q -O - http://cpanmin.us | /opt/perl/bin/perl - -qn App::cpanminus

RUN /opt/perl/bin/change-shebang.pl /opt/perl/bin/*

RUN cp -r /opt/perl /tmp/perl-`/opt/perl/bin/perl -MConfig -e 'print qq($^V-$Config{archname})'`
RUN cd /tmp && tar czf /artifact/perl-`/opt/perl/bin/perl -MConfig -e 'print qq($^V-$Config{archname})'`.tar.gz perl-`/opt/perl/bin/perl -MConfig -e 'print qq($^V-$Config{archname})'`

RUN rm -rf /tmp/perl-`/opt/perl/bin/perl -MConfig -e 'print qq($^V-$Config{archname})'`
RUN rm -rf /tmp/build

CMD ["sleep", "infinity"]
