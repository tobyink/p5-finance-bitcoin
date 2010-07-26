#!/usr/bin/perl

use 5.010;
use lib 'lib';
use Data::Dumper;
use Finance::Bitcoin;

my $creds   = shift @ARGV;
my $uri     = 'http://'.$creds.'@127.0.0.1:8332/';
my $wallet  = Finance::Bitcoin::Wallet->new( $uri );

foreach my $address ($wallet->addresses)
{
	printf("%s (%s): %s\n", $address->address, $address->label, $address->received);
}

print "------\n";
printf("Balance: %s\n", $wallet->balance);