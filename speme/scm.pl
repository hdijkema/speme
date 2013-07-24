#!/usr/bin/perl;
use strict;
use scmReadEvalPrint;
use scmOperators;
use scmCompiler;
use scmDebug;
use scmCore;

#######################################################################
# Evaluate speme variables in the main context
#######################################################################

sub eval_func {
	my $code=shift;
	my $result=eval("$code"); 
	if ($@) { print "Error: $@\n" }; 
	return $result;
}

sub qeval_func {
	my $code=shift;
	my $result=eval("$code");
	return $result;
}

set_eval_func(\&eval_func);
set_qeval_func(\&qeval_func);

#######################################################################
# Start the speme interpreter or compiler
#######################################################################

my $option=shift @ARGV;
if ($option eq "--version") {
	eval('print $scm_speme_M_version->(),"\n";');
	exit(0);
} elsif ($option eq "--compile") {
	hello();
  perl_set_argv(@ARGV);
	foreach my $module (@ARGV) {
		scmCompiler::compile($module);
	}
} elsif ($option eq "--help") {
    usage();
    exit(0);
} elsif ($option eq "--exec") {
    my $script=$ARGV[0];
    perl_set_argv(@ARGV);
    my $scm=new scmReadEvalPrint();
    while (1) {
    	$scm->readEvalLoop("(load \"$script\")");
    }
} elsif ($option=~/^[-]/) {
	print "\n";
	print "Error: don't know option '$option'\n";
	print "\n";
	usage();
	exit(1);
} else {
	hello();
    perl_set_argv(@ARGV);
	my $scm=new scmReadEvalPrint();
	while (1) {
		$scm->readEvalLoop();
	}
	exit(0);
} 

#######################################################################
# Supporting stuff
#######################################################################

sub hello {
	eval('print $scm_speme_M_name->().
	         " - ".$scm_speme_M_copyright->().
    	     " - version: ".$scm_speme_M_version->()."\n";');
}

sub usage {
	hello();
	print "\nusage:\n  $0 --compile <module> [modules]\n  $0 --version\n  $0 --help\n  $0 --exec <scheme script>\n  $0\n\n";
}

