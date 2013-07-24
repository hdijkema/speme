our $scm_f=sub {
my $scm_x=shift;
return ($scm_n_gt->($scm_x,0)) ? $scm_cons->($scm_x,$scm_f->($scm_min->($scm_x,1))) : [];
;
}
;;
our $scm_g=sub {
my $scm_x=shift;
return sub {my $scm_m;$scm_m=sub {
my $scm_y=shift;
return ($scm_n_gt->($scm_y,0)) ? $scm_cons->($scm_y,$scm_m->($scm_min->($scm_y,1))) : [];
;
}
;
return $scm_m->($scm_times->($scm_x,$scm_x));}->();
}
;;
$scm_println->($scm_f->(0));
$scm_println->($scm_f->(10));
$scm_println->($scm_g->(0));
$scm_println->($scm_g->(1));
$scm_println->($scm_g->(2));
$scm_println->($scm_f->(10));
$scm_println->($scm_g->(10));
