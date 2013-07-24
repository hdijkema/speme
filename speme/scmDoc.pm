package scmDoc;
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
@EXPORT = qw($scm_doc $scm_help_V_ );
use vars qw($scm__cat);
use vars qw($scm__syntax);
use vars qw($scm__descr);
use vars qw($scm_doc);
$scm_doc=\&doc;
use vars qw($scm_help_V_);
$scm_help_V_=\&help_V_;
use vars qw($scm__cat);
our $scm__cat=$scm_hash_M_new->();
;
use vars qw($scm__syntax);
our $scm__syntax=$scm_hash_M_new->();
;
use vars qw($scm__descr);
our $scm__descr=$scm_hash_M_new->();
;
use vars qw($scm_doc);
our $scm_doc;
sub doc {
  my $scm_category=shift;
  my $scm_function=shift;
  my $scm_synt=shift;
  my $scm_description=shift;
  sub {
     my $scm_l;
    $scm_l=( ($scm_hash_M_exists_V_->($scm__cat,$scm_category)) ? $scm_hash_M_get->($scm__cat,$scm_category) : $scm_list->());
    my $id_19;
    $id_19=sub {
      my ($scm_l)=@_;
      return $scm_hash_M_put->($scm__cat,$scm_category,$scm_cons->($scm_function,$scm_l));
      
    } ;
    return $id_19->($scm_l);
     
  }->();
  $scm_hash_M_put->($scm__syntax,$scm_function,$scm_synt);
  return $scm_hash_M_put->($scm__descr,$scm_function,$scm_description);
  
};
$scm_doc=\&doc;
;
;
use vars qw($scm_help_V_);
our $scm_help_V_;
sub help_V_ {
  my $scm_function=shift;
  return $scm_println->($scm_hash_M_get->($scm__syntax,$scm_function),$scm_hash_M_get->($scm__descr,$scm_function));
  
};
$scm_help_V_=\&help_V_;
;
;
1;
;
