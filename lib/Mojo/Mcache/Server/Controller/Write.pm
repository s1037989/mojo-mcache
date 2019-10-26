package Mojo::Mcache::Server::Controller::Write;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use constant DEBUG => $ENV{MCACHE_DEBUG} || 0;

sub post ($self, @) {
  my $json = $self->req->json;
  $json->{id} ||= $self->req->request_id;
  return $self->reply->not_found if $self->mcache->{$json->{id}};
  $self->mcache->{$json->{id}} = $json;
  warn Mojo::Util::dumper({json => $json, mcache => $self->mcache}) if DEBUG;
  $self->render(json => $self->mcache->{$json->{id}});
}

sub put ($self, @) {
  my $id = $self->param('id');
  return $self->reply->not_found unless $self->mcache->{$id};
  $self->mcache->{$id} = $self->req->json;
  warn Mojo::Util::dumper({mcache => $self->mcache}) if DEBUG;
  $self->render(json => $self->mcache->{$id});
}

sub del ($self, @) {
  my $id = $self->param('id');
  return $self->reply->not_found unless $self->mcache->{$id};
  delete $self->mcache->{$id};
  warn Mojo::Util::dumper({id => $id, mcache => $self->mcache}) if DEBUG;
  $self->render(json => $id);
}

1;
