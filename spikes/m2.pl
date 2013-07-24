use m1;
use strict;

my $y=1;
my $f=m1::macro();
print $f->(10),"\n";
m1::set_y(5);
print $f->(10),"\n";
my $g=m1::macro();
m1::set_y(2);
print $g->(10),"\n";
print $f->(10),"\n";
