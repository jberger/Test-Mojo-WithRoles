package Test::Mojo::WithRoles;

use Mojo::Base -strict;

use Role::Tiny ();
use Test::Mojo;

use Mojo::JSON 'j';

sub import {
  my ($class, @roles) = @_;
  @roles = map { s/^\+// ? $_ : "Test::Mojo::Role::$_" } @roles;
  my $stack = j($^H{'Test::Mojo::WithRoles/stack'} || '[]');
  push @$stack, \@roles;
  $^H{'Test::Mojo::WithRoles/stack'} = j($stack);
}

sub unimport {
  my ($class, @roles) = @_;
  my $stack = j($^H{'Test::Mojo::WithRoles/stack'} || '[]');
  pop @$stack;
  $^H{'Test::Mojo::WithRoles/stack'} = j($stack);
}

sub new {
  my $class = shift;
  my $hints = (caller(0))[10];
  my $stack = j($hints->{'Test::Mojo::WithRoles/stack'} || '[]');
  my @roles = @{ $stack->[-1] || [] };
  @roles = 'Test::Mojo::Role::Null' unless @roles;
  return Role::Tiny->create_class_with_roles('Test::Mojo', @roles)->new(@_);
}

1;

