#!/bin/bash

export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

set -ex
curl -fsSL https://git.io/perl-install | bash -s ~/perl
curl -fsSL --compressed -o ~/cpm https://git.io/cpm
~/perl/bin/perl ~/cpm install -g --cpanfile build/cpanfile
sudo install -m 755 -o $USER -g staff -d /opt/perl
~/perl/bin/perl build/relocatable-perl-build --prefix /opt/perl --perl_version $(cat BUILD_VERSION)
/opt/perl/bin/perl ~/cpm install -g App::cpanminus App::ChangeShebang
/opt/perl/bin/change-shebang -f /opt/perl/bin/*

mkdir releases
NAME=perl-$(/opt/perl/bin/perl -MConfig -e 'print $Config{archname}')
gcp -r /opt/perl ./$NAME
gtar cf $NAME.tar $NAME
gzip -9 --stdout $NAME.tar > releases/$NAME.tar.gz
xz   -9 --stdout $NAME.tar > releases/$NAME.tar.xz
rm -rf $NAME $NAME.tar
