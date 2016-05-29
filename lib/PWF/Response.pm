package PWF::Response;
use strict;
use warnings FATAL => 'all';
use Carp qw/confess/;
use PWF::HTTP::Status;

sub new
{
    my ($proto, %kwargs) = @_;

    $kwargs{status} //= HTTP_OK;
    $kwargs{headers} //= [ ];
    $kwargs{content} //= [ ];

    return bless { %kwargs }, $proto;
}

#@returns PWF::Response
sub set_status
{
    my ($self, $new_status) = @_;
    $self->{status} = $new_status;
    return $self;
}

sub get_status
{
    my ($self) = @_;
    return $self->{status};
}

sub get_headers
{
    my ($self) = @_;
    return $self->{headers};
}

sub get_content
{
    my ($self) = @_;
    return $self->{content};
}

sub get_psgi_response
{
    my ($self) = @_;
    return [
        $self->get_status,
        $self->get_headers,
        $self->get_content,
    ];
}

1;