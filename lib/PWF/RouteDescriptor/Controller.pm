package PWF::RouteDescriptor::Controller;
use strict;
use warnings FATAL => 'all';
use parent qw/PWF::RouteDescriptor/;
use Module::Load;
use PWF::Controller;
use Carp qw/confess/;

#@override
#@returns PWF::Response
sub calc_response {
    my $self = shift;
    my PWF::Request $request = shift;

    my PWF::Controller $controller = $self->get_handler;
    Module::Load::load( $controller );
    confess 'Controller must be a descendant of PWF::Controller' unless UNIVERSAL::isa( $controller,
        'PWF::Controller' );
    return $controller->new( $request )->dispatch();
}

1;