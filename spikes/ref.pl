sub ghb() { 
  printf(@_);
}

printf("%s","abc");
my $r=\&ghb;
$r->("%s\n","ssdf");

sub root() {
  return sqrt(shift);
}
my $q=\&root;
print $q->(25)."\n";
print sqrt(25)."\n";

my $a=eval("sqrt(25)");
print $a;
