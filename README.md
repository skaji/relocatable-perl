# relocatable perl

[![Build Status](https://api.travis-ci.org/skaji/relocatable-perl.svg?branch=master)](https://travis-ci.org/skaji/relocatable-perl)

Perl can be built with relocatable enabled,
which means you can move perl wherever you want!

I prepared relocatable enabled perls for linux and OS X.
See [release page](https://github.com/skaji/relocatable-perl/releases).

## How to install

### One liner

To install latest relocatable-perl to `~/perl`, just type:

    curl -sSkL https://git.io/perl-install | bash -s ~/perl

### Manually

Download and extract artifacts. Let's say you use OS X, then:

    > wget https://github.com/skaji/relocatable-perl/releases/download/5.26.0.0/perl-darwin-2level.tar.gz
    > tar xzf perl-darwin-2level.tar.gz
    > mv perl-darwin-2level ~/my-favorite-name

That's all. Check out your perl works:

    > ~/my-favorite-name/bin/perl -v
    This is perl 5, version 26, subversion 0 (v5.26.0) built for darwin-2level

    # cpanm is already installed. Install your favorite cpan module.
    > ~/my-favorite-name/bin/cpanm LWP::UserAgent

## How to build yourself

See [Dockerfile](https://github.com/skaji/relocatable-perl/blob/master/Dockerfile)
and [mac.sh](https://github.com/skaji/relocatable-perl/blob/master/mac.sh).

## Docker image

https://hub.docker.com/r/skaji/relocatable-perl/

## LICENSE

Copyright (C) Shoichi Kaji.

This is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

Please note that the artifacts in the release page contains
Perl5, App::cpanminus and App::ChangeShebang.
They have their own copyright and license.

* [Perl5](https://www.perl.org/)
Copyright 1987-2015, Larry Wall, GNU General Public License or Artistic License

* [App::cpanminus](https://github.com/miyagawa/cpanminus)
Copyright 2010- Tatsuhiko Miyagawa, licensed under the same terms as Perl.

* [App::ChangeShebang](https://github.com/skaji/change-shebang)
Copyright Shoichi Kaji, licensed under the same terms as Perl.
