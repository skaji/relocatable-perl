#!/bin/sh
exec "$(dirname "$0")"/perl -x -- "$0" "$@"
#!perl
use strict;
use warnings;
use utf8;
use File::Temp 'tempfile';
use File::Basename 'dirname';

for my $file (@ARGV) {
    maybe_script($file) or next;
    warn "change shebang of $file\n";
    change_shebang($file);
}

sub maybe_script {
    my $file = shift;
    return if !-e $file || -l $file;
    open my $fh, "<", $file or return;
    read $fh, my $first, 100 or return;
    return $first =~ /^#![^\n]*perl/ ? 1 : 0;
}

sub change_shebang {
    my $file = shift;
    my $mode = (stat $file)[2];
    my $content = do {
        open my $fh, "<", $file or die;
        local $/; <$fh>;
    };

    my ($fh, $tempfile) = tempfile UNLINK => 0, DIR => dirname($file);
    chmod $mode, $tempfile;
    print {$fh} <<'...';
#!/bin/sh
exec "$(dirname "$0")"/perl -x -- "$0" "$@"
#!perl
...
    print {$fh} $content;
    close $fh;

    rename $tempfile, $file or die "rename $tempfile $file: $!";
}
