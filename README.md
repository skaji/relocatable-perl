# relocatable perl [![Build Status](https://api.travis-ci.org/skaji/relocatable-perl.svg?branch=master)](https://travis-ci.org/skaji/relocatable-perl)

Self-contained, portable perl binaries for x86-64 Linux and OS X.
You can download them from [release page](https://github.com/skaji/relocatable-perl/releases).

Since version 5.10, perl can be built with [relocatable INC](https://metacpan.org/pod/release/XSAWYERX/perl-5.26.0/pod/perl5100delta.pod#Relocatable-installations).
If we build perl with `-Duserelocatableinc` and apply some patches to it,
then we have self-contained and portable perl.

## Install

### One liner

    curl -sSkL https://git.io/perl-install | bash -s ~/perl

This installs the latest relocatable perl to `~/perl`.

### plenv

If you use [plenv](https://github.com/tokuhirom/plenv),
then [plenv-download](https://github.com/skaji/plenv-download) may be useful:

    git clone https://github.com/skaji/plenv-download ~/.plenv/plugins/plenv-download
    # download the latest relocatable perl
    plenv download latest

### Manually

Let's say you use OS X. Then:

    wget https://github.com/skaji/relocatable-perl/releases/download/5.26.0.0/perl-darwin-2level.tar.gz
    tar xzf perl-darwin-2level.tar.gz
    mv perl-darwin-2level ~/my-favorite-name

That's all. Check out your perl works:

    $ ~/my-favorite-name/bin/perl -v
    This is perl 5, version 26, subversion 0 (v5.26.0) built for darwin-2level

    # cpanm is already installed. Install your favorite cpan modules.
    $ ~/my-favorite-name/bin/cpanm LWP::UserAgent

## How to build relocatable perls by yourself

See [mac.sh](https://github.com/skaji/relocatable-perl/blob/master/mac.sh),
[Dockerfile](https://github.com/skaji/relocatable-perl/blob/master/Dockerfile) and
[Docker Hub](https://hub.docker.com/r/skaji/relocatable-perl/).

## License

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
