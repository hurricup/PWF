#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use FindBin;
use lib "$FindBin::Bin/../lib", "$FindBin::Bin/../site";
use PWF;
return PWF->start_app('TestSite::App');
