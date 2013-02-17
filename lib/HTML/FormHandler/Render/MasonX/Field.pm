package HTML::FormHandler::Render::MasonX::Field;

use 5.010;
use Moose::Role;
use namespace::autoclean;

has field => (
  is       => 'ro',
  isa      => 'HTML::FormHandler::Field',
  required => 1,
);


1;
