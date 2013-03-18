package Finance::Bitcoin::Role::HasAPI;

use Moo::Role;

use Finance::Bitcoin::API;
use Scalar::Util qw( blessed );

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
		my $api = "Finance::Bitcoin::API"->new(endpoint => "$_[0]");
		return $class->$orig(api => $api);
	}
	
	return $class->$orig(@_);
};

1;
