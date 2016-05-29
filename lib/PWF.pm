package PWF;
use strict;
use warnings FATAL => 'all';
use Module::Load;
use Carp qw/cluck/;
use PWF::Response::InternalServerError;
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
    return sub{
        return PWF::Response::InternalServerError->new()->get_psgi_response();
    };
}

1;