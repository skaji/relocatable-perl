../relocatable-perl-build: relocatable-perl-build local/lib/perl5/Devel/PatchPerl.pm
	fatpack-simple -o ../relocatable-perl-build relocatable-perl-build

local/lib/perl5/Devel/PatchPerl.pm:
	cpanm -nq -Llocal Devel::PatchPerl
