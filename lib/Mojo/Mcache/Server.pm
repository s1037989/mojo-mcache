package Mojo::Mcache::Server;
use Mojo::Base 'Mojolicious';

use Storable;

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

  $r->get('/')->to('read#ids');
  $r->get('/:id')->to('read#id');
  $r->post('/')->to('write#post');
  $r->put('/:id')->to('write#put');
  $r->put('/')->to(cb => sub {
    my $c = shift;
    my $keys = scalar keys %$mcache;
    $c->log->debug("Storing $keys keys");
    store $mcache, $file;
    $c->render(json => {stored => $keys});
  });
  $r->delete('/:id')->to('write#del');
}

1;
