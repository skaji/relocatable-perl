# relocatable perl

[![Build Status](https://api.travis-ci.org/shoichikaji/relocatable-perl.svg)](https://travis-ci.org/shoichikaji/relocatable-perl)

Perl can be built with relocatable enabled,
which means you can move perl wherever you want!

I prepared relocatable enabled perls for linux and MacOS X.
See [release page](https://github.com/shoichikaji/relocatable-perl/releases).

## how to install

Just download and extract it.

Let's say you use MacOS X, then:

    > wget https://github.com/shoichikaji/relocatable-perl/releases/download/0.7/perl-darwin-2level.tar.gz
    > tar xzf perl-darwin-2level.tar.gz
    > mv perl-darwin-2level ~/my-favorite-name

That's all. Check out your perl works:

    > ~/my-favorite-name/bin/perl -v
    This is perl 5, version 20, subversion 1 (v5.20.1) built for darwin-2level

    # cpanm is already installed. Install your favorite cpan module.
    > ~/my-favorite-name/bin/cpanm LWP::UserAgent

## how to build yourself

See [Dockerfile](https://github.com/shoichikaji/relocatable-perl/blob/master/Dockerfile)
and [mac.sh](https://github.com/shoichikaji/relocatable-perl/blob/master/mac.sh).

## docker image

https://registry.hub.docker.com/u/skaji/relocatable-perl

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

* [App::ChangeShebang](https://github.com/shoichikaji/change-shebang)
Copyright Shoichi Kaji, licensed under the same terms as Perl.
