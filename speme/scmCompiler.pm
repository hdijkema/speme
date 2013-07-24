package scmCompiler;
use strict;
use Exporter;
use vars qw(@ISA @EXPORT @EXPORT_OK $VERSION);
use Scalar::Util qw(looks_like_number);

use scmOperators;
use scmReadEvalPrint;
use scmDebug;
#use Perl::Tidy;

$VERSION = '0.1';

@ISA = qw/ Exporter /;
@EXPORT = qw(
             $scm_load $scm_compile 
            );

our $scm_load=sub {
  my $file=shift;
  my $compiled=0;
  print "loading: $file\n";
  if (not($compiled)) {
    open my $fh,"<$file";
    my $e=new scmReadEvalPrint($fh);
    $e->set_name($file);
    $e->readEvalLoop();
    close $fh;
  }
};



sub compile {
  while (my $file=shift) {
	  info("compile: $file\n");

	  if (not($file=~/[.]scm$/)) {
		$file.=".scm";
	  }

	  my $fileout=$file;
	  $fileout=~s/[.]scm$/.tmp/;
	  my $filedest=$file;
	  $filedest=~s/[.]scm$/.pm/;
	  open my $fh,"<$file";
	  open my $fout,">$fileout";
	  my $e=new scmReadEvalPrint($fh);
	  $e->set_name($fileout);
	  $e->set_scm_name($file);
	  $e->set_compile_handle($fout);
	  $e->readEvalLoop();
	  close $fh;
	  close $fout;
	  open $fh,"<$fileout";
	  my $src="";
	  while (<$fh>) { $src.=$_; }
	  close($fh);
	  #print $src;
	  my $dest=tidy($src);
	  print $dest;
	  open $fh,">$filedest";
	  print $fh $dest;
	  close($fh);
	  unlink($fileout);
	}
};
our $scm_compile=\&compile;


sub tidy {
	my $src=shift;
	my $i=0;
	my $N=length($src);
	my $t="";
	my $instring=0;
	my @S;
	while ($i<$N) {
		if (substr($src,$i,2) eq "\\\"") {
			 $t.="\\\"";
			 $i+=2; 
		} elsif (substr($src,$i,1) eq "\"") {
			$instring=not($instring);
			$t.="\"";
			$i+=1;
		} elsif ($instring) {
			$t.=substr($src,$i,1);
			$i+=1;
		} elsif (substr($src,$i,1) eq ";") {
			push @S,$t;
			push @S,";";
			$t="";
			$i+=1;
		} elsif (substr($src,$i,1) eq "\n") {
			$i+=1;
		} elsif (substr($src,$i,1)=~/[{}]/) {
			push @S,$t;
			push @S,substr($src,$i,1);
			$t="";
			$i+=1; 
	    } else {
			$t.=substr($src,$i,1);
			$i+=1;
		} 
	}
	push @S,$t;
	print @S,"\n";
	print scalar(@S),"\n";
	my $res="";
	my $indent=0;
	foreach my $token (@S) {
		print $token;
		if ($token eq "{") { $res.=$token;$indent+=2;$res.="\n".indent($indent); }
		elsif ($token eq "}") { $indent-=2;$res.="\n".indent($indent).$token; }
		elsif ($token eq ";") { $res.=$token;$res.="\n".indent($indent); }
		else { $res.=$token; }
	}
	return $res;
}

sub indent {
	return " " x shift;
}

1;
