#!/bin/bash

set -euxo pipefail

mac_prepare_tools() {
  export HOMEBREW_NO_AUTO_UPDATE=1
  brew unlink $(brew list --formula)
  brew install xz coreutils gnu-tar
  brew link --force xz coreutils gnu-tar
}

mac_build_perl() {
  export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
  curl -fsSL https://git.io/perl-install | bash -s ~/perl
  curl -fsSL --compressed -o ~/cpm https://git.io/cpm
  ~/perl/bin/perl ~/cpm install -g --cpanfile build/cpanfile
  sudo install -m 755 -o $USER -g staff -d /opt/perl
  ~/perl/bin/perl build/relocatable-perl-build --prefix /opt/perl --perl_version $(cat BUILD_VERSION)
  /opt/perl/bin/perl ~/cpm install -g App::cpanminus App::ChangeShebang
  /opt/perl/bin/change-shebang -f /opt/perl/bin/*
}

mac_create_artifacts() {
  mkdir darwin-2level
  gcp -r /opt/perl ./perl-darwin-2level
  gtar cf perl-darwin-2level.tar perl-darwin-2level
  gzip -9 --stdout perl-darwin-2level.tar > darwin-2level/perl-darwin-2level.tar.gz
  xz   -9 --stdout perl-darwin-2level.tar > darwin-2level/perl-darwin-2level.tar.xz
}

linux_create_artifacts() {
  mkdir x86_64-linux
  ID=$(docker create skaji/relocatable-perl)
  docker cp $ID:/perl-x86_64-linux.tar.gz x86_64-linux/
  docker cp $ID:/perl-x86_64-linux.tar.xz x86_64-linux/
  docker rm $ID
}

case "$1" in
mac_prepare_tools)
  mac_prepare_tools
  ;;
mac_build_perl)
  mac_build_perl
  ;;
mac_create_artifacts)
  mac_create_artifacts
  ;;
linux_create_artifacts)
  linux_create_artifacts
  ;;
*)
  echo "unknown command: $1" >&2
  exit 1
  ;;
esac
