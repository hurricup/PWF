package PWF;
use strict;
use warnings FATAL => 'all';
use Module::Load;
use Carp qw/cluck/;

sub start_app
{
    my ($self, $app_class) = @_;
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
        return [
            500,
            ['Content-Type' => 'Something went wrong...'],
            ['Something bad happened...']
        ];
    };
}

1;