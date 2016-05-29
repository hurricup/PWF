package TestSite::Controllers::Main;
use strict;
use warnings FATAL => 'all';
use parent qw/PWF::Controller/;
use PWF::Response::OK;

#@override
#@returns PWF::Response
sub get {
    my ($self) = @_;
    my $response = PWF::Response::OK->new( 'Test controller' );
    return $response;
}

1;