our $scm_f=sub {
my $scm_x=shift;
return sub {my $scm_y;$scm_y=($scm_equal_V_->($scm_x,3)) ? $scm_times->($scm_x,$scm_x) : $scm_x;
;
my $scm_z;$scm_z=2;
return $scm_times->($scm_x,$scm_y,$scm_z);}->();
}
;;
$scm_println->($scm_f->(10));
$scm_println->($scm_f->(3));
