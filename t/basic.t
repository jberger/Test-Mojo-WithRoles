use Mojo::Base -strict;

use lib 't/lib';

use Test::More;
use Test::Mojo::WithRoles;

my $t = Test::Mojo::WithRoles->new;
isa_ok $t, 'Test::Mojo';
ok ! $t->does('Test::Mojo::Role::Awesome'), 'not awesome';

{
  use Test::Mojo::Role::Awesome;
  my $ta = Test::Mojo::WithRoles->new;

  isa_ok $ta, 'Test::Mojo';
  ok $ta->does('Test::Mojo::Role::Awesome'), 'awesome';
  can_ok $ta, 'is_awesome';
}

my $tb = Test::Mojo::WithRoles->new;
isa_ok $tb, 'Test::Mojo';
ok ! $tb->does('Test::Mojo::Role::Awesome'), 'not awesome (again)';

done_testing;
