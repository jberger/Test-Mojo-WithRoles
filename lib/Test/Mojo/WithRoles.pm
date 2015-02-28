package Test::Mojo::WithRoles;

use Mojo::Base -strict;

use Role::Tiny ();
use Test::Mojo;
use Test::Mojo::Role ();

sub new {
  my $class = shift;
  my @roles = Test::Mojo::Role::enabled(1);
  @roles = 'Test::Mojo::Role::Null' unless @roles;
  return Role::Tiny->create_class_with_roles('Test::Mojo', @roles)->new(@_);
}

1;

