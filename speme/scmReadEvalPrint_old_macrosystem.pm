package scmReadEvalPrint;

use strict;
use scmToken;
use scmSExpr;
use scmOperators;
use scmCompiler;
use scmSyntax;
use Term::ReadLine;
use scmSymbol;
use scmDebug;

use Exporter;
use vars qw(@ISA @EXPORT @EXPORT_OK $VERSION);

$VERSION = '0.1';

@ISA = qw/ Exporter /;
@EXPORT = qw(set_eval_func set_qeval_func do_eval set_macro);


##############################################################
# evaluation functions to the top level perl environment
##############################################################

our $EVAL_FUNC=undef;
our $QEVAL_FUNC=undef;

sub do_eval($) {
  $EVAL_FUNC->(shift);
}

sub do_qeval($) {
  $QEVAL_FUNC->(shift);
}

sub set_qeval_func($) {
  my $f=shift;
  $QEVAL_FUNC=$f;
}

sub set_eval_func($) {
  my $f=shift;
  $EVAL_FUNC=$f;
}

##############################################################
# read eval print constructor
##############################################################

sub new() {
  my $class=shift;
  my $fin=shift;
  my $obj={};
  bless $obj,$class;
  $obj->{fin}=$fin;
  $obj->{str}="";
  my @defines;
  $obj->{defines}=\@defines;
  $obj->{name}="PERL";
  $obj->{define}="<nil>";
  $obj->{linenr}=0;
  $obj->{scm_name}="GLOBAL";
  $obj->{hygienic_ids}=undef;

  if (not(defined($fin))) {
    $obj->{term}=new Term::ReadLine("Perl Scheme");
    eval { $obj->{term}->ReadHistory($obj->historyFile()); };
  }

  $obj->{eeof}=0;
  $obj->{level}=0;

  return $obj;
}

sub DESTROY() {
  my $self=shift;
  if (defined($self->{term})) {
    $self->{term}->WriteHistory($self->historyFile());
  }
}

sub historyFile() {
  my $self=shift;
  my $home=$ENV{HOME};
  return "$home/.perl_scm_history";
}

##############################################################
# support functions
##############################################################

sub set_compile_handle() {
  my $self=shift;
  my $fh=shift;
  $self->{compile}=$fh;
  #debug "set_compile_handle:$fh\n";
}

sub set_name() {
  my $self=shift;
  my $name=shift;
  $self->{name}=$name;
}

sub name() {
  my $self=shift;
  return $self->{name};
}

sub scm_name() {
  my $self=shift;
  my $nm=$self->{scm_name};
  return $nm;
}

sub set_scm_name() {
  my $self=shift;
  my $nm=shift;
  $self->{scm_name}=$nm;
}

sub define() {
  my $self=shift;
  return $self->{define};
}

sub linenr() {
  my $self=shift;
  return $self->{linenr};
}

sub set_define() {
	my ($self,$def)=@_;
	debug("define=$def\n");
	$self->{define}=$def;
}

sub set_linenr() {
	my ($self,$nr)=@_;
	$self->{linenr}=$nr;
}


##############################################################
# read eval print loop
##############################################################

sub readEvalLoop() {
   my $self=shift;
   my $initialCommand=shift;
   if ($initialCommand) { 
   		$self->{line_provider}=sub { my $cmd=$initialCommand;$initialCommand=undef;return $cmd; };
		$self->internalReadEvalPrint(); 
	    if ($@) { print "Error: $@";$self->{level}=0; }
	    $self->{line_provider}=undef;
   }
   $self->internalReadEvalPrint();
   if ($@) { print "Error: $@";$self->{level}=0; }
}

sub internalReadEvalPrint() {
  my $scm=shift;
  while (my $expr=$scm->read()) {
    #print "expr=$expr\n";
    my $e=$scm->evaluate($expr).";";
    #print "e=$e\n";
    my $fh=$scm->{compile};
    my $name=$scm->{name};
    #debug "$name=$fh\n";
    if (defined($scm->{compile})) {
      my $fh=$scm->{compile};
      print $fh "$e\n";
    } else {
      #print "$e\n";
    }
    #print "e=$e\n";
    my $res=$EVAL_FUNC->($e);
    #print "res=$res\n";
    if ($scm->term()) {
      $scm_println->($res);
    }
  }
}


sub term() {
  my $self=shift;
  return defined($self->{term});
}

sub read() {
  my $self=shift;
  my $fin=$self->{fin};

  my $token = $self->next_token();
  return undef unless defined $token;

  if ($token->is_symbol()) {
    my $sexpr=$self->read();
    $token->set($sexpr);
    return $token;
  } else {
    return $token unless $token->is_open();

    my @res = ();
 
    while (1) {
      $token = $self->read();
      die "unexpected EOF" if !defined $token;
      last if $token->is_close();
      push @res, $token;
    }

    #debug @res."\n";
 
    return new scmSExpr()->list(@res);
  }
}

sub next_token() {
  my $self=shift;
  my $tok=$self->_next_token();
  if (defined($tok)) {
    $tok->linenr($self->linenr());
    #debug "token: ".$tok->type()." - ".$tok->value()."\n";
  }
  return $tok;
}

sub end_of_file() {
  my $self=shift;
  return $self->{eeof};
}

sub rl() {
  #debug "rl...";
  my $self=shift;
  if (defined($self->{fin})) {
     my $fin=$self->{fin};
     if (eof($fin)) { $self->{eeof}=1;return undef; }
     my $line=<$fin>;
     my $nr=$self->linenr();
     $self->set_linenr($nr+1);
     #debug "len=".length($line)."\n";
     if ($line eq "") { $self->{eeof}=1;return undef; }
     return $line;
  } elsif (defined($self->{line_provider})) {
  	 my $line=$self->{line_provider}->();
     my $nr=$self->linenr();
     $self->set_linenr($nr+1);
     if ($line eq "") { $self->{eeof}=1;return undef; }
     return $line;
  } else {
     my $term=$self->{term};
     my $line=$term->readline(">");
     #my $line=<STDIN>;
     #debug "line=$line\n";
     return $line;
  }
}

