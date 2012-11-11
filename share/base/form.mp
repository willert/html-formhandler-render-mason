use HTML::FormHandler::Render::Util ();
use 5.010;

method field( $field ) {
  if ( ref( \$field ) eq 'SCALAR' ) {
    $field = $form->field($field);
  }
  die "must pass field to render_field"
    unless ( defined $field && $field->isa('HTML::FormHandler::Field') );
  # widgets should be in camel case, since they are Perl package names
  my $widget = HTML::FormHandler::Render::Util::ucc_widget( $field->widget );

  return '' if $widget eq 'no_render';

  $m->comp(
    sprintf( 'widget/%s.mi', $widget ),
    field => $field,
  );
}

method content () {
  my $output = '';
  foreach my $field ( $form->sorted_fields ) {
    print '  ';
    print $self->field( $field );
  }
  return;
}

method form () {
  # render form tag
  my $attrs = HTML::FormHandler::Render::Util::process_attrs(
    $form->attributes( $result )
  );

  $m->comp(
    'widget/form.mi',
    callback => sub{ $self->content },
  );
}
