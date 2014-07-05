# relocatable perl

    > docker build -t my-perl git://github.com/shoichikaji/relocatable-perl.git
    > docker run -d my-perl
    > docker cp `docker ps -l -q`:/tmp/artifact/perl.tar.gz .
