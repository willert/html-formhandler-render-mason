package Form::Test;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';
with 'HTML::FormHandler::Render::Mason';

use MooseX::Types::Moose qw/Int/;

has '+name' => ( default => 'TestForm' );

has_field reqname => (
  label    => 'Required field',
  type     => 'Text',
  required => 1
);

has_field optname => (
  label    => 'Optional field',
  type     => 'Text',
  size     => 127
);

has_field numeric => (
  label    => 'Numneric field',
  type     => 'Text',
  apply    => [ Int,  ],
  size     => 127
);

has_field fruit   => (
  label    => 'Select one',
  type     => 'Select'
);


sub options_fruit {
  return (
    1   => 'apples',
    2   => 'oranges',
    3   => 'kiwi',
  );
}

no HTML::FormHandler::Moose;

1;
