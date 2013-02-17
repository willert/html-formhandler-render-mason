package HTML::FormHandler::Render::MasonX::Option;

use 5.010;
use Moose::Role;
use namespace::autoclean;

use Method::Signatures::Simple;
use MooseX::OmniTrigger;
use MooseX::ClassAttribute 0.26;

use HTML::FormHandler::Render::Util (); # ('process_attrs', 'ucc_widget');

has index => (
  is       => 'rw',
  isa      => 'Int',
  required => 1,
);

has label => (
  is => 'rw',
  omnitrigger => \&_sanitize_label_trigger,
  predicate   => 'has_label',
);

sub _sanitize_label_trigger {
  my ( $self, $attr, $new_val ) = @_;
  my $label = $new_val->[0];

  return '' unless $label and $label ne '';

  my $field = $self->field;
  $label = $field->_localize( $label ) if $field->localize_labels;
  return $field->html_filter( $label );
}

has value_value => (
  is       => 'ro',
  isa      => 'Value',
  init_arg => 'value',
);

has value => (
  is          => 'rw',
  isa         => 'Str',
  required    => 1,
  lazy_build  => 1,
  init_arg    => undef,
  omnitrigger => \&_option_value_trigger
);

sub _build_value { $_[0]->value_value }

sub _option_value_trigger {
  my ( $self, $attr, $new_val ) = @_;
  $self->$attr( sprintf ' %s="%s"', $attr, $new_val->[0] // '' );
}

sub _build_id {
  my $self = shift;
  return sprintf( '%s.%d', $self->field->id, $self->index );
}

no Moose::Role;

1;
