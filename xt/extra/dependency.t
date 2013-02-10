use Test::Dependencies
    exclude => [qw/Test::Dependencies Test::Base Test::Perl::Critic Plack::Middleware::Profiler::KYTProf/],
    style   => 'light';
ok_dependencies();
