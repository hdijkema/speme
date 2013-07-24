use Operators;
use ReadEvalPrint;

sub f() {
  return 8*8;
};

my $a=\&f;
my $b="$a";
print "$b\n";

print \&f,"\n";

print \&load,"\n";

print \&froot,"\n";

sub def {
  my $x=shift;
  if (defined($x)) {
    return 1;
  } else {
    return 0;
  }
}

print defined(&load)."\n";
print defined(&f)."\n";

eval("&groot");
print $@."\n";
eval("&f");
print $@."\n";
eval("\\&dons");
print "checked dons:".$@."\n";
eval("\\&cons");
print "checked cons:".$@."\n";
print cons(4,[])."\n";

