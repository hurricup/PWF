package PWF::ResponseWrapper;
use strict;
use warnings FATAL => 'all';
use Carp qw/confess/;

# the main reason for this class is to wrap potentially dangerous operations into object.
# if some response-generation fails, we can catch it in app and process
sub new
{
    my ($proto, $data) = @_;
    return bless $data, $proto;
}

# this method make only safest operations, because it's errors won't be handled in any way
#@method
sub process_response
{
    confess 'get_response method was not implemented in '.shift;
}

1;