package PWF::Response::MethodNotAllowedError;
use strict;
use warnings FATAL => 'all';
use parent qw/PWF::Response/;
use PWF::HTTP::Status;

#@override
sub new {
    my ($proto, $message) = @_;
    return $proto->SUPER::new(
        status  => HTTP_METHOD_NOT_ALLOWED,
        content => [ $message // 'Method not allowed' ],
    );
}

1;