#!/usr/bin/perl
use strict;

my $set=sub { my $variable_ref=shift;my $construct=shift; ${$variable_ref}=eval { $construct->(); } };

my $a;
$set->(\$a,sub { return [ 10,20,30 ]; });

print "@{$a}\n";

