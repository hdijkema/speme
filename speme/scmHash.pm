package scmHash;
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
@EXPORT = qw($scm_new );
use vars qw($scm_new);
$scm_new=\&new;
use vars qw($scm_put);
$scm_put=\&put;
use vars qw($scm_get);
$scm_get=\&get;
use vars qw($scm_exists_V_);
$scm_exists_V_=\&exists_V_;
use vars qw($scm_remove);
$scm_remove=\&remove;
use vars qw($scm_keys);
$scm_keys=\&keys;
use vars qw($scm_each);
$scm_each=\&each;
use scmCore;
;
use vars qw($scm_new);
our $scm_new;
sub new {
  my $scm_class=shift;
  return sub {
     my $scm_obj;
    $scm_obj=$scm_hash_M_new->();
    my $id_20;
    $id_20=sub {
      my ($scm_obj)=@_;
      $scm_bless->($scm_obj,$scm_class);
      return $scm_obj;
      
    } ;
    return $id_20->($scm_obj);
     
  }->();
  
};
$scm_new=\&new;
;
;
use vars qw($scm_put);
our $scm_put;
sub put {
  my $scm_self=shift;
  my $scm_key=shift;
  my $scm_val=shift;
  $scm_hash_M_put->($scm_self,$scm_key,$scm_val);
  return $scm_self;
  
};
$scm_put=\&put;
;
;
use vars qw($scm_get);
our $scm_get;
sub get {
  my $scm_self=shift;
  my $scm_key=shift;
  return $scm_hash_M_get->($scm_self,$scm_key);
  
};
$scm_get=\&get;
;
;
use vars qw($scm_exists_V_);
our $scm_exists_V_;
sub exists_V_ {
  my $scm_self=shift;
  my $scm_key=shift;
  return $scm_hash_M_exists_V_->($scm_self,$scm_key);
  
};
$scm_exists_V_=\&exists_V_;
;
;
use vars qw($scm_remove);
our $scm_remove;
sub remove {
  my $scm_self=shift;
  my $scm_key=shift;
  return $scm_hash_M_remove->($scm_self,$scm_key);
  
};
$scm_remove=\&remove;
;
;
use vars qw($scm_keys);
our $scm_keys;
sub keys {
  my $scm_self=shift;
  return $scm_hash_M_keys->($scm_self);
  
};
$scm_keys=\&keys;
;
;
use vars qw($scm_each);
our $scm_each;
sub each {
  my $scm_self=shift;
  return $scm_hash_M_each->($scm_self);
  
};
$scm_each=\&each;
;
;
1;
;
