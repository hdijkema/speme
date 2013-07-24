package b;
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
@EXPORT = qw($scm_log $scm_sin $scm_lg );
use vars qw($scm_sin);$scm_sin=\&sin;
use vars qw($scm_lg);$scm_lg=\&lg;
use vars qw($scm_sin);our $scm_sin;sub sin {
my $scm_a=shift;
return sin($scm_a);
}
;
$scm_sin=\&sin;
;use vars qw($scm_log);our $scm_log=sub { return log(@_); };
use vars qw($scm_lg);our $scm_lg;sub lg {
my $scm_x=shift;
return $scm_log->($scm_x);
}
;
$scm_lg=\&lg;
;
1;
;
