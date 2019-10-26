package Mojolicious::Plugin::Mcache;
use Mojo::Base 'Mojolicious::Plugin';

use Mojo::Mcache;

sub register {
  my ($self, $app, $conf) = @_;
  push @{$app->commands->namespaces}, 'Mojo::Mcache::Command';
  $conf = $conf ? ref $conf eq 'SCALAR' ? {sock => $$conf} : $conf : {};
  my $mcache = Mojo::Mcache->new(%$conf)->app($app);
  $app->helper(mcache => sub { $mcache->client });
  $app->routes->route('/mcache')->detour(app => $mcache->server) unless $mcache->sock;
}

1;
__END__

=encoding utf8

=head1 NAME

Mojolicious::Plugin::Mcache - Mojolicious Plugin

=head1 SYNOPSIS

  # Mojolicious
  $self->plugin('Mcache');

  # Mojolicious::Lite
  plugin 'Mcache';

=head1 DESCRIPTION

L<Mojolicious::Plugin::Mcache> is a L<Mojolicious> plugin.

=head1 METHODS

L<Mojolicious::Plugin::Mcache> inherits all methods from
L<Mojolicious::Plugin> and implements the following new ones.

=head2 register

  $plugin->register(Mojolicious->new);

Register plugin in L<Mojolicious> application.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<https://mojolicious.org>.

=cut
