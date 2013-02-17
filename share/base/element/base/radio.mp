use MooseX::OmniTrigger;

with (
  'HTML::FormHandler::Render::MasonX::Base',
  'HTML::FormHandler::Render::MasonX::HTML::Attr' => {
    -excludes => '_build_id'
  },
  'HTML::FormHandler::Render::MasonX::Option',
);

has element_tagname => ( default => 'input' );
__PACKAGE__->add_html_attr(qw/ checked /);
__PACKAGE__->add_to_html_attrs(qw/ value /);

has fif => (
  is        => 'ro',
  predicate => 'has_fif',
  lazy      => 1,
  builder   => '_build_fif',
);

sub _build_fif { $_[0]->field->fif }

sub _build_type { 'radio' }

sub _build_checked {
  my $self = shift;
  my $field = $self->field;

  use Data::Dumper::Concise;
  printf STDERR "Looking up %s in %s\n", $self->fif, $self->value_value;

  return '' unless $field->fif eq $self->value_value;
  return 'checked';
}


sub content {
  my $self = shift;
  print $self->element;
  print $self->label;
  print inner() // '';
  return;
}
