#!/bin/bash

set -eux

export HOMEBREW_NO_AUTO_UPDATE=1

brew unlink $(brew list)
brew install xz coreutils gnu-tar
brew link --force xz coreutils gnu-tar
