package Finance::Bitcoin::API;

BEGIN {
	$Finance::Bitcoin::API::AUTHORITY = 'cpan:TOBYINK';
	$Finance::Bitcoin::API::VERSION   = '0.004';
}

use 5.010;
use Moo;

use JSON::RPC::Client;
use Moo;
use Object::AUTHORITY;
use Scalar::Util qw( blessed );

has endpoint => (is => "rw",   default => sub { "http://127.0.0.1:8332/" });
has jsonrpc  => (is => "lazy", default => sub { "JSON::RPC::Client"->new });
has error    => (is => "rwp");

sub call
{
	my $self = shift;
	my ($method, @params) = @_;
	
	$self->_set_error(undef);
	
	my $return = $self->jsonrpc->call($self->endpoint, {
		method    => $method,
		params    => \@params,
	});
	
	if (blessed $return and $return->can('is_success') and $return->is_success)
	{
		$self->_set_error(undef);
		return $return->result;
	}
	elsif (blessed $return and $return->can('error_message'))
	{
		$self->_set_error($return->error_message);
		return;
	}
	else
	{
		$self->_set_error(sprintf('HTTP %s', $self->jsonrpc->status_line));
		return;
	}
}

1;

__END__

=head1 NAME

Finance::Bitcoin::API - wrapper for the Bitcoin JSON-RPC API

=head1 SYNOPSIS

 use Finance::Bitcoin::API;
 
 my $uri     = 'http://user:password@127.0.0.1:8332/';
 my $api     = Finance::Bitcoin::API->new( endpoint => $uri );
 my $balance = $api->call('getbalance');
 print $balance;

=head1 DESCRIPTION

This module provides a low-level API for accessing a running
Bitcoin instance.

=over 4

=item C<< new( %args ) >>

Constructor. %args is a hash of named arguments. You need to provide the
'endpoint' URL as an argument.

=item C<< call( $method, @params ) >>

Call a method. If successful returns the result; otherwise returns undef.

=item C<< endpoint >>

Get/set the endpoint URL.

=item C<< jsonrpc >>

Retrieve a reference to the L<JSON::RPC::Client> object being used. In particular
C<< $api->jsonrpc->ua >> can be useful if you need to alter timeouts or HTTP proxy
settings.

=item C<< error >>

Returns the error message (if any) that resulted from the last C<call>.

=back

=head1 BUGS

Please report any bugs to L<http://rt.cpan.org/>.

=head1 SEE ALSO

L<Finance::Bitcoin>.

L<http://www.bitcoin.org/>.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT

Copyright 2010-2011 Toby Inkster

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

