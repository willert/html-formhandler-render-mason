package HTML::FormHandler::Render::MasonX::SubFields;

use 5.010;
use Moose::Role;
use namespace::autoclean;

sub subfiled_comp_spec {
  my ( $self, $field ) = @_;

  die "must pass a field to element"
    unless ( defined $field && $field->isa('HTML::FormHandler::Field') );

  my $widget = HTML::FormHandler::Render::Util::ucc_widget( $field->widget );
  return '' if $widget eq 'no_render';

  return (
    sprintf( '/element/%s.mi', $widget ),
    field => $field,
  );
}

1;
