package Mojo::Mcache::Server;
use Mojo::Base 'Mojolicious';

use Storable;

use constant DEBUG => $ENV{MCACHE_SERVER_DEBUG} || 0;

has mcache => undef, weak => 1;

sub startup {
  my $self = shift;

  my $file = $self->mcache->file;
  my $mcache = -e $file ? retrieve $file : {};
  $self->helper(mcache => sub { $mcache });
  Mojo::IOLoop->recurring($self->mcache->freq => sub {
    my $keys = scalar keys %$mcache;
    $self->log->debug("Storing $keys keys");
    store $mcache, $file;
  });

  my $r = $self->routes;

  $r->get('/:table', {table => 'default'})->to('read#get_keys');
  $r->get('/:table/:id', {table => 'default'})->to('read#get_one');
  $r->post('/:table', {table => 'default'})->to('write#post');
  $r->put('/:table', {table => 'default'})->to(cb => sub {
    my $c = shift;
    my $table = $self->mcache->table;
    my $keys = scalar keys $mcache->{$table}->%*;
    warn Mojo::Util::dumper({store => $mcache}) if DEBUG > 1;
    $c->log->debug("Storing $keys $table keys");
    store $mcache, $file;
    $c->render(json => {stored => $keys});
  });
  $r->put('/:table/:id', {table => 'default'})->to('write#put');
  $r->delete('/:table/:id', {table => 'default'})->to('write#del');
}

1;
