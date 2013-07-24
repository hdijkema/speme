use strict;

my $a=sub { my $b=shift; my $c=shift; my $d=shift; return $b->($c)*$d; };
my $b=sub { my $q=shift; return $q*$q; };

print $a->($b,5,4)."\n";
print $a->($b,9,8)."\n";

