package HTML::FormHandler::Render::MasonX::Base;

use 5.010;
use Moose::Role;
use namespace::autoclean;

use MooseX::MaybeBuild;
use MooseX::ErsatzMethod;

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

has element_starttag => (
  is         => 'rw',
  isa        => 'Str',
  lazy_build => 1,
);

ersatz _build_element_starttag => sub {
  my $self = shift;
  if ( $self->allow_element_shorthand and not $self->has_element_content ) {
    return sprintf '<%s />', $self->element_tagname
  } else {
    return sprintf '<%s>', $self->element_tagname
  }
};


has element_content => (
  is         => 'rw',
  isa        => 'Str',
  traits     => [qw/ MaybeBuild /],
  lazy_build => 1,
);

sub _build_element_content {}

has element_endtag => (
  is         => 'ro',
  isa        => 'Str',
  builder    => '_build_element_endtag',
  lazy       => 1,
);

sub _build_element_endtag {
  my $self = shift;
  if ( $self->allow_element_shorthand and not $self->has_element_content ) {
    return '';
  } else {
    return sprintf '</%s>', $self->element_tagname;
  }
}

has allow_element_shorthand => (
  is      => 'ro',
  isa     => 'Bool',
  default => 1,
);

has element_tagname => (
  is         => 'rw',
  isa        => 'Str',
  required   => 1,
);

sub _build_element {
  my $self   = shift;
  my $output = '';

  $output .= $self->element_starttag;

  if ( $self->has_element_content ) {
    $output .= $self->element_content;
  }

  $output .= $self->element_endtag;

  return $output;
}

1;
