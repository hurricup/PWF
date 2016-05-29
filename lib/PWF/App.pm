package PWF::App;
use strict;
use warnings FATAL => 'all';
# this is a base class for Applications

use PWF::Request;
use PWF::Response;
use PWF::Response::OK;
use PWF::Response::InternalServerError;
use TestSite::Controllers::Main;
use PWF::ResponseWrapper::PSGI;

use constant {
    dev_mode => 0
};

sub new
{
    my ($proto) = @_;
    return bless {}, $proto;
}

#@returns PWF::ResponseWrapper
sub process_request
{
    my $self = shift;
    my PWF::Request $request = shift;
    # route
    my $response;
    eval {
        my $controller = TestSite::Controllers::Main->new( $request );
        $response = $controller->dispatch();
    };

    $response = $@ if $@;
    unless (UNIVERSAL::isa( $response, 'PWF::Response' ))
    {
        warn "Controller returned $response instead of PWF::Response object";
        $response = PWF::Response::InternalServerError->new();
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
        $psgi_response = PWF::ResponseWrapper->new( PWF::Response::InternalServerError->new() );
    }
    return $psgi_response;
}

#@method
sub get_runner
{
    my $self = shift;

    return sub{
        my $psgi_env = shift;
        my $request = PWF::Request->new( { %ENV, %$psgi_env } );
        my $response_wrapper = $self->process_request( $request );
        return $response_wrapper->process_response;
    };
}

1;