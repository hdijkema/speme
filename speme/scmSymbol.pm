package scmSymbol;
use strict;

my %symbols;


sub new {
	my $class=shift;
	#my $obj=shift;
	my $val=shift;
	my $obj;
	if (exists($symbols{$val})) {
		$obj=$symbols{$val};
	} else {
		$obj={};
		bless $obj,$class;
		$obj->{val}=$val;
		$symbols{$val}=$obj;
	}
	#print "symbol:obj=$obj, ",$obj->{val},"\n";
	return $obj;
}

sub get {
	my $self=shift;
	return $self->{val};
}

sub tostring() {
	my $self=shift;
	return $self->{val};
}

1;
