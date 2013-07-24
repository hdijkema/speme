package ss;
use strict;
use Exporter;
use vars qw(@ISA @EXPORT @EXPORT_OK $VERSION);
$VERSION="0.1";
@ISA = qw/ Exporter /;
@EXPORT = qw($scm_q $scm_stdout $a $b);

sub scm_check_list {
	#print scalar(@_),"\n";
	if (scalar(@_)>1) {
		my $q=list(@_);
		return \$q;
	} else {
		return \$_[0];
	}
}

use vars qw($scm_stdout);
our $scm_stdout=${
  scm_check_list(sub {
     return *STDOUT;
     
  }->())
};

use vars qw($scm_q);
our $scm_q=sub {
  return "Q!";
};

print "ja scm_stdout=$scm_stdout\n";

use vars qw($a);
our $a="hi!";

use vars qw($b);
our $b=\*STDOUT;


1;
