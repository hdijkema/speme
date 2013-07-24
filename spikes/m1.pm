package m1;
use strict;

my $y=0;

sub set_y {
  $y=shift;
  print "y=$y\n";
}

sub macro() {
  eval { return sub { my $var=shift;print "y=$y, var=$var\n";return $y*$var; } };
}

1;
