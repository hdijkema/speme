package scmSExpr;
use scmToken;
use strict;

our @ISA=("scmToken");

sub new() {
  my $class=shift;
  my $obj={};
  bless $obj,$class;

  return $obj;
}

sub linenr() {
	my $self=shift;
	my $nr=shift;
	if (defined($nr)) { 
		$self->{linenr}=$nr;
		if ($self->is_list()) {
			foreach my $el (@{$self->value()}) {
				$el->linenr($nr);
			}
		}
	}
	return $self->{linenr};
}

sub char() {
  my $self=shift;
  my $val=shift;
  $self->{type}="char";
  $self->{val}="\"".$val."\"";
  return $self;
}

sub string() {
  my $self=shift;
  my $val=shift;
  $self->{type}="string";
  $self->{val}="\"".$val."\"";
  return $self;
}

sub comment() {
  my $self=shift;
  my $val=shift;
  $self->{type}="comment";
  $self->{val}=$val;
  return $self;
}

sub boolean() {
  my $self=shift;
  my $val=shift;
  $self->{type}="boolean";
  $self->{val}=($val eq "#f") ? 0 : 1;
  return $self;
}

sub number() {
  my $self=shift;
  my $val=shift;
  $self->{type}="number";
  $self->{val}=$val;
  return $self;
}

sub re() {
  my $self=shift;
  my $re=shift;
  $self->{type}="regexp";
  $self->{val}=$re;
  return $self;
}

sub _and() {
  my $self=shift;
  $self->{type}="and";
  $self->{val}="";
  return $self;
}

sub _do() {
  my $self=shift;
  return $self->sexpr("do",@_);
}

sub define_syntax() {
  my $self=shift;
  return $self->sexpr("define-syntax",@_);
}

sub syntax_rules() {
  my $self=shift;
  return $self->sexpr("syntax-rules",@_);
}

sub _cond() {
  my $self=shift;
  return $self->sexpr("cond",@_);
}

sub _case() {
  my $self=shift;
  return $self->sexpr("case",@_);
}

sub sexpr() {
  my $self=shift;
  my $type=shift;
  my $val=shift;
  $self->{type}=$type;
  if (defined($val)) {
    $self->{val}=$val;
  } else {
    $self->{val}=$type;
  }
  return $self;
}


sub _set() {
  my $self=shift;
  $self->{type}="set!";
  $self->{val}="set!";
  return $self;
}

sub _or() {
  my $self=shift;
  $self->{type}="or";
  $self->{val}="";
  return $self;
}

sub dot() {
  my $self=shift;
  $self->{type}="dot";
  $self->{val}="";
  return $self;
}

sub symbol() {
  my $self=shift;
  my $val=shift;
  $self->{type}="symbol";
  $self->{val}=$val;
  return $self;
}

sub define() {
  my $self=shift;
  $self->{type}="define";
  $self->{val}="";
  return $self;
}

sub _if() {
  my $self=shift;
  $self->{type}="if";
  $self->{val}="";
  return $self;
}

sub perl() {
  my $self=shift;
  my $type=shift;
  $self->{type}="perl";
  $self->{val}=$type;
  return $self;
}

sub defperl() {
  my $self=shift;
  $self->{type}="defperl";
  $self->{val}="";
  return $self;
}

sub _use() {
  my $self=shift;
  $self->{type}="use";
  $self->{val}="";
  return $self;
}

sub _package() {
  my $self=shift;
  $self->{type}="package";
  $self->{val}=shift or "";
  return $self;
}

sub _compile() {
  my $self=shift;
  $self->{type}="compile";
  $self->{val}="";
  return $self;
}

sub _new() {
  my $self=shift;
  $self->{type}="new";
  $self->{val}="new";
  return $self;
}

sub obj_apply() {
  my $self=shift;
  my $kind=shift;
  $self->{type}="->";
  $self->{val}=$kind;
  return $self;
}

sub identifier() {
  my $self=shift;
  my $val=shift;
  $self->{type}="identifier";
  $self->{val}=$val;
  return $self;
}

sub operator() {
  my $self=shift;
  my $val=shift;
  $self->{type}="operator";
  $self->{val}=$val;
  return $self;
}

