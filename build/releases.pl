#!/usr/bin/env perl
use 5.34.0;
use warnings;

use HTTP::Tiny;
use JSON::XS ();

my $HTTP = HTTP::Tiny->new;
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

my $res = $HTTP->post("https://api.github.com/graphql", {
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

my @release;
for my $release ($body->{data}{repository}{releases}{edges}->@*) {
    for my $asset ($release->{node}{releaseAssets}{edges}->@*) {
        my $url = $asset->{node}{downloadUrl};
        if ($url =~ m{/(?<version>\d+\.\d+\.\d+)\.(?<build_version>\d+)/perl-(?:(?<arch>x86_64|arm64)-)?(?<os>linux|darwin).*\.(?<compress>gz|xz)$}) {
            push @release, {
                url => $url,
                version => $+{version},
                build_version => $+{build_version},
                arch => ($+{arch} || "x86_64"),
                os => $+{os},
                compress => $+{compress},
            };
        }
    }
}

my $sort_by = sub {
    my ($a, $b) = @_;
    my %os = (linux => 1, darwin => 0);
    my %compress = (xz => 1, gz => 0);
    $b->{version} cmp $a->{version}
    ||
    $b->{build_version} <=> $a->{build_version}
    ||
    $os{$b->{os}} <=> $os{$a->{os}}
    ||
    $compress{$b->{compress}} <=> $compress{$a->{compress}};
};

my @name = qw(version build_version os arch compress url padding);
say join ",", @name;
for my $release (sort { $sort_by->($a, $b) } @release) {
    say join ",", map { $release->{$_} // "" } @name;
}
