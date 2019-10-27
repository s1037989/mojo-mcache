package Blog;
use Mojo::Base 'Mojolicious';

use Blog::Model::Posts;
use Blog::Model::Users;
use Mojo::Mcache;

sub startup {
  my $self = shift;

  # Configuration
  $self->plugin('Config');
  $self->plugin('Mcache' => \'');
  $self->secrets($self->config('secrets'));

  # Model
  $self->helper(
    posts => sub { state $posts = Blog::Model::Posts->new(mcache => $self->mcache->table('posts'), log => shift->log) });
  $self->helper(
    users => sub { state $users = Blog::Model::Users->new(mcache => $self->mcache->table('users'), log => shift->log) });

  # Controller
  my $r = $self->routes;
  $r->get('/' => sub { shift->redirect_to('posts') });
  $r->get('/posts')->to('posts#index');
  $r->get('/posts/create')->to('posts#create')->name('create_post');
  $r->post('/posts')->to('posts#store')->name('store_post');
  $r->get('/posts/:id')->to('posts#show')->name('show_post');
  $r->get('/posts/:id/edit')->to('posts#edit')->name('edit_post');
  $r->put('/posts/:id')->to('posts#update')->name('update_post');
  $r->delete('/posts/:id')->to('posts#remove')->name('remove_post');
  $r->get('/users')->to('users#index');
}

1;
