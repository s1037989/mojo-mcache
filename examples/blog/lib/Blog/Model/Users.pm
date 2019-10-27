package Blog::Model::Users;
use Mojo::Base 'Blog::Model';

sub add {
  my ($self, $user) = @_;
  return $self->mcache->post($user)->{id};
}

sub all {
  my ($self, $id) = @_;
  return $self->mcache->get;
}

sub find {
  my ($self, $id) = @_;
  return $self->mcache->get($id);
}

sub remove {
  my ($self, $id) = @_;
  return $self->mcache->delete($id);
}

sub save {
  my ($self, $id, $user) = @_;
  return $self->mcache->put($id, $user);
}

1;
