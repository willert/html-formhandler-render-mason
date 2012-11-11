use MooseX::OmniTrigger;
use 5.010;

with (
  'HTML::FormHandler::Render::MasonX::Base',
  'HTML::FormHandler::Render::MasonX::HTML::Attr',
);

__PACKAGE__->add_html_attr(qw/ size maxlength value checked /);

sub _build_size {
  my $self = shift;
  my $field = $self->field;
  return '' unless $field->can('size') and $field->size;
  return $field->size;
}

sub _build_maxlength {
  my $self = shift;
  my $field = $self->field;
  return '' unless $field->can('maxlength') and $field->maxlength;
  return $field->maxlength;
}

sub _build_value {
  my $self = shift;
  my $field = $self->field;
  return $field->html_filter( $field->fif );
}

sub _build_checked {
  my $self = shift;
  my $field = $self->field;
  return '' unless $field->can('checkbox_value')
    and $field->fif eq $field->checkbox_value;
  return 'checked';
}

sub _build_element {
  my $self = shift;
  my $output = '';
  $output .= '<input';
  for my $attr ( $self->html_attrs ) {
    $output .= $self->$attr;
  }
  $output .= $self->additional_attrs;
  $output .= ' />';

  return $output;
};

sub content {
  my $self = shift;
  print $self->element;
  print inner() // '';

  return;
}
