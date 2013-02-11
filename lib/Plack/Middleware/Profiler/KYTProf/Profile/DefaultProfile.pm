package Plack::Middleware::Profiler::KYTProf::Profile::DefaultProfile;
use strict;
use warnings;

sub load {
    my $class = shift;
    $class->_add_template_engine_profs;
    $class->_add_kvs_profs;
}

#-------------------------------------------
# Template Engines
#-------------------------------------------
sub _add_template_engine_profs {
    my $class = shift;
    $class->_add_xslate_prof;
    $class->_add_tt2_prof;
    $class->_add_template_pro_prof;
    $class->_add_mojo_template_prof;
}

sub _add_xslate_prof {
    my $class = shift;

    Devel::KYTProf->add_prof(
        "Text::Xslate",
        "render",
        sub {
            my ( $orig, $self, $file, $args ) = @_;
            return sprintf '%s %s', "render", $file;
        }
    );

}

sub _add_tt2_prof {
    my $class = shift;
    Devel::KYTProf->add_prof(
        "Template",
        "process",
        sub {
            my ( $orig, $class, $file, $args ) = @_;
            return sprintf '%s %s', "render", $file;
        }
    );
}

sub _add_mojo_template_prof {
    Devel::KYTProf->add_prof(
        "Mojo::Template",
        "render_file",
        sub {
            my ( $orig, $class, $file, $args ) = @_;
            return sprintf '%s %s', "render_file", $file;
        }
    );

    Devel::KYTProf->add_prof(
        "Mojo::Template",
        "render",
        sub {
            my ( $orig, $class, $args ) = @_;
            return sprintf '%s', "render";
        }
    );

}

sub _add_template_pro_prof {
    my $class = shift;
    Devel::KYTProf->add_prof(
        "HTML::Template::Pro",
        "output",
        sub {
            my ( $orig, $class, $args ) = @_;
            return sprintf '%s', "output";
        }
    );
}

#-------------------------------------------
# KVS
#-------------------------------------------
sub _add_kvs_profs {
    my $class = shift;
    $class->_add_redis_prof;
}

sub _add_redis_prof {
    my $class = shift;

    for my $method (
        qw/
        set get incr decr exists del type
        rpush lpush llen lrange ltrim lindex lset lrem lpop rpop
        sadd scard sismember smembers spop srem sort
        /
        )
    {
        Devel::KYTProf->add_prof(
            'Redis', $method,
            sub {
                my ( $orig, $self, $key ) = @_;
                return sprintf '%s %s', $method, $key;
            }
        );
    }

    for my $method_multi (qw/ mget /) {
        Devel::KYTProf->add_prof(
            'Redis',
            $method_multi,
            sub {
                my ( $orig, $self, @args ) = @_;
                if ( ref $args[0] eq 'ARRAY' ) {
                    return sprintf '%s %s', $method_multi,
                        join( ', ', map { $_->[0] } @args );
                }
                else {
                    return sprintf '%s %s', $method_multi,
                        join( ', ',
                        map { ref($_) eq 'ARRAY' ? join( ', ', @$_ ) : $_ }
                            @args );
                }
            }
        );
    }
}

1;
