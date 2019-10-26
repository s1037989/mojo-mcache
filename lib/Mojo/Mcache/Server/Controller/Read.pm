package Mojo::Mcache::Server::Controller::Read;
use Mojo::Base 'Mojolicious::Controller', -signatures;

sub id ($self) {
  $self->render(json => $self->param('id') ? $self->mcache->{$self->param('id')} : $self->mcache);
}

sub ids ($self) {
  $self->render(json => [keys $self->mcache->%*]);
}

1;