sub list() {
  my $self=shift;
  $self->{type}="list";
  $self->{val}=\@_;
  #print "list=".$self->{val}."\n";
  return $self;
}

sub _die() {
  my $self=shift;
  $self->{type}="die";
  $self->{val}="";
  return $self;
}

sub lambda() {
  my $self=shift;
  $self->{type}="lambda";
  $self->{val}="";
  return $self;
}

sub begin() {
  my $self=shift;
  $self->{type}="begin";
  $self->{val}="";
  return $self;
}

sub let() {
  my $self=shift;
  $self->{type}="let";
  $self->{val}="";
  return $self;
}

sub eq_V_() {
  my $self=shift;
  $self->{type}="eq?";
  $self->{val}="";
  return $self;
}

sub is_eq_V_() {
  return is_type(@_,"eq?");
}

sub is_list() {
  return is_type(@_,"list");
}

sub is_begin() {
  return is_type(@_,"begin");
}

sub is_let() {
  return is_type(@_,"let");
}

sub is_perl() {
  return is_type(@_,"perl");
}

sub is_defperl() {
  return is_type(@_,"defperl");
}

sub is_if() {
  return is_type(@_,"if");
}

sub is_new() {
  return is_type(@_,"new");
}

sub is_die() {
  return is_type(@_,"die");
}

sub is_obj_apply() {
  return is_type(@_,"->");
}

sub is_use() {
  return is_type(@_,"use");
}

sub is_package() {
  return is_type(@_,"package");
}

sub is_compile() {
  return is_type(@_,"compile");
}

sub is_lambda() {
  return is_type(@_,"lambda");
}

sub is_operator() {
  return is_type(@_,"operator");
}

sub is_string() {
  return is_type(@_,"string");
}

sub is_comment() {
  return is_type(@_,"comment");
}

sub is_symbol() {
  return is_type(@_,"symbol");
}

sub is_number() {
  return is_type(@_,"number");
}

sub is_boolean() {
  return is_type(@_,"boolean");
}

sub is_char() {
  return is_type(@_,"char");
}

sub is_identifier() {
  return is_type(@_,"identifier");
}

sub is_define() {
  return is_type(@_,"define");
}

sub is_dot() {
  return is_type(@_,"dot");
}

sub is_and() {
  return is_type(@_,"and");
}

sub is_or() {
  return is_type(@_,"or");
}

sub is_set() {
  return is_type(@_,"set!");
}

sub is_do() {
  return is_type(@_,"do");
}

sub is_cond() {
  return is_type(@_,"cond");
}

sub is_case() {
  return is_type(@_,"case");
}

sub is_define_syntax() {
  return is_type(@_,"define-syntax");
}

sub is_syntax_rules() {
  return is_type(@_,"syntax-rules"); 
}

sub is_atom() {
  my $self=shift;
#  print "in is_atom: ".$self->{type}."\n";
  return $self->is_number() || $self->is_string() || $self->is_symbol() || $self->is_boolean() || $self->is_char() || $self->is_re();
}

sub is_re() {
  return is_type(@_,"regexp");
}

sub is_type() {
  my $self=shift;
  my $t=shift;
  return $t eq $self->{type};
}

sub type() {
  my $self=shift;
  return $self->{type};
}

sub value() { 
  my $self=shift;
  return $self->{val};
}

sub set() {
  my $self=shift;
  my $val=shift;
  $self->{val}=$val;
}

# This sub is only for syntax rules.
sub genCode() {
  my $self=shift;
  if ($self->is_list()) {
    my $res="new scmSExpr()->list(";
    my $comma="";
    foreach my $el (@{$self->value()}) { 
       my $c=$el->genCode();
       $res.="$comma$c";
       $comma=",";
    }
    return $res.")";
  } else {
	return "new scmSExpr()->generic(\"".$self->type()."\",\"".escape($self->value())."\")";
  }
}

my $id=0;
sub gen_id() {
	$id+=1;
	return "gen_$id";
}

sub escape($) {
	my $a=shift;
	$a=~s/["]/\\"/g;
	return $a;
}

sub generic() {
  my $self=shift;
  my $type=shift;
  my $val=shift;
  $self->{type}=$type;
  $self->{val}=$val;
  return $self;
}

1;
