use MooseX::OmniTrigger;

with (
  'HTML::FormHandler::Render::MasonX::Field',
);

has element => (
  is         => 'rw',
  isa        => 'Str',
  lazy_build => 1,
);

sub _build_element {
  my $self = shift;

  my $output = '';
  my $field  = $self->field;
  my $index  = 0;

  foreach my $option ( @{ $field->{options} } ) {
    $output .= $m->scomp(
      '/element/radio.mi',
      index => $index,
      field => $self->field,
      %$option,
    );
    $index++;
  }

  return $output;
}

sub content {
  my $self = shift;
  print $self->element;
  print inner() // '';
  return;
}
