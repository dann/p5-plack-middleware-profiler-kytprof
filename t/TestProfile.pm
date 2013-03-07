package t::TestProfile;
use strict;
use warnings;

sub load {
    my $class = shift;
    $class->_add_template_engine_profs;
}

sub _add_template_engine_profs {
    my $class = shift;
    $class->_add_xslate_prof;
}

sub _add_xslate_prof {
    my $class = shift;

    Devel::KYTProf->add_prof(
        "t::TestPerson",
        "name",
        sub {
            my ( $orig, $self, $args ) = @_;
            return "tarou";
        }
    );
}

1;
