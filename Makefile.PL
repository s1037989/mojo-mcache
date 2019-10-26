use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'Mojo::Mcache',
  VERSION_FROM => 'lib/Mojo/Mcache.pm',
  AUTHOR       => 'A Good Programmer <nospam@cpan.org>',
  PREREQ_PM    => {'Mojolicious' => '8.25'},
  test         => {TESTS => 't/*.t'}
);
