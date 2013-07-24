package scmVersion;
use strict;
use Exporter;
use vars qw(@ISA @EXPORT @EXPORT_OK $VERSION);

$VERSION = '1.0';

@ISA = qw/ Exporter /;
@EXPORT = qw($scm___VERSION__);

sub VERSION() {
  return "0.0.2";
}
our $scm___VERSION__=\&VERSION;

1;



