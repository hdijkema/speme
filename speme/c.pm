package c;
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
@EXPORT = qw($scm_sin );
use vars qw($scm_sin);$scm_sin=\&sin;
use vars qw($scm_sin);our $scm_sin;sub sin {
my $scm_x=shift;
return 4;
}
;
$scm_sin=\&sin;
;
1;
;
