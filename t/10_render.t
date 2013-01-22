#!/usr/bin/env perl

use Test::More;
use Test::Exception;

use Class::Load qw/try_load_class/;
use Find::Lib qw/lib/;

use Form::Test;

my $output;

lives_ok {
  my $form = Form::Test->new;
  $form->process( params => { optname => 'foo', numeric => 'abc' });
  $output = $form->render;
}, 'Render lives okay';

note $output;

done_testing;
