#!/usr/bin/env perl
use Mojolicious::Lite;

plugin 'Mcache' => \'';

get '/:table' => {table => 'default'} => sub {
  my $c = shift;
  $c->mcache->table($c->param('table'))->post({timestamp => scalar localtime});
  $c->mcache->put;
  $c->render(json => $c->mcache->get);
};

post '/:table' => {table => 'default'} => sub {
  my $c = shift;
  $c->render(json => $c->mcache->table($c->param('table'))->post($c->req->params->to_hash));
  $c->mcache->put;
};

app->start;

__END__

=encoding utf8

=head1 NAME

Mcache example in a lite_app

=head1 SYNOPSIS

  $ perl -I../lib myapp.pl get /abc

=head1 DESCRIPTION

L<Mojolicious::Plugin::Mcache> is a L<Mojolicious> plugin.

=cut
