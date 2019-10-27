use Mojo::Base -strict;

use Test::More tests => 27;
use Mojolicious::Lite;
use Test::Mojo;

use constant DEBUG => $ENV{MCACHE_DEBUG} || 0;

plugin 'Mcache' => \''; # Don't use a unix socket

# Don't show debug messages in verbose output
app->log->level('debug')->unsubscribe('message') unless DEBUG;
app->mcache->mcache->server->app->log->level('debug')->unsubscribe('message') unless DEBUG;

my $t = Test::Mojo->new;
my $post = app->mcache->post({abc => 123});
ok $post->{id}, 'posted';
my $test = app->mcache->table('test')->post({abc => 321});
ok $test->{id}, 'posted test';
ok app->mcache->table('default')->get > 0, 'not null';
is app->mcache->get($post->{id})->{id}, $post->{id}, 'got post';
$t->post_ok('/mcache/default' => json => {a=>1, id=>1})->status_is(200)->json_has('/id', 'has id');
$t->get_ok('/mcache/default')->status_is(200)->json_has('/0', 'not null');
$t->get_ok('/mcache/default/1')->status_is(200)->json_has('/id', 'has id');
$t->delete_ok('/mcache/default/1')->status_is(200)->json_hasnt('/0', 'null');
ok -f app->mcache->mcache->file, 'storable cache exists';
ok unlink(app->mcache->mcache->file), 'removed storable cache';
ok !-f app->mcache->mcache->file, 'storable cache removed';
$t->get_ok('/mcache/default')->status_is(200)->json_has('/0', 'not null');
$t->get_ok("/mcache/default/$post->{id}")->status_is(200)->json_has('/id', 'has id');
ok unlink(app->mcache->mcache->file), 'removed storable cache again';
ok !-f app->mcache->mcache->file, 'storable cache removed again';

done_testing();
