use strict;

use Test::More;
use Test::Requires qw(Text::Xslate);

use Plack::Middleware::Profiler::KYTProf;
use Plack::Test;
use Plack::Builder;
use HTTP::Request::Common;
use t::TestProfile;

# TODO use logger to test profiling
subtest 'Can profile Xslate with custom profile' => sub {
    my $app = sub {
        my $env      = shift;
        my $tx       = Text::Xslate->new;
        my $template = q{
        <h1>hello world</h1>
    };
        print $tx->render_string( $template, {} );

        return [ '200', [ 'Content-Type' => 'text/plain' ], ["Hello World"] ];
    };

    $app = Plack::Middleware::Profiler::KYTProf->wrap( $app,
        profiles => ['t::TestProfile']);

    test_psgi $app, sub {
        my $cb  = shift;
        my $res = $cb->( GET "/" );

        is $res->code, 200, "Response is returned successfully";
    };
};

done_testing;
