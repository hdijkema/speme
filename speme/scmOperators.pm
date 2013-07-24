package scmOperators;
use strict;
use Exporter;
use vars qw(@ISA @EXPORT @EXPORT_OK $VERSION);
use Scalar::Util qw(blessed looks_like_number);
use scmRegExp;
use Data::Dumper;
use scmSymbol;
$Data::Dumper::Purity = 1; 

$VERSION = '0.1';

@ISA = qw/ Exporter /;
@EXPORT = qw($scm__d_ $scm__S_ $scm__P_ $scm__M_ 
             $scm_print $scm_println $scm_car $scm_cdr $scm_set_M_car_E_
             $scm_string_V_ $scm_char_V_ $scm_number_V_ $scm_symbol_V_ perl_is_symbol $scm_syntax_V_ perl_is_syntax $scm_scalar_V_
             cons $scm_cons $scm_list list
             $scm__L_ $scm__G_ $scm__L__Q_ $scm__Q_ $scm__G__Q_
             $scm_not $scm_length
             $scm__slt $scm__seq $scm_str_cat
             $scm_perl_hn $scm_perl_hp $scm_perl_hg $scm_perl_he $scm_perl_is_h $scm_perl_hr $scm_perl_h_keys $scm_perl_h_each
             $scm_vector $scm_perl_vn $scm_perl_vp $scm_perl_vg $scm_perl_vl $scm_perl_is_v $scm_perl_vl
             $scm_typeof typeof
		     $scm_system
		     perl_is_eq_V_  perl_is_eqv_V_ $scm_eqv_V_
		     $scm_raise_M_error
		     $scm_mkprint $scm_tostring
		     $scm_apply
		     perl_re_match perl_re_replace perl_re $scm_perl_M_re_M_replace $scm_perl_M_re_M_match $scm_perl_M_re $scm_regexp_V_
		     perl_set_argv $scm_ARGV;
		     scm_check_list
		     );
             #$scm_load $scm_compile

sub mtime($) {
  my $file=shift;
  my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks) = stat($file);
  return $mtime;
}

#sub bool($) {
#  return $[0];
  #my $b : bool=shift;
  #return $b;
#}

our $scm__S_=sub {
  my $res;
  $res=shift(@_);
  foreach my $e (@_) {
    $res*=$e;
  }
  return $res;
};

our $scm__P_=sub {
  my $res=0;
  foreach my $e (@_) {
    $res+=$e;
  }
  return $res;
};

our $scm__M_=sub {
  my $res=shift;
  foreach my $e (@_) {
    $res-=$e;
  }
  return $res;
};

our $scm__d_=sub {
  my $res=shift;
  foreach my $e (@_) {
    $res/=$e;
  }
  return $res;
};

our $scm__Q_=sub { return applst(sub { my ($a,$b)=@_; return $a==$b; },@_); };
our $scm__L_=sub { return applst(sub { my ($a,$b)=@_; return $a<$b; },@_); };
our $scm__G_=sub { return applst(sub { my ($a,$b)=@_; return $a>$b; },@_); };
our $scm__G__Q_=sub { return applst(sub { my ($a,$b)=@_; return $a>=$b; },@_); };
our $scm__L__Q_=sub { return applst(sub { my ($a,$b)=@_; return $a<=$b; },@_); };

our $scm_not=sub { return not(shift); };

sub applst {
  my ($f,$res,$r1)=@_;
  if ($f->($res,$r1)) {
    shift;shift;
    if (scalar(@_)==1) {
      return 1;
    } else {
      return applst($f,@_);
    }
  } else {
    return 0;
  }
}


sub perl_list_to_scm_list {
	return list(@_);
}

sub scm_list_to_perl_list {
	my $e=shift;
	if (ref($e) eq "ARRAY") {
		my @l=@{$e};
		my $car=shift @l;
		my @r=scm_list_to_perl_list(shift @l);
		unshift @r,$car;
		return @r;
	} else {
		return ();
	}
}

sub apply {
	my $proc=shift;
	my $list=shift;
	return $proc->(scm_list_to_perl_list($list));
}

our $scm_apply=\&apply;

sub fixpoint { &{$_[0]}(@_) }	# Yep, it does look like @#&$!

sub nullp {
  return (ref($_[0]) eq "ARRAY") && (scalar(@{$_[0]})==0);
}

sub pairp {
  return ref($_[0]) eq "ARRAY";
}

our $scm_print;

sub printval { 
  my ($prefix, $val) = @_;
  return mkprint($prefix).mkprint($val);
}

sub printl {			# printl List -> ?
  my ($list) = @_;

  if (nullp($list)) { return "()"; }
  if (not(pairp($list))) { return "$list"; }

  return printval( "(",car($list) ).
         fixpoint(
            sub { my ($self, $list) = @_;
                  if (nullp($list)) { return ")"; }
                  else { return 
                           (not(pairp($list))) ?
	                      ( printval(" . ",$list).")" ) :
	                      ( printval(" ", car($list)).&$self($self,cdr($list))); 
                       }
                }
            ,cdr($list)
        );
}

