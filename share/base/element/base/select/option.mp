use MooseX::OmniTrigger;
use 5.010;

with (
  'HTML::FormHandler::Render::MasonX::Base',
  'HTML::FormHandler::Render::MasonX::HTML::Attr',
);

has element_tagname => ( default => 'option' );
__PACKAGE__->add_html_attr(qw/ selected /);
__PACKAGE__->add_to_html_attrs(qw/ value disabled /);

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

has fif => (
  is => 'ro',
  predicate => 'has_fif',
  lazy => 1,
  builder => '_build_fif',
);

sub _build_fif { $_[0]->field->fif }

sub fif_lookup {
  my $self  = shift;
  my $value = shift;

  return unless $self->has_fif;

  my $field = $self->field;

  if ( $field->multiple ) {
    my %fif_lookup;
    @fif_lookup{ @{ $self->fif }} = () if $field->multiple;
    return exists $fif_lookup{ $value };
  } elsif ( $self->fif eq $value ) {
    return 1;
  } else {
    return;
  }
}

sub _build_selected {
  my $self = shift;
  $self->fif_lookup( $self->value_value ) // '';
}

has value_value => (
  is       => 'ro',
  isa      => 'Int',
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

has disabled => (
  is       => 'rw',
  isa      => 'Bool',
  required => 1,
  default  => 0,
  omnitrigger => \&_boolean_value_trigger
);

sub _boolean_value_trigger {
  my ( $self, $attr, $new_val ) = @_;
  if ( not $new_val->[0] ) {
    $self->$attr('');
  } else {
    $self->$attr( sprintf ' %s="%s"', $attr, $attr ) if $new_val->[0];
  }
}

sub _build_id {
  my $self = shift;
  return sprintf( '%s.%d', $self->field->id, $self->index );
}

sub _build_disabled {
  my $self = shift;
  my $field = $self->field;
  return '' unless $field->can('checkbox_value')
    and $field->fif eq $field->checkbox_value;
  return 'checked';
}

sub _build_element_content {
  my $self = shift;
  return unless $self->has_label;
  return $self->label;
}
