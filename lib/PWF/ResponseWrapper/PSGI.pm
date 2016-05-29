package PWF::ResponseWrapper::PSGI;
use strict;
use warnings FATAL => 'all';
use parent qw/PWF::ResponseWrapper/;
use PWF::Response;

sub new
{
    my $proto = shift;
    my PWF::Response $response = shift;

    return $proto->SUPER::new( [
            $response->get_status,
            $response->get_headers,
            $response->get_content,
        ] );
}

sub process_response
{
    my ($self) = @_;
    return [ @$self ];
}

1;