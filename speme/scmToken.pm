package scmToken;
use strict;

sub new() {
  my $class=shift;
  my $obj={};
  bless $obj,$class;
  $obj->{linenr}=-1;
  return $obj;
}

sub linenr() {
  my $self=shift;
  my $l=shift;
  if (defined($l)) { $self->{linenr}=$l; }
  return $self->{linenr};
}

sub open() {
  my $self=shift;
  $self->{type}="open";
  return $self;
}

sub close() {
  my $self=shift;
  $self->{type}="close";
  return $self;
}

sub type() {
  my $self=shift;
  return $self->{type};
}

sub value() {
  my $self=shift;
  return $self->{type};
}

sub is_open() {
  my $self=shift;
  return $self->{type} eq "open";
}

sub is_close() {
  my $self=shift;
  return $self->{type} eq "close";
}

sub is_symbol() {
  return 0;
}

1;
