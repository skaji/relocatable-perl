#!/usr/bin/env perl
use v5.38;

use HTTP::Tiny;
use JSON::XS ();

my $HTTP = HTTP::Tiny->new(verify_SSL => 1);
my $JSON = JSON::XS->new->utf8->pretty->canonical;

my $query = <<'EOF';
{
  repository(name: "relocatable-perl", owner: "skaji") {
    releases(first: 100) {
      edges {
        node {
          releaseAssets(first: 100) {
            edges {
              node {
                downloadUrl
              }
            }
          }
        }
      }
    }
  }
}
EOF

my $token = $ENV{GITHUB_TOKEN} or die "Need GITHUB_TOKEN\n";
my $content = $JSON->encode({ query => $query });
my $url = "https://api.github.com/graphql";

my $res = $HTTP->post($url, {
    headers => {
        "content-type" => "application/json",
        "content-length" => (length $content),
        "authorization" => "bearer $token",
    },
    content => $content,
});

if (!$res->{success}) {
    die "$res->{status} $res->{reason}, $url\n$res->{content}\n";
}

my $body = $JSON->decode($res->{content});
if ($body->{errors}) {
    die $JSON->encode($body->{errors});
}

my $new_form = qr{/(?<version>\d+\.\d+\.\d+\.\d+)/perl-(?<os>linux|darwin)-(?<arch>amd64|arm64)\.tar\.(?<compress>gz|xz)$};
my $old_form = qr{/(?<version>\d+\.\d+\.\d+\.\d+)/perl-(?:(?<arch>x86_64|aarch64)-)?(?<os>linux|darwin).*\.(?<compress>gz|xz)$};

my @release;
for my $asset (map { $_->{node}{releaseAssets}{edges}->@* } $body->{data}{repository}{releases}{edges}->@*) {
    my $url = $asset->{node}{downloadUrl};
    if ($url =~ $new_form || $url =~ $old_form) {
        my $arch = $+{arch} || 'amd64';
        $arch = "amd64" if $arch eq "x86_64";
        $arch = "arm64" if $arch eq "aarch64";
        push @release, {
            url => $url,
            version => $+{version},
            arch => $arch,
            os => $+{os},
            compress => $+{compress},
        };
    }
}

my $sort_by = sub ($a, $b) {
    my %os = (linux => 1, darwin => 0);
    my %arch = (amd64 => 1, arm64 => 0);
    my %compress = (xz => 1, gz => 0);
    $b->{version} cmp $a->{version}
    ||
    $os{$b->{os}} <=> $os{$a->{os}}
    ||
    $arch{$b->{arch}} <=> $arch{$a->{arch}}
    ||
    $compress{$b->{compress}} <=> $compress{$a->{compress}};
};

my @name = qw(version os arch compress url padding);
say join ",", @name;
for my $release (sort { $sort_by->($a, $b) } @release) {
    say join ",", map { $release->{$_} // "" } @name;
}
