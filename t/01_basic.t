use strict;
use warnings;
use Test::More;

use WWW::Sitemap::Simple;

my $sm = WWW::Sitemap::Simple->new;
$sm->add("http://rebuild.fm/");
my $id = $sm->add("http://rebuild.fm/64/");
$sm->add_params($id, { priority => "0.8" });
$sm->write;

ok 1;

done_testing;
