#!/bin/bash

set -eux

docker build -t skaji/relocatable-perl -f .travis/Dockerfile .
mkdir releases
ID=$(docker create skaji/relocatable-perl)
docker cp $ID:/perl-x86_64-linux.tar.gz releases/
docker cp $ID:/perl-x86_64-linux.tar.xz releases/
docker rm $ID
