use MooseX::OmniTrigger;
use MooseX::ErsatzMethod;
use 5.010;

with (
 'HTML::FormHandler::Render::MasonX::Field',
 'HTML::FormHandler::Render::MasonX::SubFields',
);

sub content {
  my $self = shift;

  foreach my $subfield ( $self->field->sorted_fields ) {
    $m->comp( $self->subfiled_comp_spec( $subfield ));
  }

  print inner() // '';

  return;
}
