use strict;
use warnings;

use inc::Module::Install;

my $dist = 'Finance-Bitcoin';
my $fn   = "lib/$dist.pm"; $fn =~ s#-#/#g;

name                $dist;
perl_version_from   $fn;
version_from        $fn;
abstract_from       $fn;
readme_from         $fn;
author              'Toby Inkster <tobyink@cpan.org>';
license             'perl';

requires            'Carp'               => '1.00';
requires            'Class::Accessor'    => '0.34';
requires            'JSON::RPC::Client'  => '0.93';
test_requires       'Module::Signature'  => '0.66';
requires            'Scalar::Util'       => 0;
test_requires       'Test::More'         => '0.61';

resources(
	'homepage'   => "http://search.cpan.org/dist/$dist/",
	'repository' => "http://goddamn.co.uk/viewvc/perlmods/$dist/",
	'bugtracker' => "http://rt.cpan.org/Dist/Display.html?Queue=$dist",
	);

keywords(qw(Finance Currency Currancy Bitcoin Micropayments Commerce));

write_doap_changes;
write_doap_changes_xml;

include 'Test::Signature';
auto_install;
WriteAll(
	'meta' => 1,
	'sign' => 1,
	);
