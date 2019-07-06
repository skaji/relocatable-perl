#!/bin/bash

set -eux

docker build -t skaji/relocatable-perl -f .travis/Dockerfile .
ID=$(docker create skaji/relocatable-perl)
docker cp $ID:/perl-x86_64-linux.tar.gz .
docker cp $ID:/perl-x86_64-linux.tar.xz .
docker rm $ID
