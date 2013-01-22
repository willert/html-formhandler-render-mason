use HTML::FormHandler::Render::Util ();
use 5.010;

has form_error_class             => ( default => [qw/ with-errors   /]);
has field_validation_error_class => ( default => [qw/ field-error   /]);
has field_missing_error_class    => ( default => [qw/ field-missing /]);

method container ( $field ) {
  $self->field( $field );
  $self->message( $field );
}

method message( $field ) {
  if ( ref( \$field ) eq 'SCALAR' ) {
    $field = $form->field($field);
  }
  die "must pass a field to element"
    unless ( defined $field && $field->isa('HTML::FormHandler::Field') );

  return unless $field->has_errors;

  print @{ $field->errors };

  return;
}


method label( $field ) {
  if ( ref( \$field ) eq 'SCALAR' ) {
    $field = $form->field($field);
  }
  die "must pass a field to element"
    unless ( defined $field && $field->isa('HTML::FormHandler::Field') );

  return unless $field->label;

  print $field->label;

  return;
}

method element( $field ) {
  if ( ref( \$field ) eq 'SCALAR' ) {
    $field = $form->field($field);
  }
  die "must pass a field to element"
    unless ( defined $field && $field->isa('HTML::FormHandler::Field') );

  my $widget = HTML::FormHandler::Render::Util::ucc_widget( $field->widget );
  return '' if $widget eq 'no_render';

  $m->comp(
    sprintf( 'element/%s.mi', $widget ),
    field => $field,
    ( map{ $_ => $self->$_ } map{ "field_${_}_error_class" }
        qw/validation missing/ ),
  );
}

method field( $field ) {
  $self->label( $field );
  $self->element( $field );
}

method content () {
  my $output = '';
  foreach my $field ( $form->sorted_fields ) {
    $self->container( $field );
  }
  return;
}


method widget () {
  $self->form( @_ );
}

method form () {
  # render form tag
  my $attrs = HTML::FormHandler::Render::Util::process_attrs(
    $form->attributes( $result )
  );

  $m->comp(
    'element/form.mi',
    callback         => sub{ $self->content },
    form_error_class => $self->form_error_class,
  );
}
