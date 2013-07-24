use scmCore;
use DBI;
use strict;
use Data::Dumper;
$Data::Dumper::Purity = 1; 

print "DBI=".\%DBI::,"\n";
my $a=(%DBI::) ? "a" : "b";
print "$a\n";
$a=(%Gtk::) ? "yesgtk" : "nogtk";
print "$a\n";
my $DBI=0;

#my $dbh=$DBI::{connect}->("DBI","dbi:SQLite:dbname=hans","","");
my $dbh="DBI"->connect("dbi:SQLite:dbname=hans","","");
print "$dbh\n";

print Dumper("k");
my $obj={};
$obj->{"a"}=20;
print Dumper($obj);

print log(20),"\n";
sub fw {
  return log(shift);
}
my $b=sub { return fw(@_); };
print $a->(20),"\n";
print $b->(20),"\n";

my $code="sub { if (defined(\$aaa)) { return \$aaa; } else { return undef; } }->();";
my $res=eval $code;

my $r=[0,2];
print $r,"\n";
print ref($r),"\n";

if (defined($a)) {
  print "ok!\n";
} else {
  print "nok!\n";
}

print \&close,"\n";
