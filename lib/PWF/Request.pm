package PWF::Request;
use strict;
use warnings FATAL => 'all';

sub new
{
    my ($proto, $env) = @_;
    return bless{
            env => { %$env },
        }, $proto;
}

sub get_env
{
    my ($self) = @_;
    return $self->{env};
}

1;