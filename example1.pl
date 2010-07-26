#!/usr/bin/perl

use 5.010;
use lib 'lib';
use Finance::Bitcoin::API;

my $creds   = shift @ARGV;
my $uri     = 'http://'.$creds.'@127.0.0.1:8332/';
my $api     = Finance::Bitcoin::API->new( endpoint => $uri );
my $balance = $api->call('getbalance');
say $balance;

