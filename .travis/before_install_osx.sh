#!/bin/bash

set -eux

brew unlink $(brew list)
brew install xz coreutils gnu-tar
brew link --force xz coreutils gnu-tar
