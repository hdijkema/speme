package scmTree;
use strict;
use scmCore;
use scmOperators;
use scmSyntax;
use scmSExpr;
use scmDebug;
use Exporter;
use vars qw(@ISA @EXPORT @EXPORT_OK $VERSION);
$VERSION="0.1";
@ISA = qw/ Exporter /;
@EXPORT = qw($scm_tree_M_new $scm_tree_M_put $scm_tree_M_get $scm_tree_M_remove $scm_tree_M_exists_V_ $scm_tree_M_traverse );
use vars qw($scm_tree_M_new);
$scm_tree_M_new=\&tree_M_new;
use vars qw($scm_tree_M_put);
$scm_tree_M_put=\&tree_M_put;
use vars qw($scm_i_M_tree_M_put);
$scm_i_M_tree_M_put=\&i_M_tree_M_put;
use vars qw($scm_tree_M_get);
$scm_tree_M_get=\&tree_M_get;
use vars qw($scm_i_M_tree_M_get);
$scm_i_M_tree_M_get=\&i_M_tree_M_get;
use vars qw($scm_tree_M_exists_V_);
$scm_tree_M_exists_V_=\&tree_M_exists_V_;
use vars qw($scm_i_M_tree_M_exists);
$scm_i_M_tree_M_exists=\&i_M_tree_M_exists;
use vars qw($scm_tree_M_remove);
$scm_tree_M_remove=\&tree_M_remove;
use vars qw($scm_i_M_tree_M_remove);
$scm_i_M_tree_M_remove=\&i_M_tree_M_remove;
use vars qw($scm_i_M_tree_M_put_M_part);
$scm_i_M_tree_M_put_M_part=\&i_M_tree_M_put_M_part;
use vars qw($scm_tree_M_traverse);
$scm_tree_M_traverse=\&tree_M_traverse;
use vars qw($scm_i_M_tree_M_traverse);
$scm_i_M_tree_M_traverse=\&i_M_tree_M_traverse;
use vars qw($scm_tree_M_new);
our $scm_tree_M_new;
sub tree_M_new {
  my $scm_less=shift;
  my $scm_eq=shift;
  return $scm_list->(new scmSymbol("tree"),$scm_less,$scm_eq,new scmSymbol("nil"));
  
};
$scm_tree_M_new=\&tree_M_new;
;
;
use vars qw($scm_tree_M_put);
our $scm_tree_M_put;
sub tree_M_put {
  my $scm_tree=shift;
  my $scm_val=shift;
  return sub {
    $scm_set_M_car_E_->($scm_cdddr->($scm_tree),$scm_i_M_tree_M_put->($scm_cadr->($scm_tree),$scm_caddr->($scm_tree),$scm_val,$scm_cadddr->($scm_tree)));
    return $scm_tree;
    
  }->();
  
};
$scm_tree_M_put=\&tree_M_put;
;
;
use vars qw($scm_i_M_tree_M_put);
our $scm_i_M_tree_M_put;
sub i_M_tree_M_put {
  my $scm_less=shift;
  my $scm_eq=shift;
  my $scm_val=shift;
  my $scm_node=shift;
  return ( ($scm_list_V_->($scm_node)) ? ( (  $scm_string_Q__V_->($scm_tostring->($scm_car->($scm_node)),$scm_tostring->(new scmSymbol("nil")))) ? $scm_list->($scm_val,$scm_cadr->($scm_node),$scm_caddr->($scm_node)) : ( ($scm_less->($scm_val,$scm_car->($scm_node))) ? $scm_list->($scm_car->($scm_node),$scm_i_M_tree_M_put->($scm_less,$scm_eq,$scm_val,$scm_cadr->($scm_node)),$scm_caddr->($scm_node)) : ( ($scm_eq->($scm_val,$scm_car->($scm_node))) ? $scm_list->($scm_val,$scm_cadr->($scm_node),$scm_caddr->($scm_node)) : $scm_list->($scm_car->($scm_node),$scm_cadr->($scm_node),$scm_i_M_tree_M_put->($scm_less,$scm_eq,$scm_val,$scm_caddr->($scm_node)))))) : $scm_list->($scm_val,new scmSymbol("nil"),new scmSymbol("nil")));
  
};
$scm_i_M_tree_M_put=\&i_M_tree_M_put;
;
;
use vars qw($scm_tree_M_get);
our $scm_tree_M_get;
sub tree_M_get {
  my $scm_tree=shift;
  my $scm_key=shift;
  return $scm_i_M_tree_M_get->($scm_cadr->($scm_tree),$scm_caddr->($scm_tree),$scm_key,$scm_cadddr->($scm_tree));
  
};
$scm_tree_M_get=\&tree_M_get;
;
;
use vars qw($scm_i_M_tree_M_get);
our $scm_i_M_tree_M_get;
sub i_M_tree_M_get {
  my $scm_less=shift;
  my $scm_eq=shift;
  my $scm_key=shift;
  my $scm_node=shift;
  return ( ($scm_list_V_->($scm_node)) ? ( (  $scm_string_Q__V_->($scm_tostring->($scm_car->($scm_node)),$scm_tostring->(new scmSymbol("nil")))) ? new scmSymbol("nil") : ( ($scm_less->($scm_key,$scm_car->($scm_node))) ? $scm_i_M_tree_M_get->($scm_less,$scm_eq,$scm_key,$scm_cadr->($scm_node)) : ( ($scm_eq->($scm_key,$scm_car->($scm_node))) ? $scm_car->($scm_node) : $scm_i_M_tree_M_get->($scm_less,$scm_eq,$scm_key,$scm_caddr->($scm_node))))) : new scmSymbol("nil"));
  
};
$scm_i_M_tree_M_get=\&i_M_tree_M_get;
;
;
use vars qw($scm_tree_M_exists_V_);
our $scm_tree_M_exists_V_;
sub tree_M_exists_V_ {
  my $scm_tree=shift;
  my $scm_key=shift;
  return $scm_i_M_tree_M_exists->($scm_cadr->($scm_tree),$scm_caddr->($scm_tree),$scm_key,$scm_cadddr->($scm_tree));
  
};
$scm_tree_M_exists_V_=\&tree_M_exists_V_;
;
;
use vars qw($scm_i_M_tree_M_exists);
our $scm_i_M_tree_M_exists;
sub i_M_tree_M_exists {
  my $scm_less=shift;
  my $scm_eq=shift;
  my $scm_key=shift;
  my $scm_node=shift;
  return ( ($scm_list_V_->($scm_node)) ? ( (  $scm_string_Q__V_->($scm_tostring->($scm_car->($scm_node)),$scm_tostring->(new scmSymbol("nil")))) ? 0 : ( ($scm_less->($scm_key,$scm_car->($scm_node))) ? $scm_i_M_tree_M_exists->($scm_less,$scm_eq,$scm_key,$scm_cadr->($scm_node)) : ( ($scm_eq->($scm_key,$scm_car->($scm_node))) ? 1 : $scm_i_M_tree_M_exists->($scm_less,$scm_eq,$scm_key,$scm_caddr->($scm_node))))) : 0);
  
};
$scm_i_M_tree_M_exists=\&i_M_tree_M_exists;
;
;
use vars qw($scm_tree_M_remove);
our $scm_tree_M_remove;
sub tree_M_remove {
  my $scm_tree=shift;
  my $scm_key=shift;
  return sub {
    $scm_set_M_car_E_->($scm_cdddr->($scm_tree),$scm_i_M_tree_M_remove->($scm_cadr->($scm_tree),$scm_caddr->($scm_tree),$scm_key,$scm_cadddr->($scm_tree)));
    return $scm_tree;
    
  }->();
  
};
$scm_tree_M_remove=\&tree_M_remove;
;
;
use vars qw($scm_i_M_tree_M_remove);
our $scm_i_M_tree_M_remove;
sub i_M_tree_M_remove {
  my $scm_less=shift;
  my $scm_eq=shift;
  my $scm_key=shift;
  my $scm_node=shift;
  return ( ($scm_list_V_->($scm_node)) ? ( (  $scm_string_Q__V_->($scm_tostring->($scm_car->($scm_node)),$scm_tostring->(new scmSymbol("nil")))) ? $scm_node : ( ($scm_less->($scm_key,$scm_car->($scm_node))) ? $scm_list->($scm_car->($scm_node),$scm_i_M_tree_M_remove->($scm_less,$scm_eq,$scm_key,$scm_cadr->($scm_node)),$scm_caddr->($scm_node)) : ( ($scm_eq->($scm_key,$scm_car->($scm_node))) ? sub {
     my $scm_left;
    $scm_left=$scm_cadr->($scm_node);
    my $scm_right;
    $scm_right=$scm_caddr->($scm_node);
    my $id_21;
    $id_21=sub {
      my ($scm_left,$scm_right)=@_;
      return ( (  $scm_string_Q__V_->($scm_tostring->($scm_left),$scm_tostring->(new scmSymbol("nil")))) ? ( (  $scm_string_Q__V_->($scm_tostring->($scm_right),$scm_tostring->(new scmSymbol("nil")))) ? new scmSymbol("nil") : $scm_right) : ( (  $scm_string_Q__V_->($scm_tostring->($scm_right),$scm_tostring->(new scmSymbol("nil")))) ? $scm_left : $scm_list->($scm_car->($scm_left),$scm_cadr->($scm_left),$scm_i_M_tree_M_put_M_part->($scm_less,$scm_caddr->($scm_left),$scm_right))));
      
    } ;
    return $id_21->($scm_left,$scm_right);
     
  }->() : $scm_list->($scm_car->($scm_node),$scm_cadr->($scm_node),$scm_i_M_tree_M_remove->($scm_less,$scm_eq,$scm_key,$scm_caddr->($scm_node)))))) : $scm_node);
  
};
$scm_i_M_tree_M_remove=\&i_M_tree_M_remove;
;
;
use vars qw($scm_i_M_tree_M_put_M_part);
our $scm_i_M_tree_M_put_M_part;
sub i_M_tree_M_put_M_part {
  my $scm_less=shift;
  my $scm_node=shift;
  my $scm_part=shift;
  return ( ($scm_list_V_->($scm_node)) ? ( (  $scm_string_Q__V_->($scm_tostring->($scm_car->($scm_node)),$scm_tostring->(new scmSymbol("nil")))) ? $scm_part : ( ($scm_less->($scm_car->($scm_part),$scm_car->($scm_node))) ? $scm_list->($scm_car->($scm_node),$scm_i_M_tree_M_put_M_part->($scm_less,$scm_cadr->($scm_node),$scm_part),$scm_caddr->($scm_node)) : $scm_list->($scm_car->($scm_node),$scm_cadr->($scm_node),$scm_i_M_tree_M_put_M_part->($scm_less,$scm_caddr->($scm_node),$scm_part)))) : $scm_part);
  
};
$scm_i_M_tree_M_put_M_part=\&i_M_tree_M_put_M_part;
;
;
use vars qw($scm_tree_M_traverse);
our $scm_tree_M_traverse;
sub tree_M_traverse {
  my $scm_tree=shift;
  my $scm_f=shift;
  return $scm_i_M_tree_M_traverse->($scm_cadddr->($scm_tree),$scm_f);
  
};
$scm_tree_M_traverse=\&tree_M_traverse;
;
;
use vars qw($scm_i_M_tree_M_traverse);
our $scm_i_M_tree_M_traverse;
sub i_M_tree_M_traverse {
  my $scm_node=shift;
  my $scm_f=shift;
  return ( ($scm_list_V_->($scm_node)) ? sub {
    $scm_i_M_tree_M_traverse->($scm_cadr->($scm_node),$scm_f);
    $scm_f->($scm_car->($scm_node));
    return $scm_i_M_tree_M_traverse->($scm_caddr->($scm_node),$scm_f);
    
  }->() : new scmSymbol("nil"));
  
};
$scm_i_M_tree_M_traverse=\&i_M_tree_M_traverse;
;
;
1;
;
