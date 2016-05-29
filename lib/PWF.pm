package PWF;
use strict;
use warnings FATAL => 'all';
use Module::Load;
use Carp qw/cluck/;
use PWF::App;

sub start_app
{
    my $self = shift;
    my PWF::App $app_class = shift;

    eval {Module::Load::load($app_class)};
    if( my $e = $@ )
    {
        cluck $e;
        return $self->get_error_responder;
    }
    elsif( !UNIVERSAL::isa($app_class, 'PWF::App'))
    {
        cluck "$app_class must be a descendant of PWF::App";
        return $self->get_error_responder;
    }
    else
    {
        return $app_class->new()->get_runner();
    }
}

#@method
sub get_error_responder
{
    require PWF::Response::InternalServerError;
    require PWF::ResponseWrapper::PSGI;
    return sub{
        return PWF::ResponseWrapper::PSGI->new( PWF::Response::InternalServerError->new() )->process_response;
    };
}

1;