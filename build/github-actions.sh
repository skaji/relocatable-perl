#!/bin/bash

set -euxo pipefail

mac_prepare_tools() {
  export HOMEBREW_NO_AUTO_UPDATE=1
  export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=1
  export HOMEBREW_NO_INSTALL_CLEANUP=1
  unset GITHUB_ACTIONS
  brew unlink $(brew list --formula)
  brew install xz coreutils gnu-tar
  brew link --force xz coreutils gnu-tar
}

mac_build_perl() {
  export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
  rm -rf ~/perl ~/cpm
  curl -fsSL https://raw.githubusercontent.com/skaji/relocatable-perl/main/perl-install | bash -s ~/perl
  curl -fsSL --compressed -o ~/cpm https://raw.githubusercontent.com/skaji/cpm/main/cpm
  ~/perl/bin/perl ~/cpm install -g --cpmfile build/cpm.yml
  sudo rm -rf /opt/perl
  sudo install -m 755 -o $USER -g staff -d /opt/perl
  ~/perl/bin/perl build/relocatable-perl-build --prefix /opt/perl --perl_version $(cat BUILD_VERSION)
  /opt/perl/bin/perl ~/cpm install -g App::cpanminus App::ChangeShebang
  /opt/perl/bin/change-shebang -f /opt/perl/bin/*
}

mac_create_artifacts() {
  local archname=$(if [[ $(uname -m) = x86_64 ]]; then echo amd64; else echo arm64; fi)
  rm -rf darwin-$archname perl-darwin-$archname*
  gcp -r /opt/perl perl-darwin-$archname
  gtar cf perl-darwin-$archname.tar perl-darwin-$archname
  mkdir darwin-$archname
  gzip -9 --stdout perl-darwin-$archname.tar > darwin-$archname/perl-darwin-$archname.tar.gz
  xz   -9 --stdout perl-darwin-$archname.tar > darwin-$archname/perl-darwin-$archname.tar.xz
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
*)
  echo "unknown command: $1" >&2
  exit 1
  ;;
esac
