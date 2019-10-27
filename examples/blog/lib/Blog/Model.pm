package Blog::Model;
use Mojo::Base -base;

has log => sub { shift->mcache->mcache->app->log };
has 'mcache';

1;
