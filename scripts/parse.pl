#!/usr/bin/perl

use strict;
use warnings;

use DateTime::Natural::Parse qw(natural_parse);

while (1) {
    print 'Input date string: ';
    chomp(my $input = <STDIN>);
    print natural_parse($input);
}
