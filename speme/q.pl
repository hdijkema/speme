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
${
  scm_check_list($scm_println->(${
    scm_check_list($scm_f->(3))
  }))
};
