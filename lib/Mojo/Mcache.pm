package Mojo::Mcache;
use Mojo::Base -base;

use Mojo::Server;

use Mojo::Mcache::Client;
use Mojo::Mcache::Server;

our $VERSION = '0.01';

has client => sub { state $client = Mojo::Mcache::Client->new(mcache => shift) };
has file => sub { shift->app->home->child('mcache.cache') };
has freq => 3;
has server => sub { state $server = Mojo::Mcache::Server->new(mcache => shift) };
has sock => 'http+unix://mcache.sock';
has ua =>
  sub { Mojo::UserAgent->new(insecure => 1)->ioloop(Mojo::IOLoop->singleton) };
has table => 'default';

sub app {
  my ($self, $app) = @_;
  return $self->ua->server->app unless $app;
  $self->ua->server->app($app);
  return $self;
}

sub new {
  my ($self, $app) = (shift, shift);
  $self = $self->SUPER::new(@_);

  return $self unless $app;

  return $self->app(Mojo::Server->new->build_app($app)) unless ref $app;
  $app = Mojo::Server->new->load_app($app) unless $app->isa('Mojolicious');
  return $self->ua($app->ua)->app($app);
}

1;
