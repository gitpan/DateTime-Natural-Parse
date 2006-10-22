package DateTime::Natural::Parse;

use strict;
use warnings;
use base qw(Exporter);

our ($VERSION, @EXPORT_OK);

$VERSION = '0.01';
@EXPORT_OK = qw(natural_parse);

sub natural_parse {
    my ($date_string, $opts) = @_;
	
    no strict 'refs';
    my $DEBUG = $opts->{debug};

    my @tokens = split ' ', $date_string;
    my $buffer = '';

    my ($sec, $min, $hour, $day, $month, $year, $wday, $yday) = localtime;
    $month++; $year += 1900;

    foreach my $token (@tokens) {
        print "$token\n" if $DEBUG;

        my %days = (Tomorrow  => 'day plus 1',
                    Yesterday => 'day minus 1',
                    Today     => 'day');

        my %weekdays = (Monday    => 1,
	                Tuesday   => 2,
		        Wednesday => 3,
		        Thursday  => 4,
		        Friday    => 5,
		        Saturday  => 6,
		        Sunday    => 0);

        my %months = (January   => 1,
             	      February  => 2,
	              March     => 3,
        	      April     => 4,
	              May       => 5,
	              June      => 6,
	              July      => 7,
	              August    => 8,
	              September => 9,
	              October   => 10,
	              November  => 11,
	              December  => 12);
        
        my %monthdays = (1  => 31,
             	         2  => 28,
	                 3  => 31,
        	         4  => 30,
	                 5  => 31,
	                 6  => 30,
	                 7  => 31,
	                 8  => 31,
	                 9  => 30,
	                 10 => 31,
	                 11 => 30,
	                 12 => 31);
	
        if ($token =~ /^(?:morning|evening)$/) {
	    if ($token eq 'morning') {
	        $hour = '08';
	    } else {
	        $hour = '20';
	    }
	    $min = '00';
        }

        if ($token eq 'at') {
	    next;
        } elsif ($token =~ /^(\d{1,2})(:\d{2}|am|pm)$/) {
            my $hour_token = $1; my $min_token = $2;
	    if ($min_token =~ /:/) {
	        $hour = $hour_token; 
	        $min_token =~ s!:!!;
	        $min  = $min_token;
	    } elsif ($min_token =~ /(am|pm)/) {
	        if ($min_token eq 'pm') {
                    $hour_token += 12;
	        }
	        $hour = $hour_token;
	        $min  = '00';
	    }
        }
    
        if ($token =~ /^(\d{1,2})(?:st|nd|rd|th)$/) {
	    $day = $1;
        }

        foreach my $key_month (keys %months) {
	    if ($token =~ /$key_month/i) {
	        $month = $months{$key_month};
	        last;
	    }
        }

        if ($token eq 'this') {
	    $buffer = 'this';
	    next;
        } elsif ($buffer eq 'this') {
            foreach my $key_weekday (keys %weekdays) {
                if ($token =~ /$key_weekday/i) {
	            my $days_diff = $weekdays{$key_weekday} - $wday;
	            $day += $days_diff;
	        }
            }
        }

	if ($token eq 'next') {
	    $buffer = 'next';
	    next;
	} elsif ($buffer eq 'next') {
	    foreach my $key_weekday (keys %weekdays) {
	        if ($token =~ /$key_weekday/i) {
		    my $days_diff = (7 - $wday) + $weekdays{$key_weekday};
		    $day += $days_diff;
		    if ($day > $monthdays{$month}) {
		        my $days_next_month = $day - $monthdays{$month};
			$month++; $day = $days_next_month;
		    }
		}
            }
	}	   
	
        if ($token eq 'last') {
	    $buffer = 'last';
	    next;
	} elsif ($buffer eq 'last') {
	    foreach my $key_weekday (keys %weekdays) {
	        if ($token =~ /$key_weekday/i) {
		    my $days_diff = $wday + (7 - $weekdays{$key_weekday});
		    $day -= $days_diff;
		}
	    }
	}
	
        foreach my $key_day (keys %days) {
            if ($token =~ /$key_day/i) {
                my $dostr = $days{$key_day};

                my ($var, $op, $val) = $dostr =~ /(.*?) (.*?) (.*)/;
                if (defined($var) && defined($op) && defined($val)) {
                    if ($op eq 'plus') {
                        $day += $val;
                    } elsif ($op eq 'minus') {
                        $day -= $val;
                    }
                }
            }
        }
    }

    $sec   = "0$sec"   unless length($sec)   == 2;
    $min   = "0$min"   unless length($min)   == 2;
    $hour  = "0$hour"  unless length($hour)  == 2;
    $day   = "0$day"   unless length($day)   == 2;
    $month = "0$month" unless length($month) == 2;

    return "$day.$month.$year $hour:$min\n";
}

1;
__END__

=head1 NAME

DateTime::Natural::Parse - Create machine readable time with natural parsing logic

=head1 SYNOPSIS

 use DateTime::Natural::Parse qw(natural_parse);

 print natural_parse($date_string);

=head1 DESCRIPTION

C<DateTime::Natural::Parse> exports a function, natural_parse(), by default which takes a
string with human readable time and creates a machine readable one by applying natural
parsing logic.

This documentation will be further extended to include the details of valid human
readable input grammar.

Meanwhile, L<http://www.rubyinside.com/chronic-natural-date-parsing-for-ruby-229.html>
serves some example input.

=head1 AUTHOR

Steven Schubiger <schubiger@cpan.org>

=head1 LICENSE

This program is free software; you may redistribute it and/or 
modify it under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>	    

=cut
