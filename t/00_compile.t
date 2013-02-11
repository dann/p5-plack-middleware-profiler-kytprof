use strict;
use warnings;
use Test::More;

use_ok('Plack::Middleware::Profiler::KYTProf');
use_ok('Plack::Middleware::Profiler::KYTProf::Profile::DefaultProfile');

done_testing;
