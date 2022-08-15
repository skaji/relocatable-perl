#!/bin/bash

set -euxo pipefail

sw_vers
uname -a

export HOMEBREW_NO_AUTO_UPDATE=1
brew unlink $(brew list --formula)
brew install xz coreutils gnu-tar
brew link --force xz coreutils gnu-tar

curl -fsSL --compressed -o ~/cpm https://raw.githubusercontent.com/skaji/cpm/main/cpm
perl ~/cpm install --sudo -g --cpmfile build/cpm.yml
sudo rm -rf /opt/perl
sudo install -m 755 -o $USER -g staff -d /opt/perl
perl build/relocatable-perl-build --prefix /opt/perl --perl_version 5.36.0
/opt/perl/bin/perl ~/cpm install -g App::cpanminus App::ChangeShebang
/opt/perl/bin/change-shebang -f /opt/perl/bin/*

gcp -r /opt/perl perl-darwin-arm64
gtar cf perl-darwin-arm64.tar perl-darwin-arm64
mkdir darwin-arm64
gzip -9 --stdout perl-darwin-arm64.tar > darwin-arm64/perl-darwin-arm64.tar.gz
xz   -9 --stdout perl-darwin-arm64.tar > darwin-arm64/perl-darwin-arm64.tar.xz

brew install go@1.17
brew link --force go@1.17
