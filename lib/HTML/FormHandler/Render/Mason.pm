package HTML::FormHandler::Render::Mason;

use 5.010;
use Moose::Role;
use namespace::autoclean;

use Mason;

use Moose::Util::TypeConstraints;
use HTML::FormHandler::Render::Util ('process_attrs');
use File::Share;

has mason_config => (
  is  => 'ro',
  isa => 'HashRef',
  traits => ['Hash'],
  lazy => 1,
  builder => 'build_mason_config',
);

sub build_mason_config {
  my $self = shift;
  return {
    plugins   => [],
    comp_root => [
      # @{ $self->tt_include_path },
      File::Share::dist_dir('HTML-FormHandler-Render-Mason') . '/simple/',
      File::Share::dist_dir('HTML-FormHandler-Render-Mason') . '/base/',
    ],
    mason_root_class => 'Mason',
  };
}

has 'mason_template' => (
  is         => 'rw',
  isa        => 'Str',
  lazy_build => 1,
);

sub _build_mason_template { '/theme' }

has mason_interp => (
  is         => 'rw',
  isa        => 'Mason::Interp',
  lazy_build => 1,
);

sub _build_mason_interp {
  my $self = shift;

  my %config = %{ $self->mason_config };

  # Stringify comp_root and data_dir if they are objects
  #
  foreach my $key (qw(comp_root data_dir)) {
    $config{$key} .= "" if blessed( $config{$key} );
  }

  # Add globals
  #
  push( @{ $config{allow_globals} }, '$form', '$result' );

  my $mason_root_class = delete( $config{mason_root_class} );
  my $interp = $mason_root_class->new(%config);

  return $interp;
}

sub render {
  my ( $self ) = @_;

  my $interp = $self->mason_interp;

  my ( $form, $result );
  if ( $self->DOES('HTML::FormHandler::Result') ) {
    $result = $self;
    $form   = $self->form;
  } else {
    $result = $self->result;
    $form   = $self;
  }

  $interp->set_global( '$form' => $self, '$result' => $result );
  return $interp->run( $self->mason_template )->output;
}


1;
