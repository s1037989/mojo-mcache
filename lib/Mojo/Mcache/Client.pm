package Mojo::Mcache::Client;
use Mojo::Base -base, -signatures;

use Mojo::File 'path';
use Mojo::UserAgent;

use constant DEBUG => $ENV{MOJO_MCACHE_DEBUG} || 0;

has mcache => undef, weak => 1;
has ua => sub { Mojo::UserAgent->new };

sub get {
  my $self = shift;
  my $path = _path(shift);
  warn "GET: ".$self->_url($path) if DEBUG;
  $self->ua->get($self->_url($path) => @_)->result->json;
}

sub post {
  my ($self, $json) = (shift, pop);
  my $path = _path(shift);
  warn "POST: ".$self->_url($path) if DEBUG;
  $self->ua->post($self->_url($path) => @_ => json => $json)->result->json;
}

sub put {
  my ($self, $json) = (shift, pop);
  my $path = _path(shift);
  warn "PUT: ".$self->_url($path) if DEBUG;
  $self->ua->put($self->_url($path) => @_ => json => $json)->result->json;
}

sub delete {
  my $self = shift;
  my $path = _path(shift);
  warn "DELETE: ".$self->_url($path) if DEBUG;
  $self->ua->delete($self->_url($path) => @_)->result->json;
}

sub _path { Mojo::File::path('', ref $_[0] ? @{+shift} : shift || '') }

sub _url ($self, $path) { sprintf '%s%s', $self->mcache->sock, $path }

1;
