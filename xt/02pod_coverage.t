use Test::More;
use Test::Pod::Coverage;

my @modules = qw(Finance::Bitcoin Finance::Bitcoin::API Finance::Bitcoin::Wallet Finance::Bitcoin::Address);
pod_coverage_ok($_, "$_ is covered")
	foreach @modules;
done_testing(scalar @modules);

