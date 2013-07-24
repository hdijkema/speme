use File::Glob qw(:glob);

my $a=\bsd_glob("*");
print "a=$a\n";
print "aa=${$a}\n";
print "aaa=@{${$a}}\n";

$a=0;$a=$a+1;print "a:",\$_,"-",$_,"\n";
bsd_glob("~/PDF/*.pdf");print "glob:",\$_,"-",$_,"\n";

print ref(\3);
print ref(\@{[2,3,4]});

my $q1=\func1();
my $q2=\func2();

print "\n";
print "q1=$q1, q2=$q2\n";

sub func1
{
    return ('foo', 'bar', 'baz');
}

sub func2
{
    my @array = ('foo', 'bar', 'baz');
    return @array;
}
