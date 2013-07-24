package a;
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
@EXPORT = qw($scm_rr );
use vars qw($scm_f);
$scm_f=\&f;
use vars qw($scm_rr);
$scm_rr=\&rr;
use vars qw($scm_f);
our $scm_f;
sub f {
  my $scm_l1=shift;
  my $scm_l2=shift;
  return   sub {
      sub {
      my $scm____foreach___l;
      $scm____foreach___l=$scm_l1;
      while (not(${
        scm_check_list($scm_null_V_->($scm____foreach___l))
      })) {
          sub  {
          my $scm_x=shift;
          return ${
            scm_check_list($scm_println->($scm_x))
          };
          
        }->(${
          scm_check_list($scm_car->($scm____foreach___l))
        });
          $scm____foreach___l=${
          scm_check_list($scm_cdr->($scm____foreach___l))
        };
        
      }return 1;
      
    }->();
    ;
    return   sub {
      my $scm____foreach___l;
      $scm____foreach___l=$scm_l2;
      while (not(${
        scm_check_list($scm_null_V_->($scm____foreach___l))
      })) {
          sub  {
          my $scm_x=shift;
          return ${
            scm_check_list($scm_println->($scm_x))
          };
          
        }->(${
          scm_check_list($scm_car->($scm____foreach___l))
        });
          $scm____foreach___l=${
          scm_check_list($scm_cdr->($scm____foreach___l))
        };
        
      }return 1;
      
    }->();
    ;
    
  }->();
  
};
$scm_f=\&f;
;
sub r($) {
   return $_[0]*2;
   
} our $scm_r=\&r;
use vars qw($scm_rr);
our $scm_rr;
sub rr {
  my $scm_x=shift;
  return ${
    scm_check_list($scm_r->($scm_x))
  };
  
};
$scm_rr=\&rr;
;
1;
;