sub printv {
  my $v=shift;
  my $R="#(";
  my $l=scalar(@{$v});
  my $space="";
  for(my $i=0;$i<$l;$i++) {
     $R.=$space.mkprint($v->[$i]);
     $space=" ";
  }
  $R.=")";
  return $R;
}

sub mkprint {
  my $space="";
  my $res="";
  foreach my $e (@_) {
  	#print $e,"\n";
    $res.=$space;
    if (pairp($e)) { $res.=printl($e); }
    elsif (perl_is_v($e)) { $res.=printv($e); }
    elsif (perl_is_symbol($e)) { $res.=$e->get(); }
    elsif (perl_is_regexp($e)) { $res.=$e->tostring(); }
    elsif (perl_is_syntax($e)) { $res.="#syntax:".$e->name(); }
    else { $res.="$e"; }
    $space=" ";
  }
  return $res;
}

our $scm_mkprint=\&mkprint;
our $scm_tostring=\&mkprint;

$scm_print=sub {
  print mkprint(@_);
};

our $scm_println=sub {
  $scm_print->(@_);
  print "\n";
};

sub car {
  return ${$_[0]}[0];
}

sub cdr {
  #print "cdr:".scalar(@{$_[0]})."\n";
  #if (scalar(@{$_[0]})>2) {
  #  return cdr(list(@{$_[0]}));
  #} else {
    return ${$_[0]}[1];
  #}
}

our $scm_car=\&car;
our $scm_cdr=\&cdr;

our $scm_number_V_=sub {
  return typeof(@_) eq "scalar";
};

our $scm_string_V_=sub {
  return typeof(@_) eq "scalar";
};

our $scm_char_V_=sub {
  return (typeof(@_) eq "scalar") && (length($_[0])==1);
};

our $scm_scalar_V_=sub {
  return typeof(@_) eq "scalar";
};

sub perl_is_symbol {
  return typeof(@_) eq "scmSymbol";
}
our $scm_symbol_V_=\&perl_is_symbol;

sub perl_is_regexp {
 return typeof(@_) eq "scmRegExp";
}
our $scm_regexp_V_=\&perl_is_regexp;

sub perl_is_syntax {
  my ($a)=@_;
  return (blessed($a) ? ((blessed($a) eq "scmSyntax") ? 1 : 0) : 0);
}
our $scm_syntax_V_=\&perl_is_syntax;

sub perl_is_eq_V_ {
  if (scalar(@_)<=1) { 
  	return 1; 
  } else { 
  	#print "eq?: ",$_[0]," - ",$_[1],"\n";
  	if ($_[0] eq $_[1]) {
  		shift;
  		return perl_is_eq_V_(@_);
  	} else {
  		return 0;
  	}
  }
}

sub perl_is_eqv_V_ {
  return perl_is_eq_V_(@_);
}

our $scm_eqv_V_=\&perl_is_eqv_V_;

#######################################################
# list base operations
########################################################

sub cons {
  my @x=@_;return \@x;
}
our $scm_cons=\&cons;

my $emptylist=[];
sub list {
  my $x=shift;
  if (defined($x)) {
     return cons($x,list(@_));
  } else {
     return $emptylist;
  }
}
our $scm_list=\&list;

our $scm_set_M_car_E_=sub {
  my ($l,$v)=@_;
  $l->[0]=$v;
};

our $scm_length=sub {
  my ($l)=@_;
  my $i=0;
  while (not(nullp($l))) {
     $i+=1;
     $l=cdr($l);
  }
  return $i;
};

########################################################
# String compare base operations
########################################################

our $scm__slt=sub {
  my ($a,$b)=@_;
  return ($a lt $b) ? 1 : 0;
};

our $scm__seq=sub {
  my ($a,$b)=@_;
  return ($a eq $b) ? 1 : 0;
};

########################################################
# Hash base operations
########################################################

sub isDumper($) {
	return substr($_[0],0,8) eq "\$VAR1 = ";
}

our $scm_str_cat=sub {
  my ($a,$b)=@_;
  return $a.$b;
};

our $scm_perl_hn=sub {
  my %hash;
  return \%hash;
};

our $scm_perl_hp=sub {
  my $hash=shift;
  my $k=shift;
  my $v=shift;
  if (ref($v)) { $v=Dumper($v); }
  if (ref($k)) { $k=Dumper($k); }
  $hash->{$k}=$v;
  return $hash;
};

our $scm_perl_hg=sub {
  my $hash=shift;
  my $k=shift;
  if (ref($k)) { $k=Dumper($k); }
  if (exists $hash->{$k}) {
  	my $v=$hash->{$k};
  	if (isDumper($v)) { 
	    return eval("my ".$hash->{$k}.";return \$VAR1;");
    } else {
    	return $hash->{$k};
    }
  } else {
    return new scmSymbol("nil");
  }
};

our $scm_perl_he=sub {
  my $hash=shift;
  my $k=shift;
  if (ref($k)) { $k=Dumper($k); }
  return (exists $hash->{$k});
};

our $scm_perl_is_h=sub {
  return ref(shift) eq "HASH";
};

