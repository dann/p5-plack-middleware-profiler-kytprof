use Mojolicious::Lite;
use Plack::Builder;

get '/' => 'index';

builder {
  enable "Profiler::KYTProf";
  app->start;
};

__DATA__

@@ index.html.ep
<html><body>Hello World</body></html>
