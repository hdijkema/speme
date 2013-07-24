package q;
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
@EXPORT = qw();
use vars qw($scm_f);
$scm_f=\&f;
use vars qw($scm_main);
$scm_main=\&main;
use vars qw($scm_f);
our $scm_f;
sub f {
  my $scm_x=shift;
  return ${
    scm_check_list($scm__S_->($scm_x,$scm_x))
  };
  
};
$scm_f=\&f;
;
;
use vars qw($scm_main);
our $scm_main;
sub main {
  ${
    scm_check_list($scm_println->(${
      scm_check_list($scm_f->(3))
    }))
  };
  return ${
    scm_check_list($scm_exit->(0))
  };
  
};
$scm_main=\&main;
;
;
${
  scm_check_list($scm_main->())
};
1;
;
