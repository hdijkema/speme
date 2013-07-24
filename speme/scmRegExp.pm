package scmRegExp;

sub new {
	my $class=shift;
	my $expr=shift;
	
	my $obj={};
	bless $obj,$class;
	
	$obj->set_re($expr);
	
	return $obj;
}

sub re() {
	my $self=shift;
	return $self->{re};
}

sub ire() {
	my $self=shift;
	return $self->{ire};
}

sub set_re() {
	my ($obj,$expr)=@_;
	$obj->{re}=qr/$expr/;
	$obj->{ire}=qr/(?i)$expr/;
}

sub tostring() {
	my $obj=shift;
	return $obj->{re};
}

1;
