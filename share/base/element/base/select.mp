use MooseX::OmniTrigger;

with (
  'HTML::FormHandler::Render::MasonX::Base',
  'HTML::FormHandler::Render::MasonX::HTML::Attr',
);

has element_tagname => ( default => 'select' );
__PACKAGE__->add_html_attr( qw/ size multiple / );

sub _build_size {
  my $self = shift;
  my $field = $self->field;
  return '' unless $field->can('size') and $field->size;
  return $field->size;
}

sub _build_multiple {
  my $self = shift;
  my $field = $self->field;
  return '' unless $field->can('multiple') and $field->multiple;
  return 'multiple';
}

sub _build_element_content {
  my $self = shift;

  my $output = '';

  my $field    = $self->field;
  my $multiple = $field->multiple;

  if( defined $field->empty_select ) {
    $output .= '<option value="">';
    $output .= $field->localize_labels ?
      $field->_localize( $field->empty_select ) : $field->empty_select;
    $output .= '</option>';
    $output .= "\n";
  }

  my $fif = $field->fif;
  my %fif_lookup;
  @fif_lookup{ @$fif } = () if $field->multiple;

  my $index = 0;
  foreach my $option ( @{ $field->{options} } ) {
    $output .= $m->scomp(
      '/element/select/option.mi',
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
