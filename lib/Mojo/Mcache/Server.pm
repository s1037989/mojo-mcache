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
  $self->mcache->app->hook(after_dispatch => sub {
    my $c = shift;
    my $table = $self->mcache->table;
    my $keys = scalar keys $mcache->{$table}->%*;
    warn Mojo::Util::dumper({store => $mcache}) if DEBUG > 1;
    $c->log->debug("Storing $keys $table keys");
    store $mcache, $file;
    warn Mojo::Util::dumper({tables => $keys}) if DEBUG;
  }) unless $self->mcache->sock;
  Mojo::IOLoop->recurring($self->mcache->freq => sub {
    my $keys = scalar keys %$mcache;
    $self->log->debug("Storing $keys tables");
    store $mcache, $file;
  }) if $self->mcache->sock;

  my $r = $self->routes;

  $r->get('/:table', {table => 'default'})->to('read#get_keys');
  $r->get('/:table/:id', {table => 'default'})->to('read#get_one');
  $r->post('/:table', {table => 'default'})->to('write#post');
  $r->put('/:table/:id', {table => 'default'})->to('write#put');
  $r->delete('/:table/:id', {table => 'default'})->to('write#del');
}

1;
