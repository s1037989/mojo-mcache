package Mojo::Mcache;
use Mojo::Base -base;

use Mojo::Server;

use Mojo::Mcache::Client;
use Mojo::Mcache::Server;

our $VERSION = '0.01';

has
  app =>
  sub { $_[0]{app_ref} = Mojo::Server->new->build_app('Mojo::HelloWorld') },
  weak => 1;
has client => sub { state $client = Mojo::Mcache::Client->new(mcache => shift) };
has file => sub { shift->app->home->child('mcache.cache') };
has freq => 3;
has server => sub { state $server = Mojo::Mcache::Server->new(mcache => shift) };
has sock => 'http+unix://mcache.sock';

1;
