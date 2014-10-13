#!/bin/bash

# Usage:
#  ./mac.sh --perl_version 5.20.1
#  ./mac.sh --tarball ~/perl-5.20.1.tar.gz

HAVE_GDBM=NO
PERL_PREFIX=/opt/perl
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

for cmd in gcp gtar curl; do
  if ! type $cmd >/dev/null 2>&1; then echo missing $cmd; exit 1; fi
done

set -ex
if [ -e $PERL_PREFIX ]; then echo already exists $PERL_PREFIX; exit 1; fi
sudo mkdir $PERL_PREFIX
sudo chown $USER:staff $PERL_PREFIX

if [ -f /usr/local/lib/libgdbm.dylib ]; then brew unlink gdbm; HAVE_GDBM=YES; fi
perl ./relocatable-perl-build --prefix $PERL_PREFIX "$@"
if [ $HAVE_GDBM = "YES" ]; then brew link gdbm; fi

curl -sL http://cpanmin.us | $PERL_PREFIX/bin/perl - -qn App::cpanminus App::ChangeShebang
$PERL_PREFIX/bin/change-shebang -f $PERL_PREFIX/bin/*

NAME=perl-`$PERL_PREFIX/bin/perl -MConfig -e 'print $Config{archname}'`
gcp -r /opt/perl ./$NAME
gtar czf $NAME.tar.gz $NAME
rm -rf $NAME
