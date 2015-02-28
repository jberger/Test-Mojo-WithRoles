package Test::Mojo::WithRoles;

use Mojo::Base -strict;

use Role::Tiny ();
use Test::Mojo;

use Mojo::JSON 'j';

sub import {
  my ($class, @roles) = @_;
  @roles = map { s/^\+// ? $_ : "Test::Mojo::Role::$_" } @roles;
  $^H{'Test::Mojo::WithRoles/enabled'} = j(\@roles);
}

sub unimport {
  my ($class) = @_;
  $^H{'Test::Mojo::WithRoles/enabled'} = j([]);
}

sub new {
  my $class = shift;
  my $hints = (caller(0))[10];
  my $roles = j($hints->{'Test::Mojo::WithRoles/enabled'} || '[]');
  @$roles = 'Test::Mojo::Role::Null' unless @$roles;
  return Role::Tiny->create_class_with_roles('Test::Mojo', @$roles)->new(@_);
}

1;

