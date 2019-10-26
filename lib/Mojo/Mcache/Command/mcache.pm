package Mojo::Mcache::Command::mcache;
use Mojo::Base 'Mojolicious::Command';

use Mojo::Server::Daemon;
use Mojo::Util 'getopt';

use Mojo::Mcache;

has description => 'Start application with HTTP and WebSocket server';
has usage       => sub { shift->extract_usage };

sub run {
  my ($self, @args) = @_;

  my $mcache = $self->app->mcache->mcache;
  my $daemon = Mojo::Server::Daemon->new(app => $mcache->server);
  getopt \@args,
    'b|backlog=i'            => sub { $daemon->backlog($_[1]) },
    'c|clients=i'            => sub { $daemon->max_clients($_[1]) },
    'i|inactivity-timeout=i' => sub { $daemon->inactivity_timeout($_[1]) },
    'r|requests=i'           => sub { $daemon->max_requests($_[1]) };

  $daemon->listen([$mcache->sock]);
  $daemon->run;
}

1;