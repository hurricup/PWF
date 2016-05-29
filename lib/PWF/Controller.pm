package PWF::Controller;
use strict;
use warnings FATAL => 'all';
use Carp qw/confess/;

sub new
{
    my ($proto, $request) = @_;
    confess 'Missing request argument' unless $request;
    confess 'request must be a PWF::Request descendant' unless UNIVERSAL::isa( $request, 'PWF::Request' );
    return bless {
            request => $request,
        }, $proto;
}

#@returns PWF::Request
sub get_request
{
    my ($self) = @_;
    return $self->{request};
}

#@returns PWF::Response
sub dispatch
{
    my ($self) = @_;
    my $request = $self->get_request;
    my $env = $request->get_env;
    # fixme make wrapper for env
    my $method = $env->{REQUEST_METHOD};

    if ($method eq 'GET')
    {
        return $self->get();
    }
    elsif ($method eq 'POST')
    {
        return $self->post();
    }
    elsif ($method eq 'PUT')
    {
        return $self->put();
    }
    elsif ($method eq 'PATCH')
    {
        return $self->patch();
    }
    elsif ($method eq 'HEAD')
    {
        return $self->head();
    }
    elsif ($method eq 'DELETE')
    {
        return $self->delete();
    }
    $self->error_method_not_allowed();
}

#@returns PWF::Response
sub get
{
    my ($self) = @_;
    $self->error_method_not_allowed();
}

#@returns PWF::Response
sub post
{
    my ($self) = @_;
    $self->error_method_not_allowed();
}

#@returns PWF::Response
sub put
{
    my ($self) = @_;
    $self->error_method_not_allowed();
}

#@returns PWF::Response
sub patch
{
    my ($self) = @_;
    $self->error_method_not_allowed();
}

#@returns PWF::Response
sub head
{
    my ($self) = @_;
    $self->error_method_not_allowed();
}

#@returns PWF::Response
sub delete
{
    my ($self) = @_;
    $self->error_method_not_allowed();
}

#@method
sub error_method_not_allowed
{
    require PWF::Response::MethodNotAllowedError;
    die PWF::Response::MethodNotAllowedError->new();
}

1;