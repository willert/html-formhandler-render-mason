use MooseX::OmniTrigger;
use HTML::FormHandler::Render::Util ();
use 5.010;

has additional_attrs => (
  is         => 'rw',
  isa        => 'Str',
  lazy_build => 1,
);

has callback => (
  is        => 'ro',
  isa       => 'CodeRef',
  predicate => 'has_callback',
);

sub _build_additional_attrs {
  my $self = shift;

  return HTML::FormHandler::Render::Util::process_attrs(
    $form->attributes( $result )
  );
}

sub call_next {
  my $self = shift;
  $self->callback->() if $self->has_callback;
  return;
}

sub element {
  my $self = shift;

  print '<form' . $self->additional_attrs . '>';
  $self->call_next;
  print '</form>';

  return;
}
