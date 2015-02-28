package Test::Mojo::Role;

use Mojo::Base -strict;

my @registered;

sub import {
  my $class = shift;
  my $caller = caller;
  push @registered, $caller;

  no strict 'refs';
  *{"${caller}::import"} = sub {
    $^H{"$caller/enabled"} = 1;
  };

  *{"${caller}::unimport"} = sub {
    $^H{"$caller/enabled"} = 0;
  };
}

sub enabled {
  my $level = shift || 0;
  my $hints = (caller $level)[10];
  my @roles = grep { $hints->{"$_/enabled"} } @registered;
}

sub registered { @registered }

1;

