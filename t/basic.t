use Mojo::Base -strict;

use Test::More tests => 33;
use Mojolicious::Lite;
use Test::Mojo;

plugin 'Mcache' => \''; # Don't use a unix socket

# Don't show debug messages in verbose output
app->log->level('debug')->unsubscribe('message');
app->mcache->mcache->server->app->log->level('debug')->unsubscribe('message');

my $t = Test::Mojo->new;
my $post = app->mcache->post('mcache' => {abc => 123});
ok $post->{id}, 'posted';
ok app->mcache->get('mcache') > 0, 'not null';
is app->mcache->get("mcache/$post->{id}")->{id}, $post->{id}, 'got post';
$t->post_ok('/mcache' => json => {a=>1, id=>1})->status_is(200)->json_has('/id', 'has id');
$t->get_ok('/mcache')->status_is(200)->json_has('/0', 'not null');
$t->get_ok('/mcache/1')->status_is(200)->json_has('/id', 'has id');
$t->delete_ok('/mcache/1')->status_is(200)->json_hasnt('/0', 'null');
$t->put_ok('/mcache')->status_is(200)->json_like('/stored' => qr/^\d+$/, 'stored keys');
ok -f app->mcache->mcache->file, 'storable cache exists';
ok unlink(app->mcache->mcache->file), 'removed storable cache';
ok !-f app->mcache->mcache->file, 'storable cache removed';
$t->put_ok('/mcache')->status_is(200)->json_like('/stored' => qr/^\d+$/, 'stored keys');
ok -f app->mcache->mcache->file, 'storable cache exists again';
$t->get_ok('/mcache')->status_is(200)->json_has('/0', 'not null');
$t->get_ok("/mcache/$post->{id}")->status_is(200)->json_has('/id', 'has id');
ok unlink(app->mcache->mcache->file), 'removed storable cache again';
ok !-f app->mcache->mcache->file, 'storable cache removed again';

done_testing();
