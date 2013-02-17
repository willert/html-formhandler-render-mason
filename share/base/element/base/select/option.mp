use MooseX::OmniTrigger;
use 5.010;

with (
  'HTML::FormHandler::Render::MasonX::Base',
  'HTML::FormHandler::Render::MasonX::HTML::Attr' => {
    -excludes => '_build_id'
  },
  'HTML::FormHandler::Render::MasonX::Option',
);

has element_tagname => ( default => 'option' );

__PACKAGE__->add_html_attr(qw/ selected /);
__PACKAGE__->add_to_html_attrs(qw/ value disabled /);

has fif => (
  is        => 'ro',
  predicate => 'has_fif',
  lazy      => 1,
  builder   => '_build_fif',
);

sub _build_fif { $_[0]->field->fif }

sub fif_lookup {
  my $self  = shift;
  my $value = shift;

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
