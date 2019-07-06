#!/bin/bash

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

set -ex
sudo install -m 755 -o $USER -g staff -d /opt/perl
perl ./relocatable-perl-build --prefix /opt/perl --perl_version $(cat BUILD_VERSION)
curl --compressed -sSL https://git.io/cpm | /opt/perl/bin/perl - install -g App::cpanminus App::ChangeShebang
/opt/perl/bin/change-shebang -f /opt/perl/bin/*

NAME=perl-$(/opt/perl/bin/perl -MConfig -e 'print $Config{archname}')
gcp -r /opt/perl ./$NAME
gtar cf $NAME.tar $NAME
gzip -9 --stdout $NAME.tar > $NAME.tar.gz
xz   -9 --stdout $NAME.tar > $NAME.tar.xz
rm -rf $NAME $NAME.tar
