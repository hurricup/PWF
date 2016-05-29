package PWF::App;
use strict;
use warnings FATAL => 'all';
# this is a base class for Applications

use PWF::Request;
use PWF::Response;
use PWF::Response::OK;
use PWF::Response::InternalServerError;
use TestSite::Controllers::Main;

sub new
{
    my ($proto) = @_;
    return bless {}, $proto;
}

#@returns PWF::Response
sub dispatch
{
    my $self = shift;
    my PWF::Request $request = shift;
    # route
    my $response;
    eval {
        # fixme controller instantiation should be handled separately
        my $controller = TestSite::Controllers::Main->new( $request );
        $response = $controller->dispatch();
    };

    $response = $@ if $@;

    if (UNIVERSAL::isa( $response, 'PWF::Response' ))
    {
        return $response;
    }
    else
    {
        warn "Controller returned $response instead of PWF::Response object";
        return PWF::Response::InternalServerError->new();
    }
}

#@method
sub get_runner
{
    my $self = shift;

    return sub{
        my $psgi_env = shift;
        my $request = PWF::Request->new( { %ENV, %$psgi_env } ); # fixme clearly PSGI merging, may be generalized
        my $response = $self->dispatch( $request );
        return $response->get_psgi_response;
    };
}

1;