!/usr/bin/perl
#File: project1_2.pl
#Name: Casey Grove
#Email: caseg1@umbc.edu
#
# Find and replace all instances of valid Visa, MasterCard,
# or American Express card numbers with '...' followed by
# the last 4 numbers. The number must not be surrounded by
# a word character.

use strict;
use warnings;

open(my $fh, '<', './data/card_data.txt');
while (my $row = <$fh>) {
    chomp $row;

    #AMEX 34/37 start; 15 digits
    $row =~ s/(?<!\w)3(4|7)([0-9]{9})([0-9]{4})(?!\w)/...$3/g;

    #Discover 65/6011 start; 16 digits
    $row =~ s/(?<!\w)65([0-9]{10})([0-9]{4})(?!\w)/...$2/g;
    $row =~ s/(?<!\w)6011([0-9]{8})([0-9]{4})(?!\w)/...$2/g;
    
    #MasterCard 51 through 55 start; 16 digits
    $row =~ s/(?<!\w)5([1-5])([0-9]{10})([0-9]{4})(?!\w)/...$3/g;

    #Visa 4 start; 13 or 16 digits
    $row =~ s/(?<!\w)4([0-9]{8})([0-9]{4})(?!\w)/...$2/g;
    $row =~ s/(?<!\w)4([0-9]{11})([0-9]{4})(?!\w)/...$2/g;
    
    print "$row\n";    
}
close $fh
