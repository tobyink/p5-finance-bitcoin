package Finance::Bitcoin::Wallet;

use 5.010;
use strict;
use warnings;
no warnings qw( numeric void once uninitialized );

use Carp;
use Finance::Bitcoin;
use Moo;
use Object::AUTHORITY;
use Scalar::Util qw[blessed];

BEGIN {
	$Finance::Bitcoin::Wallet::AUTHORITY = 'cpan:TOBYINK';
	$Finance::Bitcoin::Wallet::VERSION   = '0.004';
}

has api => (
	is      => 'rw',
	default => sub { "Finance::Bitcoin::API"->new },
);

around BUILDARGS => sub
{
	my $orig  = shift;
	my $class = shift;
	
	if (scalar @_ == 1 and blessed $_[0])
	{
		return $class->$orig(api => @_);
	}
	elsif (scalar @_ == 1 and $_[0] =~ /^http/)
	{
		my $api = "Finance::Bitcoin::API"->new(endpoint => "$api");
		return $class->$orig(api => $api);
	}
	
	return $class->$orig(@_);
};

sub balance
{
	my $self = shift;
	return $self->api->call('getbalance');
}

sub pay
{
	my $self = shift;
	my ($address, $amount) = @_;
	
	croak "Must provide an address" unless $address;
	croak "Must provide an amount"  unless $amount;
	
	$address = $address->address if blessed $address;
	
	return $self->api->call(sendtoaddress => $address, $amount);
}

sub create_address
{
	my $self = shift;
	my ($label) = @_;
	
	my $address_id = $self->api->call('getnewaddress');
	my $address = "Finance::Bitcoin::Address"->new($self->api, $address_id);
	$address->label($label) if $label;
	
	return $address;
}

sub addresses
{
	my ($self) = @_;
	
	my $list = $self->api->call('listreceivedbyaddress', 0, JSON::true);
	return unless ref($list) eq 'ARRAY';
	
	return
		map  { "Finance::Bitcoin::Address"->new($self->api, $_->{address}); }
		grep { $_->{amount} > 0 }
		@$list;
}

1;

__END__

=head1 NAME

Finance::Bitcoin::Wallet - a bitcoin wallet

=head1 SYNOPSIS

 use Finance::Bitcoin;
 
 my $uri     = 'http://user:password@127.0.0.1:8332/';
 my $wallet  = Finance::Bitcoin::Wallet->new($uri);
 
 print "Have: " . $wallet->balance . "\n";
 $wallet->pay($destination_address, $amount);
 print "Now have: " . $wallet->balance . "\n";
 
 foreach my $address ($wallet->addresses)
 {
   print $address->label . "\n";
 }

=head1 DESCRIPTION

This module is part of the high-level API for accessing a running
Bitcoin instance.

=over 4

=item C<< new($endpoint) >>

Constructor. $endpoint may be the JSON RPC endpoint URL, or may be a
Finance::Bitcoin::API object.

=item C<< balance >>

Returns the current balance of the wallet.

=item C<< pay($dest, $amount) >>

Pays some bitcoins to an account, causing the balance of the wallet to
decrease. $dest may be a Finance::Bitcoin::Address, or an address string.

=item C<< addresses >>

Returns a list of receiving addresses - i.e. addresses that can be used
by other people to send money to this wallet. Each item on the list is
a Finance::Bitcoin::Address object.

This list may be non-exhaustive!

=item C<< create_address($label) >>

Creates a new receiving address - i.e. an address that can be used by
other people to send money to this wallet. $label is an optional
human-friendly name for the address. Returns a Finance::Bitcoin::Address
object.

=item C<< api >>

Retrieve a reference to the L<Finance::Bitcoin::API> object being used. 

=back

=head1 BUGS

Please report any bugs to L<http://rt.cpan.org/>.

=head1 SEE ALSO

L<Finance::Bitcoin>, L<Finance::Bitcoin::Address>.

L<http://www.bitcoin.org/>.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT

Copyright 2010-2011 Toby Inkster

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

