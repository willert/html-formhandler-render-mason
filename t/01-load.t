#!/usr/bin/env perl

use Test::More;
use Class::Load qw/try_load_class/;

{
  my ( $loaded, $err ) = try_load_class 'HTML::FormHandler::Render::Mason';
  ok $loaded, 'Loading renderer' or diag $err;
}

done_testing;
