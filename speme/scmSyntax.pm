package scmSyntax;
use strict;

sub new () {
   my $class=shift;
   my $name=shift;
   my $macro=shift;
   my $patterns=shift;
   my $codes=shift;
   my $obj={};
   $obj->{macro}=$macro;
   $obj->{name}=$name;
   bless $obj,$class;
   $patterns->($obj);
   $codes->($obj);
   return $obj;
}

# Expect sexpression arguments here
sub apply_macro() {
  my $self=shift;
  $self->{macro}->($self,@_);
}

sub name() {
  my $self=shift;
  return $self->{name};
}

sub set_pattern() {
  my $self=shift;
  my $pattern_index=shift;
  my $pattern_sexpr=shift;
  $self->{"pattern:$pattern_index"}=$pattern_sexpr;
}

sub get_pattern() {
  my $self=shift;
  my $pattern_index=shift;
  return $self->{"pattern:$pattern_index"};
}

sub set_code() {
  my $self=shift;
  my $pattern_index=shift;
  my $code_sexpr=shift;
  $self->{"code:$pattern_index"}=$code_sexpr;
}

sub get_code() {
  my $self=shift;
  my $pattern_index=shift;
  return $self->{"code:$pattern_index"};
}

1;
