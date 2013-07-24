our $scm_f=sub {
my $scm_x=shift;
return sub {my $scm_y;$scm_y=3;
my $scm_z;$scm_z=2;
return $scm_times->($scm_x,$scm_y,$scm_z);}->();
}
;;
$scm_println->($scm_f->(10));
