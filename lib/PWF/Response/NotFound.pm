package PWF::Response::NotFound;
use strict;
use warnings FATAL => 'all';
use parent qw/PWF::Response/;
use PWF::HTTP::Status;

sub new
{
    my ($self, $message) = @_;
    return $self->SUPER::new(
        status  => HTTP_NOT_FOUND,
        content => [ $message // 'Requested uri not found...' ],
    );
}

1;