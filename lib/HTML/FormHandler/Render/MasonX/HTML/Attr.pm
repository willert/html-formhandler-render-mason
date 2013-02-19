package HTML::FormHandler::Render::MasonX::HTML::Attr;

use 5.010;
use Moose::Role;
use namespace::autoclean;

use Method::Signatures::Simple;
use MooseX::OmniTrigger;
use MooseX::ClassAttribute 0.26;

use HTML::FormHandler::Render::Util (); # ('process_attrs', 'ucc_widget');

my @default_html_attrs;

class_has html_attrs => (
  is         => 'bare',
  isa        => 'ArrayRef',
  traits     => [qw/ Array /],
  default    => sub{[ @default_html_attrs ]},
  handles    => {
    html_attrs        => 'elements',
    add_to_html_attrs => 'push',
  },
);

sub add_html_attr {
  my ( $class, @attrs ) = @_;
  for my $name ( @attrs ) {
    $class->meta->add_attribute(
      $name,
      is          => 'rw',
      isa         => 'Str',
      lazy_build  => 1,
      omnitrigger => \&_html_attr_trigger
    );

    # class_attr handling will only be composed into the consumer class
    # @default_html_attrs handles it for our default attrs
    $class->add_to_html_attrs( $name ) if $class->can('add_to_html_attrs');
  }
}

sub _html_attr_trigger {
  my ( $self, $attr, $new_val ) = @_;
  if ( !@$new_val or !defined( $new_val->[0] ) or $new_val->[0] eq '' ) {
    $self->$attr('');
    return
  }
  $self->$attr( sprintf ' %s="%s"', $attr, $new_val->[0] );
}

# class_attr handling will only be composed into the consumer class
# @default_html_attrs handles it for our default attrs
__PACKAGE__->add_html_attr( @default_html_attrs = qw/ type name id / );

sub _build_type { $_[0]->field->input_type }
sub _build_name { $_[0]->field->html_name }
sub _build_id   { $_[0]->field->id }

has additional_attrs => (
  is         => 'rw',
  isa        => 'Str',
  lazy_build => 1,
);

method _build_additional_attrs () {
  my $field = $self->field;
  HTML::FormHandler::Render::Util::process_attrs(
    $field->element_attributes
  );
}

sub _build_element_starttag {
  my $self = shift;

  my $output = '<';
  $output .= $self->element_tagname;

  for my $attr ( $self->html_attrs ) {
    $output .= $self->$attr;
  }
  $output .= $self->additional_attrs;

  if ( $self->allow_element_shorthand and not $self->has_element_content ) {
    $output .= '>';
  } else {
    $output .= ' />';
  }

  return $output;
}

1;
