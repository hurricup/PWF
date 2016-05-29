package PWF::ResponseFactory;
use strict;
use warnings FATAL => 'all';
# class provides construction of error responses
# subclass it and override App::get_response_factory methods to provide your own response classes
sub new
{
    my ($proto) = @_;
    return bless { }, $proto;
}

#@method
sub internal_server_error
{
    my (undef, $message) = @_;
    require PWF::Response::InternalServerError;
    return PWF::Response::InternalServerError->new( $message )
}

#@method
sub not_found
{
    my (undef, $message) = @_;
    require PWF::Response::NotFound;
    return PWF::Response::NotFound->new( $message )
}

#@method
sub method_not_allowed
{
    my (undef, $message) = @_;
    require PWF::Response::MethodNotAllowedError;
    return PWF::Response::MethodNotAllowedError->new( $message )
}


1;