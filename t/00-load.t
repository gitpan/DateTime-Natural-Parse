#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

BEGIN {
	use_ok('DateTime::Natural::Parse');
}

diag("Testing DateTime::Natural::Parse $DateTime::Natural::Parse::VERSION, Perl $], $^X");
