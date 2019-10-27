package Mojo::Mcache::Server::Controller::Read;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use constant DEBUG => $ENV{MCACHE_SERVER_DEBUG} || 0;

sub get_one ($self) {
  my $table = $self->param('table');
  my $id = $self->param('id');
  warn "[server-read-get] Table: $table | ID: $id" if DEBUG;
  $self->render(json => $id ? $self->mcache->{$table}->{$id} : $self->mcache->{$table});
}

sub get_keys ($self) {
  my $table = $self->param('table');
  warn "Table: $table | ID: ---" if DEBUG;
  $self->render(json => [keys $self->mcache->{$table}->%*]);
}

1;
