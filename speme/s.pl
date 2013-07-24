use strict;
use ss;

print "scm_stdout=$scm_stdout\n";
print "scm_q=$scm_q\n";
print "a=$a\n";
print "b=$b\n";

my $s='"abcde"';
my $b='"ab\\"cd"';

print "s=$s\n";
print "b=$b\n";

print f($s),"\n";
print f($b),"\n";
print f("erf\"ed\"es"),"\n";

sub f($) {
  my $s=shift;
  my $w=($s=~/(["](\\["]|[^"])*["])/);
  return $1;
}
