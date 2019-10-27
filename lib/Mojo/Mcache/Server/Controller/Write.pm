package Mojo::Mcache::Server::Controller::Write;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use constant DEBUG => $ENV{MCACHE_SERVER_DEBUG} || 0;

sub post ($self, @) {
  my $table = $self->param('table');
  warn "[server-write-post] Table: $table | ID: ---" if DEBUG;
  my $json = $self->req->json;
  $json->{id} ||= $self->req->request_id;
  return $self->reply->not_found if $self->mcache->{$table}->{$json->{id}};
  $self->mcache->{$table}->{$json->{id}} = $json;
  warn Mojo::Util::dumper({json => $json, mcache => $self->mcache->{$table}}) if DEBUG > 1;
  $self->render(json => $self->mcache->{$table}->{$json->{id}});
}

sub put ($self, @) {
  my $table = $self->param('table');
  my $id = $self->param('id');
  warn "[server-write-put] Table: $table | ID: $id" if DEBUG;
  return $self->reply->not_found unless $self->mcache->{$table}->{$id};
  $self->mcache->{$table}->{$id} = {id => $id, $self->req->json->%*};
  warn Mojo::Util::dumper({mcache => $self->mcache->{$table}}) if DEBUG > 1;
  $self->render(json => $self->mcache->{$table}->{$id});
}

sub del ($self, @) {
  my $table = $self->param('table');
  my $id = $self->param('id');
  warn "[server-write-del] Table: $table | ID: $id" if DEBUG;
  return $self->reply->not_found unless $self->mcache->{$table}->{$id};
  delete $self->mcache->{$table}->{$id};
  warn Mojo::Util::dumper({id => $id, mcache => $self->mcache->{$table}}) if DEBUG > 1;
  $self->render(json => $id);
}

1;
