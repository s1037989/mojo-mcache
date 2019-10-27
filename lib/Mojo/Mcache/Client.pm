package Mojo::Mcache::Client;
use Mojo::Base -base, -signatures;

use Mojo::File 'path';
use Mojo::UserAgent;

use constant DEBUG => $ENV{MCACHE_CLIENT_DEBUG} || 0;

has mcache => undef, weak => 1;

sub get {
  my $self = shift;
  my $path = $self->_path(shift);
  warn "[client-get] ".$self->_url($path) if DEBUG;
  $self->mcache->ua->get($self->_url($path) => @_)->result->json;
}

sub post {
  my ($self, $json) = (shift, pop);
  my $path = $self->_path(shift);
  warn "[client-post] ".$self->_url($path) if DEBUG;
  $self->mcache->ua->post($self->_url($path) => @_ => json => $json)->result->json;
}

sub put {
  my ($self, $json) = (shift, pop);
  my $path = $self->_path(shift);
  warn "[client-put] ".$self->_url($path) if DEBUG;
  $self->mcache->ua->put($self->_url($path) => @_ => json => $json)->result->json;
}

sub delete {
  my $self = shift;
  my $path = $self->_path(shift);
  warn "[client-delete] ".$self->_url($path) if DEBUG;
  $self->mcache->ua->delete($self->_url($path) => @_)->result->json;
}

sub table {
  my ($self, $table) = @_;
  if ( $table ) {
    $self->mcache->table($table);
    return $self;
  } else {
    return $self->mcache->table;
  }
};

sub _path {
  my $self = shift;
  warn "TABLE:".$self->table if DEBUG > 1;
  Mojo::File::path('', ($self->mcache->sock?():'mcache'), $self->table, ref $_[0] ? @{+shift} : shift || ());
}

sub _url ($self, $path) { sprintf '%s%s', $self->mcache->sock, $path }

1;
