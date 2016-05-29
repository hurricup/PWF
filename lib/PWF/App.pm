package PWF::App;
use strict;
use warnings FATAL => 'all';
# this is a base class for Applications

sub new
{
    my ($proto) = @_;
    return bless {}, $proto;
}

#@method
sub get_runner
{
    return sub{
        return [
            200,
            ['Content-Type' => 'text/plain'],
            ['Here we go']
        ];
    };
}

1;