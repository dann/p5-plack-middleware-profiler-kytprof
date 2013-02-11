sub readme_from {
    warn
        "You need to install Module::Install::ReadmeFromPod to generate README";
}

sub use_test_base {
    warn "You need to install Test::Base to run make test from git clone";
}

sub author_requires {
    warn
        "You need to install Module::Install::AuthorRequires to install modules author requires";
}
sub author_tests        { }
sub auto_set_repository { }

use inc::Module::Install;

{
    no warnings 'redefine';
    *recommends_hack
        = $Module::Install::VERSION > 0.70
        ? sub { recommends(@_); $_[0] }
        : \&recommends;
}

name 'Plack-Middleware-Profiler-KYTProf';
all_from 'lib/Plack/Middleware/Profiler/KYTProf.pm';

requires(
    'parent'         => 0,
    'Plack'          => 0,
    'Devel::KYTProf' => 0,
    'Module::Load'   => 0,
);
test_requires( 'Test::More' => '0.98', );
use_test_base;
auto_include;
WriteAll;