our $scm_perl_hr=sub {
  my $hash=shift;
  my $k=shift;
  if (ref($k)) { $k=Dumper($k); }
  delete $hash->{$k};
  return $hash;
};

our $scm_perl_h_keys=sub {
  my $hash=shift;
  my @keys=keys(%{$hash});
  my @kkeys;
  foreach my $k (@keys) {
  	if (isDumper($k)) {
	  	my $key=eval("my \$VAR1;$k;return \$VAR1;");
		push @kkeys,$key;
  	} else {
  		push @kkeys,$k;
  	}
  }
  return list(@kkeys);
};

our $scm_perl_h_each=sub {
	my $hash=shift;
	my ($k,$v)=each(%{$hash});
	if (isDumper($k)) { $k=eval("my \$VAR1;$k;return \$VAR1;"); }
	if (isDumper($v)) { $v=eval("my \$VAR1;$v;return \$VAR1;"); }
	return list($k,$v);
};

########################################################
# Vector base operations
########################################################

our $scm_vector=sub {
  my @l=@_;
  my $v=\@l;
  bless $v,"scm_vector";
  return $v;
};

our $scm_perl_vn=sub {
  my $len=shift;
  my $val=shift;
  if (not(defined($val))) { $val=0; }
  my @l;
  for(my $i=0;$i<$len;$i++) {
    push @l,$val;
  }
  my $v=\@l;
  bless $v,"scm_vector";
  return $v;
};

sub perl_is_v {
  my $v=shift;
  if (ref($v) eq "scm_vector") { return 1; } else { return 0; }
};
our $scm_perl_is_v=\&perl_is_v;

our $scm_perl_vg=sub {
  my $v=shift;
  my $index=shift;
  return $v->[$index];
};

our $scm_perl_vp=sub {
  my $v=shift;
  my $index=shift;
  my $val=shift;
  $v->[$index]=$val;
  #${@{$v}}[$index]=$val;
  return $v;
};

our $scm_perl_vl=sub {
  my $v=shift;
  return scalar(@{$v});
};

sub perl_system {
  my $cmd="";
  my $space="";
  foreach my $arg (@_) {
     $cmd.=$space;
     $cmd.=$arg;
     $space=" ";
  }
  return system($cmd);
}

our $scm_system=\&perl_system;

sub is_string($) {

}

sub typeof {
	my $a=shift;
	if (ref($a)) { 
		my ($t,$addr)=split /=/,$a;
		if (substr($t,0,6) eq "ARRAY(") { return "list"; }
		elsif (substr($t,0,5) eq "HASH(")  { return "hash"; }
		else { return $t }
	} else {
		return "scalar";
	}
};

our $scm_typeof=\&typeof;

our $scm_raise_M_error=sub {
	my $function=shift;
	my $msg=shift;
	my ($package, $filename, $line) = caller;
	die "in function '$function': '$msg' in package '$package', file '$filename', line '$line'";
};

##################################################################
# Regexp support
##################################################################

sub perl_re($) {
	my $e=shift;
	return new scmRegExp($e);
}
our $scm_perl_M_re=\&perl_re;

sub perl_re_match($$$) {
	my ($rege,$v,$m)=@_;
	#print $rege,"\n";
	my $re=$rege->re();
	my $ire=$rege->ire();
	
	my @r;
	if ($m eq "g") {
		@r=$v=~/$re/g;
	} elsif (($m eq "gi") || ($m eq "ig")) {
		@r=$v=~/$ire/g;
	} elsif ($m eq "i") {
		@r=$v=~/$ire/;
	} else {
		@r=$v=~/$re/;
	}
	return list(@r);
}
our $scm_perl_M_re_M_match=\&perl_re_match;

sub perl_re_replace($$$$) {
	my ($rege,$v,$repl,$m)=@_;
	#print $rege,"\n";
	my $re=$rege->re();
	my $ire=$rege->ire();
	if ($m eq "g") {
		$v=~s/$re/$repl/g;
		return $v;
	} elsif (($m eq "gi") || ($m eq "ig")) {
		$v=~s/$ire/$repl/g;
		return $v;
	} elsif ($m eq "i") {
		$v=~s/$ire/$repl/;
		return $v;
	} else {
		$v=~s/$re/$repl/;
		return $v;
	}
}
our $scm_perl_M_re_M_replace=\&perl_re_replace;

##################################################################
# ARGV support
##################################################################

use vars qw($scm_ARGV);
$scm_ARGV=perl_list_to_scm_list();

sub perl_set_argv {
	$scm_ARGV=perl_list_to_scm_list(@_);
}

##################################################################
# Result checking
##################################################################

sub scm_check_list {
	#print scalar(@_),"\n";
	#print "0=$_[0]\n";
	#if (ref($_[0]) eq "ARRAY") {
	#	my $q=list(@{$_[0]});
	#	return \$q;
	#} else {
	#	return $_[0];
	#}
	if (scalar(@_)>1) {
		my $q=list(@_);
		return \$q;
	} else {
		return \$_[0];
	}
}

1;

