package scmGtk2;
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
@EXPORT = qw($scm_gtk_M_main $scm_gtk_M_main_M_quit );
use vars qw($scm_gtk_M_main);
$scm_gtk_M_main=\&gtk_M_main;
use vars qw($scm_gtk_M_main_M_quit);
$scm_gtk_M_main_M_quit=\&gtk_M_main_M_quit;
use Gtk2 "-init";
use vars qw($scm_gtk_M_main);
our $scm_gtk_M_main;
sub gtk_M_main {
  return eval("Gtk2->main");
  
};
$scm_gtk_M_main=\&gtk_M_main;
;
use vars qw($scm_gtk_M_main_M_quit);
our $scm_gtk_M_main_M_quit;
sub gtk_M_main_M_quit {
  return eval("Gtk2->main_quit");
  
};
$scm_gtk_M_main_M_quit=\&gtk_M_main_M_quit;
;
1;
;
