package Blog::Model::Posts;
use Mojo::Base 'Blog::Model';

sub add {
  my ($self, $post) = @_;
  return $self->mcache->post($post)->{id};
}

sub all {
  my ($self, $id) = @_;
  return [map { $self->mcache->get($_) } $self->mcache->get->@*];
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
  my ($self, $id, $post) = @_;
  return $self->mcache->put($id, $post);
}

1;