sub _next_token() {
  my $self=shift;

  my $str=$self->{str};
  #debug "str='$str'\n";
  while (($str eq "") && not($self->end_of_file())) {
    my $line=$self->rl();
    if (defined($line)) {
      #if ($line=~/[;].*$/) { $line=~s/[;].*$//; }
      $str.=$line;
      $str=~s/^\s*//;
    }
  }
  $self->{str}=$str;

  #debug "read: ".$self->{str}.", eof=".$self->end_of_file()."\n";

  if ($self->end_of_file() && ($self->{str} eq "")) {
    return undef;
  }

  if ($str=~/^["][^"]*["]\s*/) {
     $self->{str}=~s/^["]([^"]*)["]\s*//;
     return new scmSExpr()->string($1);
  } elsif ($str=~/^[(]\s*/) {
     $self->{str}=~s/^[(]\s*//;
     return new scmToken()->open();
  } elsif ($str=~/^[)]\s*/) {
     $self->{str}=~s/^[)]\s*//;
     return new scmToken()->close();
  } elsif ($str=~/^[;].*/) {
     $self->{str}=~s/^[;](.*)\s*//;
     return $self->_next_token(); #new scmSExpr()->comment($1);
  } elsif ($str=~/^[.]\s+/) {
     $self->{str}=~s/^[.]\s+//;
     return new scmSExpr()->dot();
  } elsif ($str=~/^[-]?[0-9]*[.]?[0-9]+\s*/) {
     $self->{str}=~s/^([-]?[0-9.]+)\s*//;
     return new scmSExpr()->number($1);
  } elsif ($str=~/^[']/) {
     $self->{str}=~s/^[']//;
     return new scmSExpr()->symbol();
  } elsif ($str=~/^lambda([(]|\s+)/) {
     $self->{str}=~s/^lambda\s*//;
     return new scmSExpr()->lambda();
  } elsif ($str=~/^set[!]\s*/) {
     $self->{str}=~s/^set[!]\s*//;
     return new scmSExpr()->_set();
  } elsif ($str=~/^do([(]|\s+)/) {
     $self->{str}=~s/^do\s*//;
     return new scmSExpr()->_do();
  } elsif ($str=~/^cond([(]|\s+)/) {
     $self->{str}=~s/^cond\s*//;
     return new scmSExpr()->_cond();
  } elsif ($str=~/^case([(]|\s+)/) {
     $self->{str}=~s/^case\s*//;
     return new scmSExpr()->_case();
  } elsif ($str=~/^and([(]|\s+)/) {
     $self->{str}=~s/^and\s*//;
     return new scmSExpr()->_and();
  } elsif ($str=~/^or([(]|\s+)/) {
     $self->{str}=~s/^or\s*//;
     return new scmSExpr()->_or();
  } elsif ($str=~/^eq[?]\s*/) {
     $self->{str}=~s/^eq[?]\s*//;
     return new scmSExpr()->eq_V_();
  } elsif ($str=~/^begin([(]|\s+)/) {
     $self->{str}=~s/^begin\s*//;
     return new scmSExpr()->begin();
  } elsif ($str=~/^die([(]|\s+)/) {
  	 $self->{str}=~s/^die\s*//;
  	 return new scmSExpr()->_die();
  } elsif ($str=~/[_][_]LINE[_][_]\s+/) {
     $self->{str}=~s/[_][_]LINE[_][_]\s*//;
     return new scmSExpr()->number($self->linenr());
  } elsif ($str=~/^let[*]?([(]|\s+)/) {
     $self->{str}=~s/^let[*]?\s*//;
     return new scmSExpr()->let();
  } elsif ($str=~/^if([(]|\s+)/) {
     $self->{str}=~s/^if\s*//;
     return new scmSExpr()->_if();
  } elsif ($str=~/^letrec[*]?([(]|\s+)/) {
     $self->{str}=~s/^letrec[*]?\s*//;
     return new scmSExpr()->let();
  } elsif ($str=~/^perl-import\s+/) {
  	 $self->{str}=~s/^perl-import\s*//;
  	 return new scmSExpr()->perl_import();
  } elsif ($str=~/^define([(]|\s+)/) {
     $self->{str}=~s/^define\s*//;
     return new scmSExpr()->define();
  } elsif ($str=~/^define[-]syntax([(]|\s+)/) {
     $self->{str}=~s/^define[-]syntax\s*//; 
     return new scmSExpr()->define_syntax();
  } elsif ($str=~/^syntax[-]rules([(]|\s+)/) {
     $self->{str}=~s/^syntax[-]rules\s*//;
     return new scmSExpr()->syntax_rules();
  } elsif ($str=~/^perl\s+/) { 
     $self->{str}=~s/^perl\s*//;
     return new scmSExpr()->perl();
  } elsif ($str=~/^use\s+/) {
     $self->{str}=~s/^use\s*//;
     return new scmSExpr()->_use();
  } elsif ($str=~/^package\s+/) {
     $self->{str}=~s/^package\s*//;
     return new scmSExpr()->_package();
  } elsif ($str=~/^core[-]package\s+/) {
     $self->{str}=~s/^core[-]package\s*//;
     return new scmSExpr()->_package("core");
  } elsif ($str=~/^compile\s+/) {
     $self->{str}=~s/^compile\s*//;
     return new scmSExpr()->_compile();
  #} elsif ($str=~/^new\s+/) {
  #   $self->{str}=~s/^new\s*//; 
  #   return new scmSExpr()->_new();
  } elsif ($str=~/^[-][>]([(]|\s+)/) {
     $self->{str}=~s/^[-][>]\s*//;
     return new scmSExpr()->obj_apply();
  } elsif ($str=~/^[a-zA-Z_.&|*+\/=<>~-][a-zA-Z0-9_.&|*+\/:?!=<>~-]*\s*/) { #([()]|\s+)/) {
     $self->{str}=~s/^([a-zA-Z_.&|*+\/=<>~-][a-zA-Z0-9_.&|*+\/:?!=<>~-]*)\s*//;
     #nnprint "match: $1\n";
     return new scmSExpr()->identifier($1);
  } elsif ($str=~/^[<>][=]([(]|\s+)/) {
     $self->{str}=~s/^([<>][=])\s*//;
     return new scmSExpr()->operator($1);
  } elsif ($str=~/^[*+-\/=<>]([(]|\s+)/) {
     $self->{str}=~s/^([*+-\/=<>])\s*//;
     return new scmSExpr()->operator($1);
  } elsif ($str=~/^[#][tf]\s*/) {
     $self->{str}=~s/^([#][tf])\s*//; 
     return new scmSExpr()->boolean($1);
  } elsif ($str=~/^[#][\\](.)\s*/) {
     $self->{str}=~s/^[#][\\](.)\s*//;
     return new scmSExpr()->char($1);
  } elsif ($str=~/^\s*/) {
     $self->{str}=~s/^\s*//;
     return new scmSExpr()->comment("");
  } else {
     $self->{str}=~s/^\s*//;
     die "Unexpected: ".$self->{str}."\n";
     #return undef;
  }
}

sub evaluate() {
  my $self=shift;
  my $sexpr=shift;
  if (not(defined($sexpr))) { return ""; }

  #print "$sexpr\n";
  #debug "evaluate:".$sexpr->value()."\n";

  my $res="";

  if ($sexpr->is_list()) {
    my @l=@{$sexpr->value()};
    #debug @l."\n";
    my $car=shift @l;
    #debug "type:".$car->type()."\n";
    if ($car->is_lambda()) {
       $res=$self->eval_lambda(@l);
    } elsif ($car->is_comment()) {
       $res=" # ".$car->value()."\n";
    } elsif ($car->is_set()) {
       $res=$self->eval_set(@l);
    } elsif ($car->is_do()) {
       $res=$self->eval_do(@l);
    } elsif ($car->is_cond()) {
       $res=$self->eval_cond(@l);
    } elsif ($car->is_eq_V_()) {
       $res=$self->eval_eq_V_(@l);
    } elsif ($car->is_case()) {
       $res=$self->eval_case(@l);
    } elsif ($car->is_and()) {
       $res=$self->eval_and(@l);
    } elsif ($car->is_or()) {
       $res=$self->eval_or(@l);
    } elsif ($car->is_begin()) {
       $res=$self->eval_begin(@l);
    } elsif ($car->is_let()) {
       $res=$self->eval_let(@l);
    } elsif ($car->is_if()) {
       $res=$self->eval_if(@l);
    } elsif ($car->is_perl()) {
       $res=$self->eval_perl(@l);
    } elsif ($car->is_perl_import()) {
       $res=$self->eval_perl_import(@l);
    } elsif ($car->is_compile()) {
       $res=$self->eval_compile(@l);
    } elsif ($car->is_use()) {
       $res=$self->eval_use(@l);
    } elsif ($car->is_package()) {        # (package name version (exports) (definitions))
       $res=$self->eval_package($car,@l);
    #} elsif ($car->is_new()) {
      # $res=$self->eval_new(@l);
    } elsif ($car->is_die()) {
       $res=$self->eval_die($car,$self->scm_name(),$self->define(),@l);
    } elsif ($car->is_obj_apply()) { 
       $res=$self->eval_obj_apply(@l);
    } elsif ($car->is_define()) {
       $res=$self->eval_define(@l);
    } elsif ($car->is_define_syntax()) {
       $res=$self->eval_define_syntax(@l);
    } elsif ($car->is_syntax_rules()) {
       $res=$self->eval_syntax_rules(@l);
    } elsif ($car->is_operator()) {
       $res=$self->eval_operator($car,@l);
    } elsif ($car->is_identifier()) {
       # this could be syntax or a real identifier
       my $id=$self->get_identifier($car);
       debug("id=$id\n");
       my $evalcode="sub { if (defined($id)) { debug(\"$id\n\");return $id; } else { return undef; } }->(); ";
       #print "evaluating $evalcode\n";
       my $f=$QEVAL_FUNC->($evalcode);
       #my $f=$self->get_macro($car->value()); #eval { "return $id;" };
       if (defined($f) && (ref($f) eq "scmSyntax")) {
          $res=$f->apply_macro($self,$car,@l);
       } else {
          $res=$self->eval_identifier($car,@l);
       }
    } else {
       $res=$self->eval_exprlist($car,@l);
    }
  } elsif ($sexpr->is_symbol()) {
    $res=$self->eval_symbol($sexpr->value());
  } elsif ($sexpr->is_string()) {
    $res=$self->eval_string($sexpr->value());
  } elsif ($sexpr->is_number()) {
    $res=$self->eval_number($sexpr->value());
  } elsif ($sexpr->is_boolean()) {
    $res=$self->eval_boolean($sexpr->value());
  } elsif ($sexpr->is_re()) {
  	$res=$self->eval_re($sexpr->value());
  } else {
    if ($sexpr->is_operator()) {
       $res=$self->get_operator($sexpr);
    } elsif ($sexpr->is_identifier) {
       $res=$self->get_identifier($sexpr);
    } elsif ($sexpr->is_lambda()) {
       $res=undef;
    } elsif ($sexpr->is_comment()) {
       $res=" # ".$sexpr->value()."\n";
    } else {
       $res=$sexpr->value();
    }
  }
  
  return $res;
}

##############################################################
# symbol processing
##############################################################

sub eval_symbol() {
  my $self=shift;
  my $sexpr=shift;
  if ($sexpr->is_list()) {
    my $val=$sexpr->value();
    return $self->eval_list(@{$val});
  } else {
    return "new scmSymbol(\"".$sexpr->value()."\")";
    #return "\"".$sexpr->value()."\"";
  }
}

sub eval_string() {
  my $self=shift;
  my $val=shift;
  return $val;
  #return "eval { my \$v : string=".$val.";return \$v; }";
}

sub eval_number() {
  my $self=shift;
  my $val=shift;
  return $val; 
  #return "eval { my \$v : number=$val;return \$v; }";
}

sub eval_boolean() {
  my $self=shift;
  my $val=shift;
  return $val;
  #return "eval { my \$v : bool=$val;return \$v; }";
}

sub eval_re() {
  my $self=shift;
  my $val=shift;
  return $val;
}

sub eval_list() {
  my $self=shift;
  my $res="\$scm_list->(";
  my $comma="";
  while (my $sexpr=shift @_) {
     $res.=$comma;
     $res.=$self->eval_symbol($sexpr);
     $comma=",";
  }
  $res.=")";
  return $res;
}

##############################################################
# perl expressions
##############################################################

sub get_perl_func($) {
  my $func=shift;
  my $f=$func->value();
  $f=~s/^["]\s*//;
  $f=~s/\s*["]$//;
  if ($f=~/^sub[^{]*[{]/) { return $f."->("; }
  else { return $f."("; }
}


sub eval_perl() {
  my $self=shift;
  my $func=shift;
  if (scalar(@_)==0) {  
    if ($func->is_string()) {  #literal
      return get_perl_func($func).");";
    } else { # import
      #return "our \$scm_".$func->value().";\$scm_".$func->value()."=\\&".$func->value().";";
      return "use vars qw(\$scm_".$func->value().");our \$scm_".$func->value()."=\\&".$func->value().";";
    }
  } else { # apply
    my $res=get_perl_func($func);
    my $comma="";
    while(my $arg=shift @_) {
      $res.=$comma;
      $self->incr();
      $res.=$self->evaluate($arg);
      $self->decr();
      $comma=",";
    }
    $res.=")";
    return $res;
  }
}

sub eval_perl_import() {
  my $r="";
  my $self=shift;
  foreach my $func (@_) {
  	my $pf=$func->value();
  	$pf=~s/^["]\s*//;
  	$pf=~s/\s*["]$//;
  	my $res="use vars qw(\$scm_$pf);our \$scm_$pf=sub { return $pf(\@_); };\n";
#  	my $res="use vars qw(\$scm_$pf);our \$scm_$pf=\\\&main::$pf;\n";
  	$r.=$res;
  }
  return $r;
}

sub eval_die() {
	my $self=shift;
	my $die_e=shift;
	my $die_module=shift;
	my $die_func=shift;
	
	my $line=$die_e->linenr();
	my $func=$die_func;
	my $file=$die_module;
	my $msg="in file '$file', in function '$func', at line $line";
	my $str="";
	my $dot="";
    while(my $arg=shift @_) {
      $str.=$dot;
      $self->incr();
      $str.=$self->evaluate($arg);
      $self->decr();
      $dot=".";
    }
	my $res="sub { die $str.\"\\n$msg\\nperl:\"; }->()";
	return $res;
}

##############################################################
# perl package interfacing
##############################################################

sub eval_use() {
  my $self=shift;
  my $package=shift;
  my $res="use ";
  my $package=$self->get_package_name($package);
  my $comma=" ";
  while (my $arg=shift @_) {
     $package.=$comma;
     $self->incr();
     $package.=$self->evaluate($arg);
     $self->decr();
     $comma=" ";
  }
  $res=$res.$package.";\n";
  # evaluate the use immediately, because we may want to use the bindings.
  #debug "res=$res\n";
  #print "res=$res\n";
  $EVAL_FUNC->($res);
  #print eval("%".$package."::"),"\n";
  #$EVAL_FUNC->("print %".$package."::,'\n';");
  #eval ("require $package;");
  #print @$,"\n";
  #$EVAL_FUNC->("require $package;");
  #require $package;
  
  return $res;
}

sub eval_compile() {
  my $self=shift;
  while(my $package=shift) {
	  my $val;
	  if ($package->is_identifier()) {
		my $id=$self->get_identifier($package);
		#debug $id."\n";
		$val=$QEVAL_FUNC->("$id;"); #eval "$id;";
		#debug "val=$val\n";
		if ($@) { $val=$package->value(); }
		#debug "$@\n";
	  } else {
		$val=$package->value();
	  }
	  $scm_compile->($val);
  }
}

#sub eval_new() {
#  my $self=shift;
#  my $class=shift;
#  my $res="new ".$class->value()."(";
#    #debug "$res\n";
#  my $comma="";
#  while(my $arg=shift @_) {
#    #debug "$res\n";
#    $res.=$comma;
#    $self->incr();
#    $res.=$self->evaluate($arg);
#    $self->decr();
#    $comma=",";
#  }
#  $res.=")";
#    #debug "$res\n";
#  return $res;
#}

sub eval_package() {
  my $self=shift;
  my $sexpr=shift;
  my $name=shift;
  my $version=shift;
  my $exports=shift;
  my $packname=$self->get_package_name($name);
  my $res="package ".$packname.";\n";
  $res.="use strict;\n";
  if ($sexpr->value() ne "core") {
    $res.="use scmCore;\n";
  }
  $res.="use scmOperators;\n";
  $res.="use scmSyntax;\n";
  $res.="use scmSExpr;\n";
  $res.="use scmDebug;\n";
  $res.="use Exporter;\n";
  $res.="use vars qw(\@ISA \@EXPORT \@EXPORT_OK \$VERSION);\n";
  $res.="\$VERSION=\"".$version->value()."\";\n";
  $res.="\@ISA = qw/ Exporter /;\n";
  $res.="\@EXPORT = qw(";

  my $defines=$self->{defines};
  my @l;
  $self->{defines}=\@l;

  my @E=@{$exports->value()};
  foreach my $func (@E) {
    $res.=$self->get_identifier($func)." ";
  }
  $res.=");\n";

  my $R="";
  while (my $sexpr=shift @_) {
    $R.=$self->evaluate($sexpr);
  }

  # defines
  my @ids=@{$self->{defines}};
  debug(@ids);
  foreach my $id (@ids) {
  	#print "id=$id\n";
  	if (ref($id) eq "ARRAY") {
  		my ($ident,$fnc)=@{$id};
  		$res.="use vars qw($ident);$ident=\\&$fnc;\n";
  	} else {
	    $res.="use vars qw($id);\n";
	}
  }

  $res.=$R;

  $res.="\n1;\n";

  $self->{defines}=$defines;

  return $res;
}

##############################################################
# Object application
##############################################################

sub eval_obj_apply() {
  my $self=shift;
  my $obj=shift;
  my $func=shift;
  $self->incr();
  my $res;
  if ($obj->is_identifier()) {
  	#print "ID:",$obj->value(),"\n";
  	#$EVAL_FUNC->("print 'Yes?',%".$obj->value."::,'\n'");
 	#my $id="((%".$obj->value()."::) ? eval(\"".$obj->value()."\") : eval(\"\\".$self->evaluate($obj)."\"))";
 	#$EVAL_FUNC->("print $id,'\n'");
 	my $package=$obj->value();
 	my $var=$self->evaluate($obj);
 	my $id="((%"."$package"."::) ? \"$package\" : sub { use vars qw($var);return $var }->())";
  	$res=$id."->".$self->get_sub_name($func)."(";
  } else {
    $res=$self->evaluate($obj)."->".$self->get_sub_name($func)."(";
  }
  my $comma="";
  while(my $arg=shift @_) {
    $res.=$comma;
    $res.=$self->evaluate($arg);
    $comma=",";
  }
  $res.=")";
  $self->decr();
  #$res="sub { print %".$obj->value()."::,'\n';DBI->connect2();return $res; }->()";
  #return $res;
  return "\${scm_check_list($res)}";
}

##############################################################
# if/then/else
##############################################################

sub eval_if() {
  my $self=shift;
  my $sexpr=shift;
  my $sexpr_if=shift;
  my $sexpr_else=shift;
  $self->incr();
  my $res="( (";
  $res.=$self->evaluate($sexpr);
  $res.=") ? ";
  $res.=$self->evaluate($sexpr_if);
  if (defined($sexpr_else)) {
    $res.=" : ";
    $res.=$self->evaluate($sexpr_else);
  }
  $res.=")";
  $self->decr();
  #$res.=";\n";
  return $res;
}

##############################################################
# evaluation functions 
##############################################################

sub eval_lambda() {
  my $self=shift;
  my $args=shift;

  #my $name=$self->{subname};
  #if (defined($name)) { $name="$name";$self->{subname}=undef; }

  my $name=$self->{subname};
  if (not(defined($name))) { $name=""; }
  $self->{subname}=undef;

  my $res="sub $name {";
  my $dot=0;
  if ($args->is_list()) { 
    foreach my $id (@{$args->value()}) {
       if ($id->is_identifier()) {
         if ($dot) {
           $res.="\nmy ".$self->get_identifier($id)."=list(\@_);"; #\\"."@"."_;";
         } else {
           $res.="\nmy ".$self->get_identifier($id)."=shift;";
         }
         $dot=0;
       } elsif ($id->is_dot()) {
         $dot=1;
       } else {
         die "not an argument list";
       }
    }
  } else {
    die "expression is not correct";
  }

  $res.="\n";
  while (my $sexpr=shift @_) {
    $self->incr();
    my $q=$self->evaluate($sexpr);
    $self->decr();
    if (scalar(@_)==0) {
      $res.="return ";
    }
    $res.=$q.";\n";
  }
  $res.="}\n";
  return $res;
}

sub eval_begin() {
  my $self=shift;
  my $res="sub {";
  while (my $sexpr=shift @_) {
    $self->incr();
    my $q=$self->evaluate($sexpr);
    $self->decr();
    if (scalar(@_)==0) {
      $res.="return ";
    }
    $res.=$q.";";
  }
  $res.="}->()";
  return $res;
}

sub eval_let() {
  my $self=shift;
  my $decl=shift;
  my $name=undef;

  $self->incr();

  if (not($decl->is_list())) {
    $name=$self->get_identifier($decl);
    $decl=shift;
  } else {
    $name=gen_id();
  }
  
  my $res="";

  $res.="sub { ";

  my $R="sub {";
  my @expr=@{$decl->value()};
  my @exprs;
  my $comma="my (";
  my $c="";
  my $vars="";
  foreach my $decl (@expr) {
    my ($id,$sexpr)=@{$decl->value()};
    unshift @exprs,$sexpr;
    # Make a temporary id if we're in a syntax definition
    # after that, get_identifier($id) will return this temporary id as long as its in the hygienic_ids hash 
    if (defined($self->{hygienic_ids})) {
    	$self->{hygienic_ids}->{$id->value()}=gen_id()."_".$id->value();
    }
    # end syntax def
    $R.="$comma".$self->get_identifier($id);
    $vars.="$c".$self->get_identifier($id);
    $res.="my ".$self->get_identifier($id).";".$self->get_identifier($id)."=".$self->evaluate($sexpr).";\n";
    $comma=",";
    $c=",";
  }
  if ($comma ne "my (") { $R.=")=\@_;\n"; }

  $res.="my $name;$name=";
  $res.=$R;

  while (my $sexpr=shift @_) {
    my $q=$self->evaluate($sexpr);
    if (scalar(@_)==0) {
      $res.="return ";
    }
    $res.=$q.";";
  }
  $res.="} ;return $name->($vars); }->()";

  $self->decr();

  return $res;
}

sub eval_do() {
  my $self=shift;
  my $decl=shift;

  $self->incr();

  my $res="sub {";

  # declarations
  my @exprs=@{$decl->value()};
  foreach my $decl (@exprs) {
    my ($id,$sexpr,$sexpr_step)=@{$decl->value()};
    $res.="my ".$self->get_identifier($id).";".$self->get_identifier($id)."=".$self->evaluate($sexpr).";\n";
  }

  # while loop
  my $test=shift;
  my @testf=@{$test->value()};
  my $test_sexpr=shift @testf;
  my $test_result=shift @testf;
  $res.="while (not(".$self->evaluate($test_sexpr).")) {\n";
  
  # while body
  while (my $cmd=shift) {
     $res.="  ".$self->evaluate($cmd).";\n";
  }
  foreach my $decl (@exprs) {
     my ($id,$sexpr,$sexpr_step)=@{$decl->value()};
     $res.="  ".$self->get_identifier($id)."=".$self->evaluate($sexpr_step).";\n";
  }
  $res.="}\n";
  $res.="return ".$self->evaluate($test_result).";\n";
  $res.="}->();\n";

  $self->decr();

  return $res;
}

sub return_body() {
  my $self=shift;
  debug("@_\n");
  my $res="";
  while (my $expr=shift) {
    if (scalar(@_)==0) {
       $res.="return ";
    }
    $res.=$self->evaluate($expr).";\n";
  }
  return $res;
}

sub eval_eq_V_() {
  my $self=shift;
  my @exprs=@_;
  my $res="perl_is_eq_V_(";
  my $comma="";
  foreach my $expr (@exprs) {
  	$res.="$comma";
  	$self->incr();
  	if ($expr->is_identifier()) { $res.=$self->get_identifier($expr); }
  	elsif ($expr->is_atom()) { $res.=$self->evaluate($expr); }
  	else { $res.="sub { my \$v=".$self->evaluate($expr).";if (ref(\$v)) { return \$v; } else { return \\\$v; } }->()"; }
  	$self->decr();
  	$comma=",";
  }
  $res.=")";
  return $res;
}

sub eval_cond() {
   my $self=shift;
   my @exprs=@_; 
   $self->incr();
   my $res="sub { ";
   my $iff="if";
   foreach my $expr (@exprs) {
     my ($test,$result,$cresult)=@{$expr->value()};
     if ($result->is_identifier() && ($result->value() eq "=>")) {
       $result=$cresult;
     }
     if ($test->is_identifier() && ($test->value() eq "else")) {
        $res.="else { return ".$self->evaluate($result)." }\n";
        last;
     } else {
       $res.="$iff (".$self->evaluate($test).") { return ".$self->evaluate($result)." }\n";
     }
     $iff="elsif";
   }
   $res.=" }->();";
   $self->decr();
   return $res;
}

sub eval_case() {
  my $self=shift;
  my $key=shift;
  my @exprs=@_;
  $self->incr();
  my $res="sub { ";
  my $iff="if";
  $res.="my \$key=shift;";
  foreach my $expr (@exprs) {
    my @ex=@{$expr->value()};
    my $datum=shift @ex;
    if ($datum->is_identifier() && ($datum->value() eq "else")) {
      $res.="else { ".$self->return_body(@ex)." }\n";
      last;
    } else {
      # datum must be a list of datums
      my @d=$datum->value();
      debug("d=@d\n");
      my $expr="(";
      my $or="";
      foreach my $dat (@d) {
         foreach my $sym (@{$dat}) {
           debug("dat=$dat\n");
           $expr.="$or perl_eqv(\$key,".$self->eval_symbol($sym).")";
           $or="||";
         }
      }
      $expr.=")";
      $res.="$iff $expr { ".$self->return_body(@ex)." }\n";
    }
    $iff="elsif";
  }
  $res.=" }->(".$self->evaluate($key).");";
  $self->decr();
  return $res;
}  

sub eval_define() {
  my $self=shift;
  my $id=shift;
  my $res;
  my $ident="";
  my @ids=@{$self->{defines}};

  my $our="our";
  if ($self->{level}>0) { $our="my"; }

  if ($id->is_list()) {  # function def
    my $args=$id;
    $id=shift @{$args->value()};
    $self->set_define($id->value());
    $ident=$self->get_identifier($id);
    if ($self->{level}==0) {
      $self->{subname}=$self->get_sub_name($id);
    }
    if ($our eq "our") { $res.="use vars qw($ident);our $ident;" }
    else { $res.="$our ".$ident.";"; }
    
    if ($self->{level}>0) {
      $res.="$ident=";
    }
    $self->incr();
    $res.=$self->eval_lambda($args,@_);
    $self->decr();
    if ($self->{level}==0) {
      $self->{subname}=undef;
    }
    if ($self->{level}==0) {
      $res.=";\n".$ident."=\\&".$self->get_sub_name($id).";\n";
      $ident=[$ident,$self->get_sub_name($id)];
    }
  } else {
    $self->set_define($id->value());
    $ident=$self->get_identifier($id);
    if ($our eq "our") { $res="\nuse vars qw($ident);our $ident="; }
    else { $res="\n$our ".$ident."="; }
    $self->incr();
    #$res.="\${scm_check_list(".$self->evaluate(@_).")}";
    $res.=$self->evaluate(@_);
    $self->decr();
  }
  push @ids,$ident;
  $self->{defines}=\@ids;
  return $res.";";
}


sub eval_set() {
  my $self=shift;
  my $lval=shift;
  my $rval=shift;
  $self->incr();
  #my $res=$self->get_identifier($lval)."=\${scm_check_list(".$self->evaluate($rval).")};";
  my $res=$self->get_identifier($lval)."=".$self->evaluate($rval).";";
  $self->decr();
  return $res;
}

sub eval_and() {
  my $self=shift;
  return $self->eval_infix("&&",@_);
}

sub eval_or() {
  my $self=shift;
  return $self->eval_infix("||",@_);
}

sub eval_infix() {
  my $self=shift;
  my $op=shift;
  my $res="(";
  my $f="";
  while(my $arg=shift @_) {
    $res.=" $f ";
    $self->incr();
    $res.=$self->evaluate($arg);
    $self->decr();
    $f=$op;
  }
  $res.=")";
  return "\${scm_check_list($res)}";
  #return $res;
}


sub eval_operator() {
  my $self=shift;
  my $op=shift;
  my $res=$self->get_operator($op);
  $res.="->(";
  my $comma="";
  while(my $arg=shift @_) {
     $res.=$comma;
     $self->incr();
     $res.=$self->evaluate($arg);
     $self->decr();
     $comma=",";
  }
  $res.=")";
  return "\${scm_check_list($res)}";
  #return $res;
}

sub eval_identifier() {
  my $self=shift;
  my $id=shift;
  my $res;
  #my $cd="&".$id->value();
  #debug "checking $cd\n";
  #do_qeval($cd);
  #if (not($@)) { 
  #  $res=$id->value()."(";
  #} else {
    $res=$self->get_identifier($id);
    $res.="->(";
  #}
  my $comma="";
  while(my $arg=shift @_) {
    $res.=$comma;
    $self->incr();
    $res.=$self->evaluate($arg);
    $self->decr();
    $comma=",";
  }
  $res.=")";
  return "\${scm_check_list($res)}";
  #return $res;
}

sub eval_exprlist() {
  my $self=shift;
  my $sexpr=shift;
  $self->incr();
  my $res=$self->evaluate($sexpr);
  $res.="->(";
  my $comma="";
  while(my $arg=shift @_) {
    $res.=$comma;
    $res.=$self->evaluate($arg);
    $comma=",";
  }
  $res.=")";
  $self->decr();
  return $res;
}

##############################################################
# macros 
##############################################################
# (define-syntax <identifier> (syntax-rules ([identifier]+) [((_ [pattern-of-identifier]) <code>)]+))
# moet een parser/code generator opleveren.
##############################################################

sub eval_define_syntax() {
   my $self=shift;
   my $macro_id=shift;
   my $id=$self->get_identifier($macro_id);
   my $rules=shift;
   
   if (not(defined($rules))) {
      die "Expected: 'syntax-rules' expression";
   } elsif (not($rules->is_list())) {
      die "Expected: 'syntax-rules' expression";
   }
   
   my $our="our";
   if ($self->{level}>0) { $our="my"; }

   my ($macro_code,$pattern_code,$code_code)=$self->eval_syntax_rules($macro_id,@{$rules->value()});
   my $decl;
   if ($our eq "our") { $decl="use vars qw($id);our $id;" }
   else { $decl="my $id;" }
   my $res="$decl;$id=new scmSyntax(\"".$macro_id->value()."\",$macro_code,$pattern_code,$code_code);\n";

   return $res;
}

sub eval_syntax_rules() {
   my $self=shift;
   my $macro_id=shift;
   my $syntax_rules=shift;
   my $id_list=shift;

   if (not($syntax_rules->is_syntax_rules())) {
      die "Expected: 'syntax-rules'";
   }
   
   my $res="sub { my \$syntax=shift;my \$self=shift;my \$macro_id=shift;my \@args=\@_;debug(\"macro:\".\$macro_id->value().\"\\n\");";
   my $patterns="sub { my \$self=shift;\n";
   my $codes="sub { my \$self=shift;\n";
 
   my $iff="if"; 
   my $count=0;
   while (my $rule=shift) {
      if (not($rule->is_list())) { die "Expected: for syntax-rules: rule expression"; }
      my @syntax=@{$rule->value()};
      $res.="$iff ";
      my ($R,$P,$C)=$self->eval_syntax_rule($macro_id,$count,@syntax);
      $res.=$R;
      $patterns.=$P;
      $codes.=$C;
      $count+=1;
      $iff="elsif";
   }
   if ($iff eq "if") { $iff=""; }
   else { $iff="else"; }

   $res.="$iff { die \"Macro: ".$macro_id->value().": no pattern matched while applying macro\"; }";

   $res.="}";
   $patterns.="}\n";
   $codes.="}\n";

   return ($res,$patterns,$codes);
}

# HIER MOETEN DE DECLS veranderd! voor MACRO EXPANSIE!
# EN WE MOETEN IETS MET LEXICALE SCOPE VAN MACROS!
# DE GEBRUIKTE VARIABELEN MOETEN BINDEN AAN DE LEXICALE SCOPE VAN DE MACRO
# OF WE KIEZEN ER EXPLICIET VOOR OM DAT NIET TE DOEN, MAAR DAN MOETEN WE
# ER IETS ANDERS MEE! (DOCUMENTEREN)
sub genCode() {
  my $self=shift;
  my $res="[";
  my $comma="";
  foreach my $el (@_) {
    $res.=$comma;
    $res.=$el->genCode();
    $comma=",";
  } 
  $res.="]";
  return $res;
}

sub eval_syntax_rule() {
   my $self=shift;
   my $macro_id=shift;
   my $pattern_index=shift;
   my $pattern=shift;
   my @sexpr=@_;
   my $res="";
   my $macroid=$macro_id->value();
   my $patt="";
   my $code="";
   #$self->set_pattern($macroid,$pattern_index,$pattern);
   #$self->set_code($macroid,$pattern_index,\@sexpr);

   $patt.="\$self->set_pattern($pattern_index,".$pattern->genCode().");\n";
   $code.="\$self->set_code($pattern_index,".$self->genCode(@sexpr).");\n";

   $res.="(\$self->match_pattern(\$syntax->get_pattern($pattern_index),\@args)) { debug(\"pattern:$pattern_index\\n\");";
   $res.="  my \@code=\@{\$self->substitute_macro_arguments(\$syntax->get_pattern($pattern_index),";
   $res.= 												"\\\@args,\@{\$syntax->get_code($pattern_index)})\n";
   $res.="};\n";
   $res.="  my \$res=\"\";\n";
   # TODO - I think we should do without 'return' here.
   #$res.="  my \$previous_id_hash=\$self->{hygienic_ids};my \%hygienic_ids;\$self->{hygienic_ids}=\\\%hygienic_ids;\n";
   $res.="  while (my \$sexpr=shift \@code) { \n";
   $res.="      \$sexpr->linenr(\$self->linenr());debug(\"res=\$res\\n\");\n";
   $res.="      if (scalar(\@code)==0) { \$res.=\"  \"; } \$res.=\$self->evaluate(\$sexpr);\n";
   $res.="  }\n";
   $res.="  debug(\"res=\$res\\n\");\n";
   #$res.="  \$self->{hygienic_ids}=\$previous_id_hash;\n";
   $res.="  return \$res;\n";
   $res.="}\n";

   return ($res,$patt,$code);
}

sub substitute_macro_arguments() {
  my $self=shift;
  my $pattern=shift;
  my $a=shift;
  my @code=@_;

  debug("sma: $pattern\n");
  debug("sma: $a\n");
  foreach my $e (@code) {
    debug("sma: code: $e\n");
  }

  my @arg_values=@{$a};

  # get the variables
  my %vars;
  my @args=@{$pattern->value()};
  my $macroname=shift @args;
  foreach my $var (@args) {
    if ($var->is_identifier()) {
      if ($var->value() eq "...") {
        $vars{$var->value()}=\@arg_values;
      } else {
        my $sexpr=shift @arg_values;
        $vars{$var->value()}=$sexpr;
        debug("var:".$var->value()."=$sexpr\n");
      }
    } else {
      die "Macro application: arguments are not variables";
    }
  }

  # substitute the arguments

  my @newcode;
  foreach my $csexpr (@code) {
     my $newsexpr=$self->subst(\%vars,$csexpr);
     if (ref($newsexpr) eq "ARRAY") {
        foreach my $e (@{$newsexpr}) {
          push @newcode,$e;
        }
     } else {
       push @newcode,$newsexpr;
     }
  }

  return \@newcode;
}


sub subst() {
  my $self=shift;
  my $vars=shift;
  my $expr=shift;

  if ($expr->is_list()) {
    my $l=$self->substl($vars,@{$expr->value()});
    return new scmSExpr->list(@{$l});
  } elsif ($expr->is_identifier()) {
    # maybe recognize macro's here.
    my $idname=$expr->value();
    if (defined($vars->{$idname})) {
       my $sexpr=$vars->{$idname};
       return $sexpr;
    } else {
       return $expr;
    }
  } else {
    return $expr;
  }
}

sub substl() {
  my $self=shift;
  my $vars=shift;
  my @sexprs=@_;
  my @l;

  foreach my $sexpr (@sexprs) {
    debug("substl:$sexpr\n");
    my $e=$self->subst($vars,$sexpr);
    if (ref($e) eq "ARRAY") {
      foreach my $ee (@{$e}) {
        push @l,$ee;
      }
    } else {
      push @l,$e;
    }
  }

  return \@l;
}

##############################################################
# support functions
##############################################################

sub get_identifier() {
  my ($self,$id)=@_;
  my $vid=$id->value();
  # Look if this id is part of the hygienic_ids hash and return the temporary id if it is present
  if (defined($self->{hygienic_ids})) {
  	if (exists $self->{hygienic_ids}->{$vid}) {
		$vid=$self->{hygienic_ids}->{$vid};
  	}
  }
  #$vid=~s/[_]/__/g;
  $vid=~s/[?]/_V_/g;
  $vid=~s/[!]/_E_/g;
  $vid=~s/[-]/_M_/g;
  $vid=~s/[<]/_L_/g;
  $vid=~s/[>]/_G_/g;
  $vid=~s/[=]/_Q_/g;
  $vid=~s/[+]/_P_/g;
  $vid=~s/[*]/_S_/g;
  $vid=~s/[\$]/_D_/g;
  $vid=~s/[#]/_K_/g;
  $vid=~s/[@]/_A_/g;
  $vid=~s/[\/]/_d_/g;
  $vid=~s/[&]/_e_/g;
  $vid=~s/[|]/_o_/g;
  $vid=~s/[~]/_t_/g;
  $vid=~s/[:][:]/_c_/g;
  return "\$scm_".$vid;
}

sub get_package_name() {
  my ($self,$id)=@_;
  my $f=$id->value();
  #my $f=$self->get_identifier($id);
  #$f=~s/.scm_//;
  return $f;
}

sub get_sub_name() {
  my ($self,$id)=@_;
  my $f=$self->get_identifier($id);
  $f=~s/^.scm_//;
  return $f;
  #return $self->get_package_name($id);
}

sub get_operator() {
  my ($self,$id)=@_;
  if ($id->value() eq "+") { return "\$scm_plus"; }
  elsif ($id->value() eq "-") { return "\$scm_min"; }
  elsif ($id->value() eq "/") { return "\$scm_div"; }
  elsif ($id->value() eq "*") { return "\$scm_times"; }
  elsif ($id->value() eq "=") { return "\$scm_n_eq"; }
  elsif ($id->value() eq "<") { return "\$scm_n_lt"; }
  elsif ($id->value() eq ">") { return "\$scm_n_gt"; }
  elsif ($id->value() eq "<=") { return "\$scm_n_lte"; }
  elsif ($id->value() eq ">=") { return "\$scm_n_gte"; }
  else { return "scm_operr"; }
}

my $idnr=0;
sub gen_id() {
  $idnr+=1;
  return "\$id_$idnr";
}

sub incr() {
  my $self=shift;
  $self->{level}+=1;
}

sub decr() {
  my $self=shift;
  $self->{level}-=1;
}


my %PATTERNS;
my %MACROS;
my %CODE;

sub set_pattern($$$) {
  my $self=shift;
  my $id=shift;
  my $count=shift;
  my $pattern=shift;
  # TODO: Do something with scope!! All macro's will be global now!
  $PATTERNS{"macro_pattern:$id:$count"}=$pattern;
  $self->get_pattern($id,$count);
}

sub get_pattern() {
  my $self=shift;
  my $id=shift;
  my $count=shift;
  debug("get_pattern: $id, $count=".$PATTERNS{"macro_pattern:$id:$count"}."\n");
  return $PATTERNS{"macro_pattern:$id:$count"};
}

sub set_code($$$) {
  my $self=shift;
  my $id=shift;
  my $count=shift;
  my $code=shift;
  debug("set_code: ".$code."\n");
  foreach my $e (@{$code}) {
    debug("set_code: sexpr: $e\n");
  }
  
  # TODO: Do something with scope!! All macro's will be global now!
  $CODE{"macro_code:$id:$count"}=$code;
  $self->get_code($id,$count);
}

sub get_code() {
  my $self=shift;
  my $id=shift;
  my $count=shift;
  my $c=$CODE{"macro_code:$id:$count"};
  debug("get_code: ".$c."\n");
  foreach my $e (@{$c}) {
     debug("get_code: sexpr: $e\n");
  }
  return $c;
}

sub match_pattern() {
  my $self=shift;
  my $pattern=shift;
  my @args=@_;
  my @l=@{$pattern->value()};
  my $macro_name=shift @l;
  #debug "macroname: $macro_name\n";
  #debug "pattern:".$pattern->genCode()."\n";
  #debug "arguments:".scalar(@args)."\n";
  # VERFIJNEN! Dit kijkt alleen maar naar het aantal argumenten!!
  if (scalar(@l)==scalar(@args)) {
     return 1; 
  } else {
     my $len=scalar(@l);
     if ($len==0) {
       return 0; 
     } else {
       if ($len<scalar(@args) && ($l[$len-1]->value() eq "...")) {
          return 1;
       } else {
          return 0;
       }
     }
  }
  #return (1==0);
}

sub set_macro($) {
  my $syntax=shift;
  my $id=$syntax->name();
  # TODO: Do something with scope!! All macro's will be global now!
  $MACROS{"macro:$id"}=$syntax;
}

sub get_macro($) {
  my $self=shift;
  my $id=shift;
  return $MACROS{"macro:$id"};
}


1;
