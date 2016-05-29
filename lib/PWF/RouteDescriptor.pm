package PWF::RouteDescriptor;
use strict;
use warnings FATAL => 'all';
# class represents routing descriptor. If rule is match, get_response should be able to return response
use Carp qw/confess/;

sub new
{
    my ($proto, $condition, $handler) = @_;
    return bless {
            condition => $condition,
            handler   => $handler,
        }, $proto;
}


sub get_handler
{
    my $self = shift;
    return $self->{handler};
}
sub get_condition
{
    my $self = shift;
    return $self->{condition};
}
sub matches
{
    my $self = shift;
    my PWF::Request $request = shift;
    my $request_uri = $request->get_env->{REQUEST_URI};
    my $condition = $self->get_condition;
    my $ref = ref $condition;

    if ($ref eq 'Regexp' && $request_uri =~ $condition)
    {
        return { %+ };
    }
    elsif ($ref eq 'CODE' && (my $result = $condition->( $request )))
    {
        return $result;
    }
    elsif ($request_uri eq $condition)
    {
        return { };
    }
    return;
}

#@returns PWF::Response
sub get_response
{
    my $self = shift;
    my PWF::Request $request = shift;
    my $match_data = $self->matches( $request );
    return unless $match_data;
    return $self->calc_response( $request );
}

#@returns PWF::Response
sub calc_response
{
    my $self = shift;
    my PWF::Request $request = shift;
    confess 'calc_response is not implemented in '.$self;
}

1;