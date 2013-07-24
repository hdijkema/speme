package scmCore;
use strict;
use scmOperators;
use scmSyntax;
use scmSExpr;
use scmDebug;
use Exporter;
use vars qw(@ISA @EXPORT @EXPORT_OK $VERSION);
$VERSION="0.1";
@ISA = qw/ Exporter /;
@EXPORT = qw($scm_cddr $scm_cadr $scm_cdar $scm_caar $scm_cdddr $scm_caddr $scm_cdadr $scm_cddar $scm_caadr $scm_cadar $scm_cdaar $scm_caaar $scm_cddddr $scm_cadddr $scm_cdaddr $scm_cddadr $scm_cdddar $scm_caaddr $scm_cadadr $scm_cdadar $scm_cdaadr $scm_cddaar $scm_caaadr $scm_caadar $scm_cadaar $scm_cdaaar $scm_caaaar $scm_list_V_ $scm_empty_V_ $scm_pair_V_ $scm_null_V_ $scm_vector_V_ $scm_make_M_vector $scm_vector_M_ref $scm_vector_M_set_E_ $scm_vector_M_length $scm_vector_M_fill $scm_vector_M__G_list $scm_list_M__G_vector $scm_string_L__Q__V_ $scm_string_G__V_ $scm_string_G__Q__V_ $scm_string_Q__V_ $scm_string_L__V_ $scm_string_M_append $scm_string_M_trim $scm_chop $scm_chr $scm_chomp $scm_equal_V_ $scm_symbol_M__G_string $scm_string_M__G_symbol $scm_hash_M_new $scm_hash_M_put $scm_hash_M_get $scm_hash_V_ $scm_hash_M_exists_V_ $scm_hash_M_remove $scm_hash_M_keys $scm_hash_M_each $scm_exit $scm_bless $scm_mapf $scm_regexp $scm_re_M_match $scm_re_M_replace $scm_floor $scm_ceiling $scm_truncate $scm_round $scm_modulo $scm_remainder $scm_quotient $scm_gcd $scm_lcm $scm_max $scm_min $scm_integer_V_ $scm_real_V_ $scm_rational_V_ $scm_complex_V_ $scm_zero_V_ $scm_positive_V_ $scm_negative_V_ $scm_even_V_ $scm_odd_V_ $scm_log $scm_sin $scm_cos $scm_atan2 $scm_defined $scm_env $scm_port_V_ $scm_stdin $scm_stdout $scm_stderr $scm_open $scm_close $scm_eof $scm_readline $scm_display $scm_displayline $scm_newline $scm_write_M_char $scm_write $scm_chdir $scm_chmod $scm_chown $scm_opendir $scm_readdir $scm_closedir $scm_readdir $scm_telldir $scm_rewinddir $scm_seekdir $scm_glob $scm_unlink $scm_rename $scm_is_M_file_V_ $scm_is_M_dir_V_ $scm_test_M_r_V_ $scm_test_M_e_V_ $scm_test_M_f_V_ $scm_test_M_d_V_ $scm_test_M_z_V_ $scm_test_M_x_V_ $scm_test_M_w_V_ $scm_dbmopen $scm_dbmclose $scm_for_M_each $scm_speme_M_author $scm_speme_M_version $scm_speme_M_copyright $scm_speme_M_name );
use vars qw($scm_not_M_part);
use vars qw($scm_cddr);
$scm_cddr=\&cddr;
use vars qw($scm_cadr);
$scm_cadr=\&cadr;
use vars qw($scm_cdar);
$scm_cdar=\&cdar;
use vars qw($scm_caar);
$scm_caar=\&caar;
use vars qw($scm_cdddr);
$scm_cdddr=\&cdddr;
use vars qw($scm_caddr);
use vars qw($scm_cdadr);
use vars qw($scm_cddar);
use vars qw($scm_caadr);
use vars qw($scm_cadar);
use vars qw($scm_cdaar);
use vars qw($scm_caaar);
use vars qw($scm_cddddr);
use vars qw($scm_cadddr);
use vars qw($scm_cdaddr);
use vars qw($scm_cddadr);
use vars qw($scm_cdddar);
use vars qw($scm_caaddr);
use vars qw($scm_cadadr);
use vars qw($scm_caddar);
use vars qw($scm_cdadar);
use vars qw($scm_cdaadr);
use vars qw($scm_cddaar);
use vars qw($scm_caaadr);
use vars qw($scm_caadar);
use vars qw($scm_cadaar);
use vars qw($scm_cdaaar);
use vars qw($scm_caaaar);
use vars qw($scm_list_V_);
$scm_list_V_=\&list_V_;
use vars qw($scm_empty_V_);
$scm_empty_V_=\&empty_V_;
use vars qw($scm_null_V_);
$scm_null_V_=\&null_V_;
use vars qw($scm_pair_V_);
$scm_pair_V_=\&pair_V_;
use vars qw($scm_vector_V_);
$scm_vector_V_=\&vector_V_;
use vars qw($scm_make_M_vector);
$scm_make_M_vector=\&make_M_vector;
use vars qw($scm_vector_M_ref);
$scm_vector_M_ref=\&vector_M_ref;
use vars qw($scm_vector_M_set_E_);
$scm_vector_M_set_E_=\&vector_M_set_E_;
use vars qw($scm_vector_M_length);
$scm_vector_M_length=\&vector_M_length;
use vars qw($scm_vector_M_fill);
$scm_vector_M_fill=\&vector_M_fill;
use vars qw($scm_vector_M__G_list);
$scm_vector_M__G_list=\&vector_M__G_list;
use vars qw($scm_list_M__G_vector);
$scm_list_M__G_vector=\&list_M__G_vector;
use vars qw($scm__sle);
$scm__sle=\&_sle;
use vars qw($scm__sgt);
$scm__sgt=\&_sgt;
use vars qw($scm__sge);
$scm__sge=\&_sge;
use vars qw($scm_sexe);
$scm_sexe=\&sexe;
use vars qw($scm_sexe1);
$scm_sexe1=\&sexe1;
use vars qw($scm_str_M_app);
$scm_str_M_app=\&str_M_app;
use vars qw($scm_string_G__V_);
$scm_string_G__V_=\&string_G__V_;
use vars qw($scm_string_L__V_);
$scm_string_L__V_=\&string_L__V_;
use vars qw($scm_string_Q__V_);
$scm_string_Q__V_=\&string_Q__V_;
use vars qw($scm_string_L__Q__V_);
$scm_string_L__Q__V_=\&string_L__Q__V_;
use vars qw($scm_string_G__Q__V_);
$scm_string_G__Q__V_=\&string_G__Q__V_;
use vars qw($scm_string_M_append);
$scm_string_M_append=\&string_M_append;
use vars qw($scm_triml);
use vars qw($scm_trimr);
use vars qw($scm_string_M_trim);
$scm_string_M_trim=\&string_M_trim;
use vars qw($scm_chop);
$scm_chop=\&chop;
use vars qw($scm_chr);
$scm_chr=\&chr;
use vars qw($scm_chomp);
$scm_chomp=\&chomp;
use vars qw($scm_zero_V_);
$scm_zero_V_=\&zero_V_;
use vars qw($scm_positive_V_);
$scm_positive_V_=\&positive_V_;
use vars qw($scm_negative_V_);
$scm_negative_V_=\&negative_V_;
use vars qw($scm_odd_V_);
$scm_odd_V_=\&odd_V_;
use vars qw($scm_even_V_);
$scm_even_V_=\&even_V_;
use vars qw($scm_abs);
$scm_abs=\&abs;
use vars qw($scm_max);
$scm_max=\&max;
use vars qw($scm_min);
$scm_min=\&min;
use vars qw($scm_int);
$scm_int=\&int;
use vars qw($scm_floor);
$scm_floor=\&floor;
use vars qw($scm_ceiling);
$scm_ceiling=\&ceiling;
use vars qw($scm_truncate);
$scm_truncate=\&truncate;
use vars qw($scm_modulo);
$scm_modulo=\&modulo;
use vars qw($scm_remainder);
$scm_remainder=\&remainder;
use vars qw($scm_quotient);
$scm_quotient=\&quotient;
use vars qw($scm_gcd2);
$scm_gcd2=\&gcd2;
use vars qw($scm_gcd);
$scm_gcd=\&gcd;
use vars qw($scm_lcm2);
$scm_lcm2=\&lcm2;
use vars qw($scm_lcm);
$scm_lcm=\&lcm;
use vars qw($scm_integer_V_);
$scm_integer_V_=\&integer_V_;
use vars qw($scm_real_V_);
$scm_real_V_=\&real_V_;
use vars qw($scm_complex_V_);
$scm_complex_V_=\&complex_V_;
use vars qw($scm_rational_V_);
$scm_rational_V_=\&rational_V_;
use vars qw($scm_sin);
$scm_sin=\&sin;
use vars qw($scm_cos);
$scm_cos=\&cos;
use vars qw($scm_log);
$scm_log=\&log;
use vars qw($scm_atan2);
$scm_atan2=\&atan2;
use vars qw($scm_symbol_M__G_string);
$scm_symbol_M__G_string=\&symbol_M__G_string;
use vars qw($scm_string_M__G_symbol);
$scm_string_M__G_symbol=\&string_M__G_symbol;
use vars qw($scm_hash_M_new);
$scm_hash_M_new=\&hash_M_new;
use vars qw($scm_hash_M_put);
$scm_hash_M_put=\&hash_M_put;
use vars qw($scm_hash_V_);
$scm_hash_V_=\&hash_V_;
use vars qw($scm_hash_M_get);
$scm_hash_M_get=\&hash_M_get;
use vars qw($scm_hash_M_exists_V_);
$scm_hash_M_exists_V_=\&hash_M_exists_V_;
use vars qw($scm_hash_M_remove);
$scm_hash_M_remove=\&hash_M_remove;
use vars qw($scm_hash_M_keys);
$scm_hash_M_keys=\&hash_M_keys;
use vars qw($scm_hash_M_each);
$scm_hash_M_each=\&hash_M_each;
use vars qw($scm_exit);
$scm_exit=\&exit;
use vars qw($scm_bless);
$scm_bless=\&bless;
use vars qw($scm_mapf);
$scm_mapf=\&mapf;
use vars qw($scm_get_M_modifier);
$scm_get_M_modifier=\&get_M_modifier;
use vars qw($scm_make_M_modifier);
$scm_make_M_modifier=\&make_M_modifier;
use vars qw($scm_regexp);
$scm_regexp=\&regexp;
use vars qw($scm_re_M_match);
$scm_re_M_match=\&re_M_match;
use vars qw($scm_re_M_replace);
$scm_re_M_replace=\&re_M_replace;
use vars qw($scm_env);
$scm_env=\&env;
use vars qw($scm_stdout);
use vars qw($scm_stdin);
use vars qw($scm_stderr);
use vars qw($scm_open);
$scm_open=\&open;
use vars qw($scm_port_V_);
$scm_port_V_=\&port_V_;
use vars qw($scm_eof);
$scm_eof=\&eof;
use vars qw($scm_readline);
$scm_readline=\&readline;
use vars qw($scm_write);
$scm_write=\&write;
use vars qw($scm_write_M_char);
$scm_write_M_char=\&write_M_char;
use vars qw($scm_newline);
$scm_newline=\&newline;
use vars qw($scm_display);
$scm_display=\&display;
use vars qw($scm__writeline);
$scm__writeline=\&_writeline;
use vars qw($scm_displayline);
$scm_displayline=\&displayline;
use vars qw($scm_close);
$scm_close=\&close;
use vars qw($scm_chmod);
$scm_chmod=\&chmod;
use vars qw($scm_chown);
$scm_chown=\&chown;
use vars qw($scm_chdir);
$scm_chdir=\&chdir;
use vars qw($scm_opendir);
$scm_opendir=\&opendir;
use vars qw($scm_closedir);
$scm_closedir=\&closedir;
use vars qw($scm_defined);
$scm_defined=\&defined;
use vars qw($scm_glob);
$scm_glob=\&glob;
use vars qw($scm_unlink);
$scm_unlink=\&unlink;
use vars qw($scm_rename);
$scm_rename=\&rename;
use vars qw($scm_readdir);
$scm_readdir=\&readdir;
use vars qw($scm_rewinddir);
$scm_rewinddir=\&rewinddir;
use vars qw($scm_telldir);
$scm_telldir=\&telldir;
use vars qw($scm_seekdir);
$scm_seekdir=\&seekdir;
use vars qw($scm_appl_M_testfile);
$scm_appl_M_testfile=\&appl_M_testfile;
use vars qw($scm_is_M_file_V_);
$scm_is_M_file_V_=\&is_M_file_V_;
use vars qw($scm_is_M_dir_V_);
$scm_is_M_dir_V_=\&is_M_dir_V_;
use vars qw($scm_test_M_f_V_);
$scm_test_M_f_V_=\&test_M_f_V_;
use vars qw($scm_test_M_d_V_);
$scm_test_M_d_V_=\&test_M_d_V_;
use vars qw($scm_test_M_r_V_);
$scm_test_M_r_V_=\&test_M_r_V_;
use vars qw($scm_test_M_e_V_);
$scm_test_M_e_V_=\&test_M_e_V_;
use vars qw($scm_test_M_z_V_);
$scm_test_M_z_V_=\&test_M_z_V_;
use vars qw($scm_test_M_s_V_);
$scm_test_M_s_V_=\&test_M_s_V_;
use vars qw($scm_test_M_l_V_);
$scm_test_M_l_V_=\&test_M_l_V_;
use vars qw($scm_test_M_w_V_);
$scm_test_M_w_V_=\&test_M_w_V_;
use vars qw($scm_test_M_x_V_);
$scm_test_M_x_V_=\&test_M_x_V_;
use vars qw($scm_dbmopen);
$scm_dbmopen=\&dbmopen;
use vars qw($scm_dbmclose);
$scm_dbmclose=\&dbmclose;
use vars qw($scm_for_M_each);
$scm_for_M_each=\&for_M_each;
use vars qw($scm_speme_M_author);
$scm_speme_M_author=\&speme_M_author;
use vars qw($scm_speme_M_version);
$scm_speme_M_version=\&speme_M_version;
use vars qw($scm_speme_M_copyright);
$scm_speme_M_copyright=\&speme_M_copyright;
use vars qw($scm_speme_M_name);
$scm_speme_M_name=\&speme_M_name;
use POSIX;
;
use scmVersion;
;
use File::Glob ":glob";
;
use vars qw($scm_not_M_part);
our $scm_not_M_part="This function is not part of this scheme implementation";
;
use vars qw($scm_cddr);
our $scm_cddr;
sub cddr {
  my $scm_l=shift;
  return $scm_cdr->($scm_cdr->($scm_l));
  
};
$scm_cddr=\&cddr;
;
;
use vars qw($scm_cadr);
our $scm_cadr;
sub cadr {
  my $scm_l=shift;
  return $scm_car->($scm_cdr->($scm_l));
  
};
$scm_cadr=\&cadr;
;
;
use vars qw($scm_cdar);
our $scm_cdar;
sub cdar {
  my $scm_l=shift;
  return $scm_cdr->($scm_car->($scm_l));
  
};
$scm_cdar=\&cdar;
;
;
use vars qw($scm_caar);
our $scm_caar;
sub caar {
  my $scm_l=shift;
  return $scm_car->($scm_car->($scm_l));
  
};
$scm_caar=\&caar;
;
;
use vars qw($scm_cdddr);
our $scm_cdddr;
sub cdddr {
  my $scm_l=shift;
  return $scm_cdr->($scm_cddr->($scm_l));
  
};
$scm_cdddr=\&cdddr;
;
;
use vars qw($scm_caddr);
our $scm_caddr=sub  {
  my $scm_l=shift;
  return $scm_car->($scm_cddr->($scm_l));
  
};
;
use vars qw($scm_cdadr);
our $scm_cdadr=sub  {
  my $scm_l=shift;
  return $scm_cdr->($scm_cadr->($scm_l));
  
};
;
use vars qw($scm_cddar);
our $scm_cddar=sub  {
  my $scm_l=shift;
  return $scm_cdr->($scm_cdar->($scm_l));
  
};
;
use vars qw($scm_caadr);
our $scm_caadr=sub  {
  my $scm_l=shift;
  return $scm_car->($scm_cadr->($scm_l));
  
};
;
use vars qw($scm_cadar);
our $scm_cadar=sub  {
  my $scm_l=shift;
  return $scm_car->($scm_cdar->($scm_l));
  
};
;
use vars qw($scm_cdaar);
our $scm_cdaar=sub  {
  my $scm_l=shift;
  return $scm_cdr->($scm_caar->($scm_l));
  
};
;
use vars qw($scm_caaar);
our $scm_caaar=sub  {
  my $scm_l=shift;
  return $scm_car->($scm_caar->($scm_l));
  
};
;
use vars qw($scm_cddddr);
our $scm_cddddr=sub  {
  my $scm_l=shift;
  return $scm_cdr->($scm_cdddr->($scm_l));
  
};
;
use vars qw($scm_cadddr);
our $scm_cadddr=sub  {
  my $scm_l=shift;
  return $scm_car->($scm_cdddr->($scm_l));
  
};
;
use vars qw($scm_cdaddr);
our $scm_cdaddr=sub  {
  my $scm_l=shift;
  return $scm_cdr->($scm_caddr->($scm_l));
  
};
;
use vars qw($scm_cddadr);
our $scm_cddadr=sub  {
  my $scm_l=shift;
  return $scm_cdr->($scm_cdadr->($scm_l));
  
};
;
use vars qw($scm_cdddar);
our $scm_cdddar=sub  {
  my $scm_l=shift;
  return $scm_cdr->($scm_cddar->($scm_l));
  
};
;
use vars qw($scm_caaddr);
our $scm_caaddr=sub  {
  my $scm_l=shift;
  return $scm_car->($scm_caddr->($scm_l));
  
};
;
use vars qw($scm_cadadr);
our $scm_cadadr=sub  {
  my $scm_l=shift;
  return $scm_car->($scm_cdadr->($scm_l));
  
};
;
use vars qw($scm_caddar);
our $scm_caddar=sub  {
  my $scm_l=shift;
  return $scm_car->($scm_cddar->($scm_l));
  
};
;
use vars qw($scm_cdadar);
our $scm_cdadar=sub  {
  my $scm_l=shift;
  return $scm_cdr->($scm_cadar->($scm_l));
  
};
;
use vars qw($scm_cdaadr);
our $scm_cdaadr=sub  {
  my $scm_l=shift;
  return $scm_cdr->($scm_caadr->($scm_l));
  
};
;
use vars qw($scm_cddaar);
our $scm_cddaar=sub  {
  my $scm_l=shift;
  return $scm_cdr->($scm_cdaar->($scm_l));
  
};
;
use vars qw($scm_caaadr);
our $scm_caaadr=sub  {
  my $scm_l=shift;
  return $scm_car->($scm_caadr->($scm_l));
  
};
;
use vars qw($scm_caadar);
our $scm_caadar=sub  {
  my $scm_l=shift;
  return $scm_car->($scm_cadar->($scm_l));
  
};
;
use vars qw($scm_cadaar);
our $scm_cadaar=sub  {
  my $scm_l=shift;
  return $scm_car->($scm_cdaar->($scm_l));
  
};
;
use vars qw($scm_cdaaar);
our $scm_cdaaar=sub  {
  my $scm_l=shift;
  return $scm_cdr->($scm_caaar->($scm_l));
  
};
;
use vars qw($scm_caaaar);
our $scm_caaaar=sub  {
  my $scm_l=shift;
  return $scm_cdr->($scm_cdddr->($scm_l));
  
};
;
use vars qw($scm_list_V_);
our $scm_list_V_;
sub list_V_ {
  my $scm_x=shift;
  return $scm__seq->($scm_typeof->($scm_x),"list");
  
};
$scm_list_V_=\&list_V_;
;
;
use vars qw($scm_empty_V_);
our $scm_empty_V_;
sub empty_V_ {
  my $scm_x=shift;
  return ( ($scm_list_V_->($scm_x)) ? $scm__Q_->($scm_length->($scm_x),0) : sub {
     die "argument is no list"."\nin file 'scmCore.scm', in function 'empty?', at line 93\nperl:";
     
  }->());
  
};
$scm_empty_V_=\&empty_V_;
;
;
use vars qw($scm_null_V_);
our $scm_null_V_;
sub null_V_ {
  my $scm_x=shift;
  return $scm_empty_V_->($scm_x);
  
};
$scm_null_V_=\&null_V_;
;
;
use vars qw($scm_pair_V_);
our $scm_pair_V_;
sub pair_V_ {
  my $scm_x=shift;
  return $scm_list_V_->($scm_x);
  
};
$scm_pair_V_=\&pair_V_;
;
;
use vars qw($scm_vector_V_);
our $scm_vector_V_;
sub vector_V_ {
  my $scm_x=shift;
  return $scm_perl_is_v->($scm_x);
  
};
$scm_vector_V_=\&vector_V_;
;
;
use vars qw($scm_make_M_vector);
our $scm_make_M_vector;
sub make_M_vector {
  my $scm_k=shift;
  my $scm_fill=list(@_);
  return ( ($scm_null_V_->($scm_fill)) ? $scm_perl_vn->($scm_k,0) : $scm_perl_vn->($scm_k,$scm_car->($scm_fill)));
  
};
$scm_make_M_vector=\&make_M_vector;
;
;
use vars qw($scm_vector_M_ref);
our $scm_vector_M_ref;
sub vector_M_ref {
  my $scm_v=shift;
  my $scm_index=shift;
  return $scm_perl_vg->($scm_v,$scm_index);
  
};
$scm_vector_M_ref=\&vector_M_ref;
;
;
use vars qw($scm_vector_M_set_E_);
our $scm_vector_M_set_E_;
sub vector_M_set_E_ {
  my $scm_v=shift;
  my $scm_index=shift;
  my $scm_val=shift;
  return $scm_perl_vp->($scm_v,$scm_index,$scm_val);
  
};
$scm_vector_M_set_E_=\&vector_M_set_E_;
;
;
use vars qw($scm_vector_M_length);
our $scm_vector_M_length;
sub vector_M_length {
  my $scm_v=shift;
  return $scm_perl_vl->($scm_v);
  
};
$scm_vector_M_length=\&vector_M_length;
;
;
use vars qw($scm_vector_M_fill);
our $scm_vector_M_fill;
sub vector_M_fill {
  my $scm_v=shift;
  my $scm_f=shift;
  return sub {
     my $scm_l;
    $scm_l=$scm_vector_M_length->($scm_v);
    my $id_1;
    $id_1=sub {
      my ($scm_l)=@_;
      my $scm_fill;
      $scm_fill=sub  {
        my $scm_i=shift;
        return ( ($scm__L_->($scm_i,$scm_l)) ? sub {
          $scm_vector_M_set_E_->($scm_v,$scm_i,$scm_f);
          return $scm_fill->($scm__P_->($scm_i,1));
          
        }->() : $scm_v);
        
      };
      ;
      return $scm_fill->(0);
      
    } ;
    return $id_1->($scm_l);
     
  }->();
  
};
$scm_vector_M_fill=\&vector_M_fill;
;
;
use vars qw($scm_vector_M__G_list);
our $scm_vector_M__G_list;
sub vector_M__G_list {
  my $scm_v=shift;
  return sub {
     my $scm_l;
    $scm_l=$scm_vector_M_length->($scm_v);
    my $id_2;
    $id_2=sub {
      my ($scm_l)=@_;
      my $scm_tol;
      $scm_tol=sub  {
        my $scm_i=shift;
        return ( ($scm__L_->($scm_i,$scm_l)) ? $scm_cons->($scm_vector_M_ref->($scm_v,$scm_i),$scm_tol->($scm__P_->($scm_i,1))) : $scm_list->());
        
      };
      ;
      return $scm_tol->(0);
      
    } ;
    return $id_2->($scm_l);
     
  }->();
  
};
$scm_vector_M__G_list=\&vector_M__G_list;
;
;
use vars qw($scm_list_M__G_vector);
our $scm_list_M__G_vector;
sub list_M__G_vector {
  my $scm_l=shift;
  return sub {
     my $scm_len;
    $scm_len=$scm_length->($scm_l);
    my $scm_v;
    $scm_v=$scm_make_M_vector->($scm_length->($scm_l));
    my $id_3;
    $id_3=sub {
      my ($scm_len,$scm_v)=@_;
      return sub {
         my $scm_i;
        $scm_i=0;
        my $scm_r;
        $scm_r=$scm_l;
        my $scm_loop;
        $scm_loop=sub {
          my ($scm_i,$scm_r)=@_;
          return ( ($scm_null_V_->($scm_r)) ? $scm_v : sub {
            $scm_vector_M_set_E_->($scm_v,$scm_i,$scm_car->($scm_r));
            return $scm_loop->($scm__P_->($scm_i,1),$scm_cdr->($scm_r));
            
          }->());
          
        } ;
        return $scm_loop->($scm_i,$scm_r);
         
      }->();
      
    } ;
    return $id_3->($scm_len,$scm_v);
     
  }->();
  
};
$scm_list_M__G_vector=\&list_M__G_vector;
;
;
use vars qw($scm__sle);
our $scm__sle;
sub _sle {
  my $scm_a=shift;
  my $scm_b=shift;
  return (  $scm__slt->($scm_a,$scm_b) || $scm__seq->($scm_a,$scm_b));
  
};
$scm__sle=\&_sle;
;
;
use vars qw($scm__sgt);
our $scm__sgt;
sub _sgt {
  my $scm_a=shift;
  my $scm_b=shift;
  return $scm_not->($scm__sle->($scm_a,$scm_b));
  
};
$scm__sgt=\&_sgt;
;
;
use vars qw($scm__sge);
our $scm__sge;
sub _sge {
  my $scm_a=shift;
  my $scm_b=shift;
  return $scm_not->($scm__slt->($scm_a,$scm_b));
  
};
$scm__sge=\&_sge;
;
;
use vars qw($scm_sexe);
our $scm_sexe;
sub sexe {
  my $scm_f=shift;
  my $scm_l=shift;
  return ( ($scm_empty_V_->($scm_cddr->($scm_l))) ? $scm_f->($scm_car->($scm_l),$scm_cadr->($scm_l)) : (  $scm_f->($scm_car->($scm_l),$scm_cadr->($scm_l)) && $scm_sexe->($scm_f,$scm_cdr->($scm_l))));
  
};
$scm_sexe=\&sexe;
;
;
use vars qw($scm_sexe1);
our $scm_sexe1;
sub sexe1 {
  my $scm_f=shift;
  my $scm_l=shift;
  return ( ($scm_empty_V_->($scm_l)) ? 0 : ( ($scm_empty_V_->($scm_cdr->($scm_l))) ? 0 : $scm_sexe->($scm_f,$scm_l)));
  
};
$scm_sexe1=\&sexe1;
;
;
use vars qw($scm_str_M_app);
our $scm_str_M_app;
sub str_M_app {
  my $scm_l=shift;
  return ( ($scm_empty_V_->($scm_l)) ? "" : $scm_str_cat->($scm_car->($scm_l),$scm_str_M_app->($scm_cdr->($scm_l))));
  
};
$scm_str_M_app=\&str_M_app;
;
;
use vars qw($scm_string_G__V_);
our $scm_string_G__V_;
sub string_G__V_ {
  my $scm_l=list(@_);
  return $scm_sexe1->($scm__sgt,$scm_l);
  
};
$scm_string_G__V_=\&string_G__V_;
;
;
use vars qw($scm_string_L__V_);
our $scm_string_L__V_;
sub string_L__V_ {
  my $scm_l=list(@_);
  return $scm_sexe1->($scm__slt,$scm_l);
  
};
$scm_string_L__V_=\&string_L__V_;
;
;
use vars qw($scm_string_Q__V_);
our $scm_string_Q__V_;
sub string_Q__V_ {
  my $scm_l=list(@_);
  return $scm_sexe1->($scm__seq,$scm_l);
  
};
$scm_string_Q__V_=\&string_Q__V_;
;
;
use vars qw($scm_string_L__Q__V_);
our $scm_string_L__Q__V_;
sub string_L__Q__V_ {
  my $scm_l=list(@_);
  return $scm_sexe1->($scm__sle,$scm_l);
  
};
$scm_string_L__Q__V_=\&string_L__Q__V_;
;
;
use vars qw($scm_string_G__Q__V_);
our $scm_string_G__Q__V_;
sub string_G__Q__V_ {
  my $scm_l=list(@_);
  return $scm_sexe1->($scm__sge,$scm_l);
  
};
$scm_string_G__Q__V_=\&string_G__Q__V_;
;
;
use vars qw($scm_string_M_append);
our $scm_string_M_append;
sub string_M_append {
  my $scm_l=list(@_);
  return $scm_str_M_app->($scm_l);
  
};
$scm_string_M_append=\&string_M_append;
;
;
use vars qw($scm_triml);
our $scm_triml=$scm_regexp->("^\\s+");
;
use vars qw($scm_trimr);
our $scm_trimr=$scm_regexp->("\\s+\$");
;
use vars qw($scm_string_M_trim);
our $scm_string_M_trim;
sub string_M_trim {
  my $scm_s=shift;
  return $scm_re_M_replace->($scm_trimr,$scm_re_M_replace->($scm_triml,$scm_s,""),"");
  
};
$scm_string_M_trim=\&string_M_trim;
;
;
use vars qw($scm_chop);
our $scm_chop;
sub chop {
  my $scm_x=shift;
  return chop($scm_x);
  
};
$scm_chop=\&chop;
;
;
use vars qw($scm_chr);
our $scm_chr;
sub chr {
  my $scm_x=shift;
  return chr($scm_x);
  
};
$scm_chr=\&chr;
;
;
use vars qw($scm_chomp);
our $scm_chomp;
sub chomp {
  my $scm_x=shift;
  return chomp($scm_x);
  
};
$scm_chomp=\&chomp;
;
;
use vars qw($scm_zero_V_);
our $scm_zero_V_;
sub zero_V_ {
  my $scm_x=shift;
  return $scm__Q_->(0,$scm_x);
  
};
$scm_zero_V_=\&zero_V_;
;
;
use vars qw($scm_positive_V_);
our $scm_positive_V_;
sub positive_V_ {
  my $scm_x=shift;
  return $scm__L_->(0,$scm_x);
  
};
$scm_positive_V_=\&positive_V_;
;
;
use vars qw($scm_negative_V_);
our $scm_negative_V_;
sub negative_V_ {
  my $scm_x=shift;
  return $scm__G_->(0,$scm_x);
  
};
$scm_negative_V_=\&negative_V_;
;
;
use vars qw($scm_odd_V_);
our $scm_odd_V_;
sub odd_V_ {
  my $scm_num=shift;
  return $scm__Q_->($scm_modulo->($scm_num,2),1);
  
};
$scm_odd_V_=\&odd_V_;
;
;
use vars qw($scm_even_V_);
our $scm_even_V_;
sub even_V_ {
  my $scm_num=shift;
  return $scm__Q_->($scm_modulo->($scm_num,2),0);
  
};
$scm_even_V_=\&even_V_;
;
;
use vars qw($scm_abs);
our $scm_abs;
sub abs {
  my $scm_a=shift;
  return ( ($scm__L_->($scm_a,0)) ? $scm__S_->(-1,$scm_a) : $scm_a);
  
};
$scm_abs=\&abs;
;
;
use vars qw($scm_max);
our $scm_max;
sub max {
  my $scm_l=list(@_);
  return sub {
     my $scm_max1;
    $scm_max1=sub  {
      my $scm_m=shift;
      my $scm_r=shift;
      return ( ($scm_empty_V_->($scm_r)) ? $scm_m : ( ($scm__G_->($scm_m,$scm_car->($scm_r))) ? $scm_max1->($scm_m,$scm_cdr->($scm_r)) : $scm_max1->($scm_car->($scm_r),$scm_cdr->($scm_r))));
      
    };
    my $id_4;
    $id_4=sub {
      my ($scm_max1)=@_;
      return ( ($scm_empty_V_->($scm_l)) ? sub {
         die "max needs at least 2 arguments"."\nin file 'scmCore.scm', in function 'max', at line 208\nperl:";
         
      }->() : ( ($scm_empty_V_->($scm_cdr->($scm_l))) ? sub {
         die "max needs at least 2 arguments"."\nin file 'scmCore.scm', in function 'max', at line 210\nperl:";
         
      }->() : $scm_max1->($scm_car->($scm_l),$scm_cdr->($scm_l))));
      
    } ;
    return $id_4->($scm_max1);
     
  }->();
  
};
$scm_max=\&max;
;
;
use vars qw($scm_min);
our $scm_min;
sub min {
  my $scm_l=list(@_);
  return sub {
     my $scm_min1;
    $scm_min1=sub  {
      my $scm_m=shift;
      my $scm_r=shift;
      return ( ($scm_empty_V_->($scm_r)) ? $scm_m : ( ($scm__L_->($scm_m,$scm_car->($scm_r))) ? $scm_min1->($scm_m,$scm_cdr->($scm_r)) : $scm_min1->($scm_car->($scm_r),$scm_cdr->($scm_r))));
      
    };
    my $id_5;
    $id_5=sub {
      my ($scm_min1)=@_;
      return ( ($scm_empty_V_->($scm_l)) ? sub {
         die "min needs at least 2 arguments"."\nin file 'scmCore.scm', in function 'min', at line 221\nperl:";
         
      }->() : ( ($scm_empty_V_->($scm_cdr->($scm_l))) ? sub {
         die "min needs at least 2 arguments"."\nin file 'scmCore.scm', in function 'min', at line 223\nperl:";
         
      }->() : $scm_min1->($scm_car->($scm_l),$scm_cdr->($scm_l))));
      
    } ;
    return $id_5->($scm_min1);
     
  }->();
  
};
$scm_min=\&min;
;
;
use vars qw($scm_int);
our $scm_int;
sub int {
  my $scm_a=shift;
  return sub {
     return int(shift);
     
  }->($scm_a);
  
};
$scm_int=\&int;
;
;
use vars qw($scm_floor);
our $scm_floor;
sub floor {
  my $scm_a=shift;
  return POSIX::floor($scm_a);
  
};
$scm_floor=\&floor;
;
;
sub round {
   return ($_[0]<0) ? int($_[0]-0.5) : int($_[0]+0.5);
   
};
our $scm_round=\&round;
use vars qw($scm_round);
;
use vars qw($scm_ceiling);
our $scm_ceiling;
sub ceiling {
  my $scm_a=shift;
  return POSIX::ceil($scm_a);
  
};
$scm_ceiling=\&ceiling;
;
;
use vars qw($scm_truncate);
our $scm_truncate;
sub truncate {
  my $scm_a=shift;
  return ( ($scm__L_->($scm_a,0)) ? $scm__S_->(-1,$scm_floor->($scm__S_->(-1,$scm_a))) : $scm_floor->($scm_a));
  
};
$scm_truncate=\&truncate;
;
;
use vars qw($scm_modulo);
our $scm_modulo;
sub modulo {
  my $scm_a=shift;
  my $scm_b=shift;
  return sub {
     my ($a,$b)=@_;
    return $a%$b;
     
  }->($scm_a,$scm_b);
  
};
$scm_modulo=\&modulo;
;
;
use vars qw($scm_remainder);
our $scm_remainder;
sub remainder {
  my $scm_a=shift;
  my $scm_b=shift;
  return ( ($scm__L_->($scm_a,0)) ? $scm__S_->(-1,$scm_modulo->($scm_abs->($scm_a),$scm_abs->($scm_b))) : $scm_modulo->($scm_abs->($scm_a),$scm_abs->($scm_b)));
  
};
$scm_remainder=\&remainder;
;
;
use vars qw($scm_quotient);
our $scm_quotient;
sub quotient {
  my $scm_a=shift;
  my $scm_b=shift;
  return sub {
     my ($a,$b)=@_;
    return int($a/$b);
     
  }->($scm_a,$scm_b);
  
};
$scm_quotient=\&quotient;
;
;
use vars qw($scm_gcd2);
our $scm_gcd2;
sub gcd2 {
  my $scm_a=shift;
  my $scm_b=shift;
  return ( ($scm__Q_->($scm_b,0)) ? $scm_abs->($scm_a) : $scm_gcd2->($scm_b,$scm_modulo->($scm_a,$scm_b)));
  
};
$scm_gcd2=\&gcd2;
;
;
use vars qw($scm_gcd);
our $scm_gcd;
sub gcd {
  my $scm_l=list(@_);
  return sub {
     my $scm_gcdl;
    $scm_gcdl=sub  {
      my $scm_g=shift;
      my $scm_l=shift;
      return ( ($scm_null_V_->($scm_l)) ? $scm_g : $scm_gcdl->($scm_gcd2->($scm_g,$scm_car->($scm_l)),$scm_cdr->($scm_l)));
      
    };
    my $id_6;
    $id_6=sub {
      my ($scm_gcdl)=@_;
      return ( ($scm_null_V_->($scm_l)) ? 0 : ( ($scm_null_V_->($scm_cdr->($scm_l))) ? sub {
         die "Need at least 2 arguments for gcd"."\nin file 'scmCore.scm', in function 'gcd', at line 267\nperl:";
         
      }->() : $scm_gcdl->($scm_gcd2->($scm_car->($scm_l),$scm_cadr->($scm_l)),$scm_cddr->($scm_l))));
      
    } ;
    return $id_6->($scm_gcdl);
     
  }->();
  
};
$scm_gcd=\&gcd;
;
;
use vars qw($scm_lcm2);
our $scm_lcm2;
sub lcm2 {
  my $scm_a=shift;
  my $scm_b=shift;
  return $scm_abs->($scm__d_->($scm__S_->($scm_a,$scm_b),$scm_gcd2->($scm_a,$scm_b)));
  
};
$scm_lcm2=\&lcm2;
;
;
use vars qw($scm_lcm);
our $scm_lcm;
sub lcm {
  my $scm_l=list(@_);
  return sub {
     my $scm_lcml;
    $scm_lcml=sub  {
      my $scm_m=shift;
      my $scm_l=shift;
      return ( ($scm_null_V_->($scm_l)) ? $scm_m : $scm_lcml->($scm_car->($scm_l),$scm_cdr->($scm_l)));
      
    };
    my $id_7;
    $id_7=sub {
      my ($scm_lcml)=@_;
      return ( ($scm_null_V_->($scm_l)) ? 0 : ( ($scm_null_V_->($scm_cdr->($scm_l))) ? sub {
         die "Need at least 2 arguments for lcm"."\nin file 'scmCore.scm', in function 'lcm', at line 281\nperl:";
         
      }->() : $scm_lcml->($scm_lcm2->($scm_car->($scm_l),$scm_cadr->($scm_l)),$scm_cddr->($scm_l))));
      
    } ;
    return $id_7->($scm_lcml);
     
  }->();
  
};
$scm_lcm=\&lcm;
;
;
use vars qw($scm_integer_V_);
our $scm_integer_V_;
sub integer_V_ {
  my $scm_a=shift;
  return $scm__Q_->($scm_int->($scm_a),$scm_a);
  
};
$scm_integer_V_=\&integer_V_;
;
;
use vars qw($scm_real_V_);
our $scm_real_V_;
sub real_V_ {
  my $scm_a=shift;
  return $scm_not->($scm_integer_V_->($scm_a));
  
};
$scm_real_V_=\&real_V_;
;
;
use vars qw($scm_complex_V_);
our $scm_complex_V_;
sub complex_V_ {
  my $scm_a=shift;
  return sub {
     die $scm_not_M_part."\nin file 'scmCore.scm', in function 'complex?', at line 291\nperl:";
     
  }->();
  
};
$scm_complex_V_=\&complex_V_;
;
;
use vars qw($scm_rational_V_);
our $scm_rational_V_;
sub rational_V_ {
  my $scm_a=shift;
  return sub {
     die $scm_not_M_part."\nin file 'scmCore.scm', in function 'rational?', at line 294\nperl:";
     
  }->();
  
};
$scm_rational_V_=\&rational_V_;
;
;
use vars qw($scm_sin);
our $scm_sin;
sub sin {
  my $scm_x=shift;
  return sin($scm_x);
  
};
$scm_sin=\&sin;
;
;
use vars qw($scm_cos);
our $scm_cos;
sub cos {
  my $scm_x=shift;
  return cos($scm_x);
  
};
$scm_cos=\&cos;
;
;
use vars qw($scm_log);
our $scm_log;
sub log {
  my $scm_x=shift;
  return log($scm_x);
  
};
$scm_log=\&log;
;
;
use vars qw($scm_atan2);
our $scm_atan2;
sub atan2 {
  my $scm_x=shift;
  my $scm_y=shift;
  return atan2($scm_x,$scm_y);
  
};
$scm_atan2=\&atan2;
;
;
use vars qw($scm_symbol_M__G_string);
our $scm_symbol_M__G_string;
sub symbol_M__G_string {
  my $scm_x=shift;
  return ( ($scm_symbol_V_->($scm_x)) ? ((%x::) ? "x" : sub {
     use vars qw($scm_x);
    return $scm_x 
  }->())->tostring() : sub {
     die "type 'symbol' expected"."\nin file 'scmCore.scm', in function 'symbol->string', at line 308\nperl:";
     
  }->());
  
};
$scm_symbol_M__G_string=\&symbol_M__G_string;
;
;
use vars qw($scm_string_M__G_symbol);
our $scm_string_M__G_symbol;
sub string_M__G_symbol {
  my $scm_x=shift;
  return ( ($scm_scalar_V_->($scm_x)) ? ((%scmSymbol::) ? "scmSymbol" : sub {
     use vars qw($scm_scmSymbol);
    return $scm_scmSymbol 
  }->())->new($scm_x) : sub {
     die "type 'scalar' expected"."\nin file 'scmCore.scm', in function 'string->symbol', at line 313\nperl:";
     
  }->());
  
};
$scm_string_M__G_symbol=\&string_M__G_symbol;
;
;
use vars qw($scm_hash_M_new);
our $scm_hash_M_new;
sub hash_M_new {
  return $scm_perl_hn->();
  
};
$scm_hash_M_new=\&hash_M_new;
;
;
use vars qw($scm_hash_M_put);
our $scm_hash_M_put;
sub hash_M_put {
  my $scm_h=shift;
  my $scm_k=shift;
  my $scm_v=shift;
  return $scm_perl_hp->($scm_h,$scm_k,$scm_v);
  
};
$scm_hash_M_put=\&hash_M_put;
;
;
use vars qw($scm_hash_V_);
our $scm_hash_V_;
sub hash_V_ {
  my $scm_h=shift;
  return $scm_perl_is_h->($scm_h);
  
};
$scm_hash_V_=\&hash_V_;
;
;
use vars qw($scm_hash_M_get);
our $scm_hash_M_get;
sub hash_M_get {
  my $scm_h=shift;
  my $scm_k=shift;
  return $scm_perl_hg->($scm_h,$scm_k);
  
};
$scm_hash_M_get=\&hash_M_get;
;
;
use vars qw($scm_hash_M_exists_V_);
our $scm_hash_M_exists_V_;
sub hash_M_exists_V_ {
  my $scm_h=shift;
  my $scm_k=shift;
  return $scm_perl_he->($scm_h,$scm_k);
  
};
$scm_hash_M_exists_V_=\&hash_M_exists_V_;
;
;
use vars qw($scm_hash_M_remove);
our $scm_hash_M_remove;
sub hash_M_remove {
  my $scm_h=shift;
  my $scm_k=shift;
  return $scm_perl_hr->($scm_h,$scm_k);
  
};
$scm_hash_M_remove=\&hash_M_remove;
;
;
use vars qw($scm_hash_M_keys);
our $scm_hash_M_keys;
sub hash_M_keys {
  my $scm_h=shift;
  return $scm_perl_h_keys->($scm_h);
  
};
$scm_hash_M_keys=\&hash_M_keys;
;
;
use vars qw($scm_hash_M_each);
our $scm_hash_M_each;
sub hash_M_each {
  my $scm_h=shift;
  return $scm_perl_h_each->($scm_h);
  
};
$scm_hash_M_each=\&hash_M_each;
;
;
use vars qw($scm_exit);
our $scm_exit;
sub exit {
  my $scm_y=list(@_);
  return ( ($scm_empty_V_->($scm_y)) ? exit(0) : exit($scm_car->($scm_y)));
  
};
$scm_exit=\&exit;
;
;
use vars qw($scm_bless);
our $scm_bless;
sub bless {
  my $scm_obj=shift;
  my $scm_class=shift;
  return bless($scm_obj,$scm_class);
  
};
$scm_bless=\&bless;
;
;
use vars qw($scm_mapf);
our $scm_mapf;
sub mapf {
  my $scm_proc=shift;
  my $scm_lst=shift;
  return ( ($scm_empty_V_->($scm_lst)) ? $scm_list->() : $scm_cons->($scm_proc->($scm_car->($scm_lst)),$scm_mapf->($scm_proc,$scm_cdr->($scm_lst))));
  
};
$scm_mapf=\&mapf;
;
;
use vars qw($scm_equal_V_);
our $scm_equal_V_;
;
$scm_equal_V_=new scmSyntax("equal?",sub {
   my $syntax=shift;
  my $self=shift;
  my $macro_id=shift;
  my @args=@_;
  debug("macro:".$macro_id->value()."\n");
  if ($self->match_pattern($syntax->get_pattern(0),@args)) {
     debug("pattern:0\n");
      my @code=@{
      $self->substitute_macro_arguments($syntax->get_pattern(0),\@args,@{
        $syntax->get_code(0)
      })
    };
      my $res="";
      while (my $sexpr=shift @code) {
             $sexpr->linenr($self->linenr());
      debug("res=$res\n");
            if (scalar(@code)==0) {
         $res.="  ";
         
      } $res.=$self->evaluate($sexpr);
        
    }  debug("res=$res\n");
      return $res;
    
  }elsif ($self->match_pattern($syntax->get_pattern(1),@args)) {
     debug("pattern:1\n");
      my @code=@{
      $self->substitute_macro_arguments($syntax->get_pattern(1),\@args,@{
        $syntax->get_code(1)
      })
    };
      my $res="";
      while (my $sexpr=shift @code) {
             $sexpr->linenr($self->linenr());
      debug("res=$res\n");
            if (scalar(@code)==0) {
         $res.="  ";
         
      } $res.=$self->evaluate($sexpr);
        
    }  debug("res=$res\n");
      return $res;
    
  }else {
     die "Macro: equal?: no pattern matched while applying macro";
     
  }
},sub {
   my $self=shift;
  $self->set_pattern(0,new scmSExpr()->list(new scmSExpr()->generic("identifier","_"),new scmSExpr()->generic("identifier","a"),new scmSExpr()->generic("identifier","b")));
  $self->set_pattern(1,new scmSExpr()->list(new scmSExpr()->generic("identifier","_"),new scmSExpr()->generic("identifier","a"),new scmSExpr()->generic("identifier","b"),new scmSExpr()->generic("identifier","...")));
  
},sub {
   my $self=shift;
  $self->set_code(0,[new scmSExpr()->list(new scmSExpr()->generic("identifier","string=?"),new scmSExpr()->list(new scmSExpr()->generic("identifier","tostring"),new scmSExpr()->generic("identifier","a")),new scmSExpr()->list(new scmSExpr()->generic("identifier","tostring"),new scmSExpr()->generic("identifier","b")))]);
  $self->set_code(1,[new scmSExpr()->list(new scmSExpr()->generic("identifier","string=?"),new scmSExpr()->list(new scmSExpr()->generic("identifier","tostring"),new scmSExpr()->generic("identifier","a")),new scmSExpr()->list(new scmSExpr()->generic("identifier","tostring"),new scmSExpr()->generic("identifier","b")),new scmSExpr()->list(new scmSExpr()->generic("identifier","tostring"),new scmSExpr()->generic("identifier","...")))]);
  
});
;
use vars qw($scm_get_M_modifier);
our $scm_get_M_modifier;
sub get_M_modifier {
  my $scm_tok=shift;
  return ( (perl_is_eq_V_($scm_tok,new scmSymbol("glob"))) ? "g" : ( (perl_is_eq_V_($scm_tok,new scmSymbol("insensitive"))) ? "i" : ( (perl_is_eq_V_($scm_tok,new scmSymbol("g"))) ? "g" : ( (perl_is_eq_V_($scm_tok,new scmSymbol("i"))) ? "i" : sub {
     die $scm_string_M_append->("Unknown modifier ",$scm_tostring->($scm_tok))."\nin file 'scmCore.scm', in function 'get-modifier', at line 370\nperl:";
     
  }->()))));
  
};
$scm_get_M_modifier=\&get_M_modifier;
;
;
use vars qw($scm_make_M_modifier);
our $scm_make_M_modifier;
sub make_M_modifier {
  my $scm_l=shift;
  return ( ($scm_empty_V_->($scm_l)) ? "" : $scm_string_M_append->($scm_get_M_modifier->($scm_car->($scm_l)),$scm_make_M_modifier->($scm_cdr->($scm_l))));
  
};
$scm_make_M_modifier=\&make_M_modifier;
;
;
use vars qw($scm_regexp);
our $scm_regexp;
sub regexp {
  my $scm_e=shift;
  my $scm_modifier=list(@_);
  return $scm_perl_M_re->($scm_e,$scm_make_M_modifier->($scm_modifier));
  
};
$scm_regexp=\&regexp;
;
;
use vars qw($scm_re_M_match);
our $scm_re_M_match;
sub re_M_match {
  my $scm_re=shift;
  my $scm_str=shift;
  my $scm_modifier=list(@_);
  return $scm_perl_M_re_M_match->($scm_re,$scm_str,$scm_make_M_modifier->($scm_modifier));
  
};
$scm_re_M_match=\&re_M_match;
;
;
use vars qw($scm_re_M_replace);
our $scm_re_M_replace;
sub re_M_replace {
  my $scm_re=shift;
  my $scm_str=shift;
  my $scm_repl=shift;
  my $scm_modifier=list(@_);
  return $scm_perl_M_re_M_replace->($scm_re,$scm_str,$scm_repl,$scm_make_M_modifier->($scm_modifier));
  
};
$scm_re_M_replace=\&re_M_replace;
;
;
use vars qw($scm_env);
our $scm_env;
sub env {
  my $scm_e=shift;
  return ( ($scm_symbol_V_->($scm_e)) ? $scm_env->($scm_symbol_M__G_string->($scm_e)) : sub {
     my $e=shift;
    return $ENV{
      $e
    };
     
  }->($scm_e));
  
};
$scm_env=\&env;
;
;
use vars qw($scm_stdout);
our $scm_stdout=sub {
   return \*STDOUT;
   
}->();
;
use vars qw($scm_stdin);
our $scm_stdin=sub {
   return \*STDIN;
   
}->();
;
use vars qw($scm_stderr);
our $scm_stderr=sub {
   return \*STDERR;
   
}->();
;
use vars qw($scm_open);
our $scm_open;
sub open {
  my $scm_description=shift;
  return sub {
     my $d=shift;
    open my $fh,$d;
    return $fh 
  }->($scm_description);
  
};
$scm_open=\&open;
;
;
use vars qw($scm_port_V_);
our $scm_port_V_;
sub port_V_ {
  my $scm_fd=shift;
  return $scm_string_Q__V_->(ref($scm_fd),"GLOB");
  
};
$scm_port_V_=\&port_V_;
;
;
use vars qw($scm_eof);
our $scm_eof;
sub eof {
  my $scm_fd=shift;
  return eof($scm_fd);
  
};
$scm_eof=\&eof;
;
;
use vars qw($scm_readline);
our $scm_readline;
sub readline {
  my $scm_fd=shift;
  return sub {
     my $fd=shift;
    my $line=<$fd>;
    return $line;
     
  }->($scm_fd);
  
};
$scm_readline=\&readline;
;
;
use vars qw($scm_write);
our $scm_write;
sub write {
  my $scm_obj=shift;
  my $scm_port=list(@_);
  return sub {
     die "write is Not implemented yet"."\nin file 'scmCore.scm', in function 'write', at line 420\nperl:";
     
  }->();
  
};
$scm_write=\&write;
;
;
use vars qw($scm_write_M_char);
our $scm_write_M_char;
sub write_M_char {
  my $scm_c=shift;
  my $scm_port=list(@_);
  return ( ($scm_null_V_->($scm_port)) ? $scm_display->($scm_c) : $scm_display->($scm_c,$scm_car->($scm_port)));
  
};
$scm_write_M_char=\&write_M_char;
;
;
use vars qw($scm_newline);
our $scm_newline;
sub newline {
  my $scm_port=list(@_);
  return ( ($scm_null_V_->($scm_port)) ? $scm_display->("\n",$scm_stdout) : $scm_display->("\n",$scm_car->($scm_port)));
  
};
$scm_newline=\&newline;
;
;
use vars qw($scm_display);
our $scm_display;
sub display {
  my $scm_obj=shift;
  my $scm_port=list(@_);
  return ( ($scm_null_V_->($scm_port)) ? $scm_display->($scm_obj,$scm_stdout) : sub {
     my $fd=shift;
    my $obj=shift;
    print $fd $obj;
     
  }->($scm_car->($scm_port),$scm_obj));
  
};
$scm_display=\&display;
;
;
use vars qw($scm__writeline);
our $scm__writeline;
sub _writeline {
  my $scm_fd=shift;
  my $scm_stuff=shift;
  return sub {
     my $scm_writer;
    $scm_writer=sub  {
      my $scm_elem=shift;
      return $scm_display->($scm_elem,$scm_fd);
      
    };
    my $id_8;
    $id_8=sub {
      my ($scm_writer)=@_;
      $scm_for_M_each->($scm_writer,$scm_stuff);
      $scm_writer->("\n");
      return $scm_fd;
      
    } ;
    return $id_8->($scm_writer);
     
  }->();
  
};
$scm__writeline=\&_writeline;
;
;
use vars qw($scm_displayline);
our $scm_displayline;
sub displayline {
  my $scm_stuff=list(@_);
  return ( ($scm_null_V_->($scm_stuff)) ? $scm__writeline->($scm_stdout,$scm_stuff) : ( ($scm_port_V_->($scm_car->($scm_stuff))) ? $scm__writeline->($scm_car->($scm_stuff),$scm_cdr->($scm_stuff)) : $scm__writeline->($scm_stdout,$scm_stuff)));
  
};
$scm_displayline=\&displayline;
;
;
use vars qw($scm_close);
our $scm_close;
sub close {
  my $scm_fd=shift;
  return close($scm_fd);
  
};
$scm_close=\&close;
;
;
use vars qw($scm_chmod);
our $scm_chmod;
sub chmod {
  my $scm_x=shift;
  my $scm_f=list(@_);
  return sub {
     my $scm_chm;
    $scm_chm=sub  {
      my $scm_l=shift;
      return ( ($scm_null_V_->($scm_l)) ? 1 : sub {
        chmod($scm_x,$scm_car->($scm_l));
        return $scm_chm->($scm_cdr->($scm_l));
        
      }->());
      
    };
    my $id_9;
    $id_9=sub {
      my ($scm_chm)=@_;
      return $scm_chm->($scm_f);
      
    } ;
    return $id_9->($scm_chm);
     
  }->();
  
};
$scm_chmod=\&chmod;
;
;
use vars qw($scm_chown);
our $scm_chown;
sub chown {
  my $scm_u=shift;
  my $scm_g=shift;
  my $scm_f=list(@_);
  return sub {
     my $scm_cho;
    $scm_cho=sub  {
      my $scm_l=shift;
      return ( ($scm_null_V_->($scm_l)) ? 1 : sub {
        chown($scm_u,$scm_g,$scm_car->($scm_l));
        return $scm_cho->($scm_cdr->($scm_l));
        
      }->());
      
    };
    my $id_10;
    $id_10=sub {
      my ($scm_cho)=@_;
      return $scm_cho->($scm_f);
      
    } ;
    return $id_10->($scm_cho);
     
  }->();
  
};
$scm_chown=\&chown;
;
;
use vars qw($scm_chdir);
our $scm_chdir;
sub chdir {
  my $scm_d=shift;
  return chdir($scm_d);
  
};
$scm_chdir=\&chdir;
;
;
use vars qw($scm_opendir);
our $scm_opendir;
sub opendir {
  my $scm_d=shift;
  return sub {
     my $expr=shift;
    opendir(my $fh,$expr);
    return $fh;
     
  }->($scm_d);
  
};
$scm_opendir=\&opendir;
;
;
use vars qw($scm_closedir);
our $scm_closedir;
sub closedir {
  my $scm_dh=shift;
  return closedir($scm_dh);
  
};
$scm_closedir=\&closedir;
;
;
use vars qw($scm_defined);
our $scm_defined;
sub defined {
  my $scm_x=shift;
  return defined($scm_x);
  
};
$scm_defined=\&defined;
;
;
use vars qw($scm_glob);
our $scm_glob;
sub glob {
  my $scm_pattern=shift;
  my $scm_flags=list(@_);
  return sub {
     my $scm_p;
    $scm_p=( ($scm_symbol_V_->($scm_pattern)) ? $scm_symbol_M__G_string->($scm_pattern) : $scm_pattern);
    my $id_11;
    $id_11=sub {
      my ($scm_p)=@_;
      return sub {
         my $scm_result;
        $scm_result=( ($scm_null_V_->($scm_flags)) ? list(bsd_glob($scm_p)) : ( (perl_is_eq_V_(sub {
           my $v=$scm_car->($scm_flags);
          if (ref($v)) {
             return $v;
             
          } else {
             return \$v;
             
          } 
        }->(),new scmSymbol("nocase"))) ? list(sub {
           my @r=return bsd_glob(@_,GLOB_NOCASE|GLOB_NOSORT);
          return @r;
           
        }->($scm_p)) : list(bsd_glob($scm_p))));
        my $id_12;
        $id_12=sub {
          my ($scm_result)=@_;
          return ( ($scm_defined->($scm_result)) ? $scm_result : $scm_list->());
          
        } ;
        return $id_12->($scm_result);
         
      }->();
      
    } ;
    return $id_11->($scm_p);
     
  }->();
  
};
$scm_glob=\&glob;
;
;
use vars qw($scm_unlink);
our $scm_unlink;
sub unlink {
  my $scm_filename=shift;
  return unlink($scm_filename);
  
};
$scm_unlink=\&unlink;
;
;
use vars qw($scm_rename);
our $scm_rename;
sub rename {
  my $scm_filename1=shift;
  my $scm_filename2=shift;
  return rename($scm_filename1,$scm_filename2);
  
};
$scm_rename=\&rename;
;
;
use vars qw($scm_readdir);
our $scm_readdir;
sub readdir {
  my $scm_dh=shift;
  my $scm_filterfunction=list(@_);
  return ( ($scm_null_V_->($scm_filterfunction)) ? sub {
     my $scm_rd;
    $scm_rd=sub  {
      return sub {
         my $scm_f;
        $scm_f=readdir($scm_dh);
        my $id_14;
        $id_14=sub {
          my ($scm_f)=@_;
          return ( ($scm_f) ? $scm_cons->($scm_f,$scm_rd->()) : $scm_list->());
          
        } ;
        return $id_14->($scm_f);
         
      }->();
      
    };
    my $id_13;
    $id_13=sub {
      my ($scm_rd)=@_;
      return $scm_rd->();
      
    } ;
    return $id_13->($scm_rd);
     
  }->() : sub {
     my $scm_filter;
    $scm_filter=$scm_car->($scm_filterfunction);
    my $scm_rd;
    $scm_rd=sub  {
      return sub {
         my $scm_f;
        $scm_f=readdir($scm_dh);
        my $id_16;
        $id_16=sub {
          my ($scm_f)=@_;
          return ( ($scm_f) ? ( ($scm_filter->($scm_f)) ? $scm_cons->($scm_f,$scm_rd->()) : $scm_rd->()) : $scm_list->());
          
        } ;
        return $id_16->($scm_f);
         
      }->();
      
    };
    my $id_15;
    $id_15=sub {
      my ($scm_filter,$scm_rd)=@_;
      return $scm_rd->();
      
    } ;
    return $id_15->($scm_filter,$scm_rd);
     
  }->());
  
};
$scm_readdir=\&readdir;
;
;
use vars qw($scm_rewinddir);
our $scm_rewinddir;
sub rewinddir {
  my $scm_dh=shift;
  return rewinddir($scm_dh);
  
};
$scm_rewinddir=\&rewinddir;
;
;
use vars qw($scm_telldir);
our $scm_telldir;
sub telldir {
  my $scm_dh=shift;
  return telldir($scm_dh);
  
};
$scm_telldir=\&telldir;
;
;
use vars qw($scm_seekdir);
our $scm_seekdir;
sub seekdir {
  my $scm_dh=shift;
  my $scm_pos=shift;
  return seekdir($scm_dh,$scm_pos);
  
};
$scm_seekdir=\&seekdir;
;
;
use vars qw($scm_appl_M_testfile);
our $scm_appl_M_testfile;
sub appl_M_testfile {
  my $scm_tester=shift;
  my $scm_f=shift;
  my $scm_l=shift;
  return ( ($scm_tester->($scm_f)) ? ( ($scm_null_V_->($scm_l)) ? 1 : $scm_appl_M_testfile->($scm_tester,$scm_car->($scm_l),$scm_cdr,$scm_l)) : 0);
  
};
$scm_appl_M_testfile=\&appl_M_testfile;
;
;
use vars qw($scm_is_M_file_V_);
our $scm_is_M_file_V_;
sub is_M_file_V_ {
  my $scm_f=shift;
  my $scm_l=list(@_);
  return $scm_appl_M_testfile->(sub  {
    my $scm_x=shift;
    return -f($scm_x);
    
  },$scm_f,$scm_l);
  
};
$scm_is_M_file_V_=\&is_M_file_V_;
;
;
use vars qw($scm_is_M_dir_V_);
our $scm_is_M_dir_V_;
sub is_M_dir_V_ {
  my $scm_d=shift;
  my $scm_l=list(@_);
  return $scm_appl_M_testfile->(sub  {
    my $scm_x=shift;
    return -d($scm_x);
    
  },$scm_d,$scm_l);
  
};
$scm_is_M_dir_V_=\&is_M_dir_V_;
;
;
use vars qw($scm_test_M_f_V_);
our $scm_test_M_f_V_;
sub test_M_f_V_ {
  my $scm_f=shift;
  my $scm_l=list(@_);
  return $scm_appl_M_testfile->(sub  {
    my $scm_x=shift;
    return -f($scm_x);
    
  },$scm_f,$scm_l);
  
};
$scm_test_M_f_V_=\&test_M_f_V_;
;
;
use vars qw($scm_test_M_d_V_);
our $scm_test_M_d_V_;
sub test_M_d_V_ {
  my $scm_d=shift;
  my $scm_l=list(@_);
  return $scm_appl_M_testfile->(sub  {
    my $scm_x=shift;
    return -d($scm_x);
    
  },$scm_d,$scm_l);
  
};
$scm_test_M_d_V_=\&test_M_d_V_;
;
;
use vars qw($scm_test_M_r_V_);
our $scm_test_M_r_V_;
sub test_M_r_V_ {
  my $scm_d=shift;
  my $scm_l=list(@_);
  return $scm_appl_M_testfile->(sub  {
    my $scm_x=shift;
    return -r($scm_x);
    
  },$scm_d,$scm_l);
  
};
$scm_test_M_r_V_=\&test_M_r_V_;
;
;
use vars qw($scm_test_M_e_V_);
our $scm_test_M_e_V_;
sub test_M_e_V_ {
  my $scm_f=shift;
  my $scm_l=list(@_);
  return $scm_appl_M_testfile->(sub  {
    my $scm_x=shift;
    return -e($scm_x);
    
  },$scm_f,$scm_l);
  
};
$scm_test_M_e_V_=\&test_M_e_V_;
;
;
use vars qw($scm_test_M_z_V_);
our $scm_test_M_z_V_;
sub test_M_z_V_ {
  my $scm_f=shift;
  my $scm_l=list(@_);
  return $scm_appl_M_testfile->(sub  {
    my $scm_x=shift;
    return -z($scm_x);
    
  },$scm_f,$scm_l);
  
};
$scm_test_M_z_V_=\&test_M_z_V_;
;
;
use vars qw($scm_test_M_s_V_);
our $scm_test_M_s_V_;
sub test_M_s_V_ {
  my $scm_f=shift;
  my $scm_l=list(@_);
  return $scm_appl_M_testfile->(sub  {
    my $scm_x=shift;
    return -s($scm_x);
    
  },$scm_f,$scm_l);
  
};
$scm_test_M_s_V_=\&test_M_s_V_;
;
;
use vars qw($scm_test_M_l_V_);
our $scm_test_M_l_V_;
sub test_M_l_V_ {
  my $scm_f=shift;
  my $scm_l=list(@_);
  return $scm_appl_M_testfile->(sub  {
    my $scm_x=shift;
    return -l($scm_x);
    
  },$scm_f,$scm_l);
  
};
$scm_test_M_l_V_=\&test_M_l_V_;
;
;
use vars qw($scm_test_M_w_V_);
our $scm_test_M_w_V_;
sub test_M_w_V_ {
  my $scm_f=shift;
  my $scm_l=list(@_);
  return $scm_appl_M_testfile->(sub  {
    my $scm_x=shift;
    return -w($scm_x);
    
  },$scm_f,$scm_l);
  
};
$scm_test_M_w_V_=\&test_M_w_V_;
;
;
use vars qw($scm_test_M_x_V_);
our $scm_test_M_x_V_;
sub test_M_x_V_ {
  my $scm_f=shift;
  my $scm_l=list(@_);
  return $scm_appl_M_testfile->(sub  {
    my $scm_x=shift;
    return -x($scm_x);
    
  },$scm_f,$scm_l);
  
};
$scm_test_M_x_V_=\&test_M_x_V_;
;
;
use Memoize::AnyDBM_File;
;
use vars qw($scm_dbmopen);
our $scm_dbmopen;
sub dbmopen {
  my $scm_dbf=shift;
  my $scm_mode=shift;
  return sub {
     my $dbf=shift;
    my $mode=shift;
     dbmopen(my %hash,$dbf,$mode);
    return \%hash 
  }->($scm_dbf,$scm_mode);
  
};
$scm_dbmopen=\&dbmopen;
;
;
use vars qw($scm_dbmclose);
our $scm_dbmclose;
sub dbmclose {
  my $scm_dbh=shift;
  return sub {
     my $h=shift;
    dbmclose(%{
      $h
    });
     
  }->($scm_dbh);
  
};
$scm_dbmclose=\&dbmclose;
;
;
use vars qw($scm_for_M_each);
our $scm_for_M_each;
sub for_M_each {
  my $scm_f=shift;
  my $scm_lists=list(@_);
  return sub {
     my $scm_g;
    $scm_g=sub  {
      my $scm_l=shift;
      return ( ($scm_null_V_->($scm_l)) ? 1 : sub {
        $scm_f->($scm_car->($scm_l));
        return $scm_g->($scm_cdr->($scm_l));
        
      }->());
      
    };
    my $id_17;
    $id_17=sub {
      my ($scm_g)=@_;
      return sub {
         my $scm_h;
        $scm_h=sub  {
          my $scm_lists=shift;
          return ( ($scm_null_V_->($scm_lists)) ? 1 : sub {
            $scm_g->($scm_car->($scm_lists));
            return $scm_h->($scm_cdr->($scm_lists));
            
          }->());
          
        };
        my $id_18;
        $id_18=sub {
          my ($scm_h)=@_;
          return $scm_h->($scm_lists);
          
        } ;
        return $id_18->($scm_h);
         
      }->();
      
    } ;
    return $id_17->($scm_g);
     
  }->();
  
};
$scm_for_M_each=\&for_M_each;
;
;
use vars qw($scm_speme_M_author);
our $scm_speme_M_author;
sub speme_M_author {
  return "Hans Oesterholt";
  
};
$scm_speme_M_author=\&speme_M_author;
;
;
use vars qw($scm_speme_M_version);
our $scm_speme_M_version;
sub speme_M_version {
  return $scm___VERSION__->();
  
};
$scm_speme_M_version=\&speme_M_version;
;
;
use vars qw($scm_speme_M_copyright);
our $scm_speme_M_copyright;
sub speme_M_copyright {
  return $scm_string_M_append->("(c) ",$scm_speme_M_author->());
  
};
$scm_speme_M_copyright=\&speme_M_copyright;
;
;
use vars qw($scm_speme_M_name);
our $scm_speme_M_name;
sub speme_M_name {
  return "speme";
  
};
$scm_speme_M_name=\&speme_M_name;
;
;
1;
;
