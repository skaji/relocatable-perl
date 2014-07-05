#!/usr/bin/perl
use strict;
use warnings;
use 5.010;
use File::Temp 'tempfile';
use File::Basename 'dirname';

my $config_heavy = shift or die;

open my $in, "<", $config_heavy or die;
my ($out, $tmpname) = tempfile UNLINK => 0, DIR => dirname($config_heavy);
my $mode = (stat $config_heavy)[2];
chmod $mode, $tmpname;

my $fix_line1 = 'foreach my $what';
my $fix_line2 = 's/^($what=)';

while (<$in>) {
    if (/^perlpath=/) {
        say {$out} "perlpath='.../perl'";
    } elsif (/^startperl=/) {
        say {$out} "startperl='#!.../perl'";
    } elsif (/^\Q$fix_line1\E/) {
        say {$out} q[foreach my $what (qw(startperl perlpath prefixexp archlibexp man1direxp man3direxp privlibexp scriptdirexp sitearchexp sitebinexp sitelibexp siteman1direxp siteman3direxp sitescriptexp siteprefixexp sitelib_stem installarchlib installman1dir installman3dir installprefixexp installprivlib installscript installsitearch installsitebin installsitelib installsiteman1dir installsiteman3dir installsitescript)) {];
    } elsif (/^(\s+)\Q$fix_line2\E/) {
        say {$out} $1, q{s/^($what=)(['"])(#!)?(.*?)\2/$1 . $2 . ($3 || "") . relocate_inc($4) . $2/me;};
    } else {
        print {$out} $_;
    }
}
close $_ for $in, $out;

rename $tmpname, $config_heavy or die;
