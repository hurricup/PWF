package PWF::App;
use strict;
use warnings FATAL => 'all';
# this is a base class for Applications

use PWF::Request;
use PWF::Response;
use PWF::ResponseFactory;
use PWF::ResponseWrapper::PSGI;
use PWF::RouteDescriptor;

use constant {
    dev_mode => 0
};

sub new
{
    my ($proto) = @_;
    return bless {
            route_descriptors => [ ],
        }, $proto;
}

sub get_route_descriptors
{
    my ($self) = @_;
    return $self->{route_descriptors};
}

sub get_response
{
    my $self = shift;
    my PWF::Request $request = shift;

    foreach my PWF::RouteDescriptor $route_descriptor (@{$self->get_route_descriptors})
    {
        if (my $response = $route_descriptor->get_response( $request ))
        {
            return $response;
        }
    }
    return $self->get_response_factory->not_found();
}

#@returns PWF::ResponseWrapper
sub process_request
{
    my $self = shift;
    my PWF::Request $request = shift;

    my $response = eval {$self->get_response( $request );};
    $response = $@ if $@;
    unless (UNIVERSAL::isa( $response, 'PWF::Response' ))
    {
        warn "Controller returned $response instead of PWF::Response object";
        $response = $self->get_response_factory->internal_server_error();
    }

    return $self->wrap_response( $response );
}

#@returns PWF::ResponseWrapper
sub wrap_response
{
    my ($self, $response) = @_;

    my $psgi_response = eval {PWF::ResponseWrapper::PSGI->new( $response )};
    $response = $@ if $@;

    unless (UNIVERSAL::isa( $psgi_response, 'PWF::ResponseWrapper' ))
    {
        warn 'Error rendering response';
        $psgi_response = PWF::ResponseWrapper->new( $self->get_response_factory->internal_server_error() );
    }
    return $psgi_response;
}

#@returns PWF::ResponseFactory
sub get_response_factory
{
    my ($self) = @_;
    return $self->{response_factory} //= PWF::ResponseFactory->new();
}

#@method
sub init_routes
{
    my $self = shift;
    # this method must register routes to an application, invoked only once
    use PWF::RouteDescriptor::Controller;
    push @{$self->get_route_descriptors}, PWF::RouteDescriptor::Controller->new( '/', 'TestSite::Controllers::Main' );
}

#@method
sub create_request
{
    my (undef, @args) = @_;
    return PWF::Request->new( { %ENV, %{$args[0]} } );
}

#@method
sub get_runner
{
    my $self = shift;

    $self->init_routes;

    return sub{
        my $psgi_env = shift;
        my $request = $self->create_request( $psgi_env );
        my $response_wrapper = $self->process_request( $request );
        return $response_wrapper->process_response;
    };
}

1;