package HTML::FormHandler::Render::MasonX::Base;

use 5.010;
use Moose::Role;
use namespace::autoclean;

requires '_build_element';

has field => (
  is       => 'ro',
  isa      => 'HTML::FormHandler::Field',
  required => 1,
);

has element => (
  is         => 'rw',
  isa        => 'Str',
  lazy_build => 1,
);

1;
