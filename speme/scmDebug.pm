package scmDebug;
use strict;
use Exporter;
use vars qw(@ISA @EXPORT @EXPORT_OK $VERSION);

$VERSION = '0.1';

@ISA = qw/ Exporter /;
@EXPORT = qw(debug warning info $scm_debug set_debug);

my $DEBUG=0;

sub set_debug {
  my $a=shift;
  if (defined($a)) { $DEBUG=$a; }
  return $DEBUG;
}
our $scm_debug=\&set_debug;

sub debug {
	if ($DEBUG) { print "debug:";print  @_; }
}

sub info {
	print "info:";print @_;
}

sub warning {
	print "warn:";print @_;
}

1;


