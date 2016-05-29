package TestSite::Controllers::Main;
use strict;
use warnings FATAL => 'all';
use parent qw/PWF::Controller/;
use PWF::Response::OK;
use v5.10;

#@override
#@returns PWF::Response
sub get {
    my ($self) = @_;
    my $response = PWF::Response::OK->new( 'Test controller' );
    #    say STDERR "Something bad";
    #    warn 'Here is the warning';
    use PWF::Response::InternalServerError;
    die PWF::Response::InternalServerError->new( 'custom error' );

    return $response;
}

1;