package PWF::Response::OK;
use strict;
use warnings FATAL => 'all';
use parent qw/PWF::Response/;
use PWF::HTTP::Status;

sub new
{
    my ($self, $content) = @_;
    return $self->SUPER::new(
        status  => HTTP_OK,
        headers => [ 'Content-Type' => 'text/plain' ],
        content => [ $content ],
    );
}


1;