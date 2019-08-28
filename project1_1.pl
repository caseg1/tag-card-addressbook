!/usr/bin/perl
#File: project1_1.pl
#Name: Casey Grove
#Email: caseg1@umbc.edu
#
# Print XML heading tag lines from proj1_1_data.txt
# Valid tags are author, title, genre, price, publish_data, description
# Tags are case insensitive, contain arbitrary content
# Can assume '<' or '>' will not appear inside attribute's value portion
#  Print the first name of the author before the last name
#  Date should be 10/1/2000
#  Title should be enclosed in ""

use strict;
use warnings;

open(my $fh, '<', './data/proj1_1_data.txt');
while (my $row = <$fh>) {
    chomp $row;

    print "$4 $2 " if $row =~ /(<author>)(\w+)(,\s)(\w+)(<\/author)/;
    print "\"$2\" " if $row =~ /(<title>)(.*)(<\/title)/;
    print "$2 " if $row =~ /(<genre>)(.*)(<\/genre)/;
    print "$2 " if $row =~ /(<price>)(.*)(<\/price)/;
    #remove leading zeroes on days and month
    print "$3\/$4\/$2 " if $row =~ /(<publish_date>)(.*)-0*([1-9][0-9]*)-0*([1-9][0-9]*)(<\/publish_date)/;
    print "$2 \n" if $row =~ /(<description>)(.*)(<\/description)/;
    
}
close $fh;
