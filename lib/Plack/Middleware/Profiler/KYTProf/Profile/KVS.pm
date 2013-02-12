package Plack::Middleware::Profiler::KYTProf::Profile::KVS;
use strict;
use warnings;

sub load {
    my $class = shift;
    $class->_add_kvs_profs;
}

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
