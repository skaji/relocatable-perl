# relocatable perl

Perl can be build with relocatable enabled,
which means you can move perl wherever you want!

I prepare relocatable enabled perls for linux and MacOS X.
See [release page](https://github.com/shoichikaji/relocatable-perl/releases).
Why don't you try them?

## how?

Just download and extract it.

Let's say you use MacOS X, then:

    > wget https://github.com/shoichikaji/relocatable-perl/releases/download/0.1/perl-v5.20.0-darwin-2level.tar.gz
    > tar xzf perl-v5.20.0-darwin-2level.tar.gz
    > mv perl-v5.20.0-darwin-2level ~/my-favorite-name

That's all! Check out your perl works:

    > ~/my-favorite-name/bin/perl -v
    This is perl 5, version 20, subversion 0 (v5.20.0) built for darwin-2level
    ...

    # cpanm is already installed.
    > ~/my-favorite-name/bin/cpanm Mojolicious

## how to build yourself

If you want to build relocatable enabled perl yourself, please see
[Dockerfile](https://github.com/shoichikaji/relocatable-perl/blob/master/Dockerfile),
in which all processes are described.

In fact you can pull that docker image:

    > docker pull skaji/relocatable-perl
    > docker run -d skaji/relocatable-perl
    > docker cp `docker ps -l -q`:/artifact/perl-v5.20.0-x86_64-linux.tar.gz .

See also https://registry.hub.docker.com/u/skaji/relocatable-perl

