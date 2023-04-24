# relocatable perl [![build](https://github.com/skaji/relocatable-perl/workflows/build/badge.svg)](https://github.com/skaji/relocatable-perl/actions) [![Build Status](https://app.bitrise.io/app/ee64bd72-9bc8-4faa-9da5-65d2de4eee0f/status.svg?token=ehqx3S7rVWDjQQlx0B9A_w)](https://app.bitrise.io/app/ee64bd72-9bc8-4faa-9da5-65d2de4eee0f)

Self-contained, portable perl binaries for Linux and macOS.
You can download them from [release page](https://github.com/skaji/relocatable-perl/releases).

Since version 5.10, perl can be built with [relocatable INC](https://metacpan.org/pod/release/XSAWYERX/perl-5.26.0/pod/perl5100delta.pod#Relocatable-installations).
If we build perl with `-Duserelocatableinc` and apply some patches to it,
then we have self-contained and portable perl.

## Install

There are 3 ways:

### One liner

    curl -fsSL https://raw.githubusercontent.com/skaji/relocatable-perl/main/perl-install | bash -s ~/perl

This installs the latest relocatable perl to `~/perl`.

### plenv

If you use [plenv](https://github.com/tokuhirom/plenv),
then [plenv-download](https://github.com/skaji/plenv-download) may be useful:

    git clone https://github.com/skaji/plenv-download $(plenv root)/plugins/plenv-download
    # download the latest relocatable perl
    plenv download latest

### Manually

You can download appropriate tarballs from [release pages](https://github.com/skaji/relocatable-perl/releases).

For example, if you use linux amd64, then:

    curl -fsSL -o perl-linux-amd64.tar.xz https://github.com/skaji/relocatable-perl/releases/latest/download/perl-linux-amd64.tar.xz
    tar xJf perl-linux-amd64.tar.xz
    mv perl-linux-amd64 ~/wherever-you-want
    ~/wherever-you-want/bin/perl --version

## How to build relocatable perls by yourself

See [build](build) and [.github/workflows](.github/workflows) directories.

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
