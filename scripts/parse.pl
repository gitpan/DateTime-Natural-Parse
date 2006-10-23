#!/usr/bin/perl

use strict;
use warnings;

use DateTime::Natural::Parse qw(natural_parse);

while (1) {
    print 'Input date string: ';
    chomp(my $input = <STDIN>);
    my $dt = natural_parse($input);
    printf("%02s.%02s.%4s %02s:%02s\n", $dt->day, $dt->month, $dt->year, $dt->hour, $dt->min);
}
