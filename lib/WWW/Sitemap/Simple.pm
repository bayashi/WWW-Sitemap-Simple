package WWW::Sitemap::Simple;
use strict;
use warnings;
use Carp qw/croak/;

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my $args  = shift || +{};

    bless $args, $class;
}

1;

__END__

=head1 NAME

WWW::Sitemap::Simple - simple sitemap builder


=head1 SYNOPSIS

    use WWW::Sitemap::Simple;

    my $sm = WWW::Sitemap::Simple->new;

    # simple way
    $sm->add('http://example.com/');

    # with params
    $sm->add(
        'http://example.com/foo' => {
            lastmod    => '2005-01-01',
            changefreq => 'monthly',
            priority   => '0.8',
        },
    );

    # set params later
    my $key = $sm->add('http://example.com/foo/bar');
    $sm->add_params(
        $key => {
            lastmod    => '2005-01-01',
            changefreq => 'monthly',
            priority   => '0.8',
        },
    );

    $sm->write('sitemap/file/path');


=head1 DESCRIPTION

WWW::Sitemap::Simple is the builder of sitemap with less dependencies.

see more detail about sitemap: L<http://www.sitemaps.org/protocol.html>


=head1 REPOSITORY

WWW::Sitemap::Simple is hosted on github: L<http://github.com/bayashi/WWW-Sitemap-Simple>

Welcome your patches and issues :D


=head1 AUTHOR

Dai Okabayashi E<lt>bayashi@cpan.orgE<gt>


=head1 SEE ALSO

L<WWW::Sitemap::XML>

L<Web::Sitemap>


=head1 LICENSE

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=cut
