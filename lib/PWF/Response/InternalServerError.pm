package PWF::Response::InternalServerError;
use strict;
use warnings FATAL => 'all';
use parent qw/PWF::Response/;
use PWF::HTTP::Status;

sub new
{
    my ($self, $message) = @_;
    return $self->SUPER::new(
        status  => HTTP_INTERNAL_SERVER_ERROR,
        content => [ $message // 'Something bad happened...' ],
    );
}

1;