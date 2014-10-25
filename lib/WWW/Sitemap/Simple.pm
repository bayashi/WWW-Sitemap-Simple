package WWW::Sitemap::Simple;
use strict;
use warnings;
use Carp qw/croak/;
use Digest::MD5 qw/md5_hex/;

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my $args  = shift || +{};

    bless {
        urlset => {
            xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9',
        },
        %{$args},
        url => {},
    }, $class;
}

sub add {
    my ($self, $url, $params) = @_;

    my $id = md5_hex($url);

    $self->{url}{$id} = {
        %{$params || +{}},
        loc => $url,
    };

    return $id;
}

sub add_params {
    my ($self, $id, $params) = @_;

    croak "key is not exists: $id" unless exists $self->{url}{$id};

    $self->{url}{$id} = %{$params};
}

sub write {
    my ($self) = @_;

    for my $id (keys %{$self->{url}}) {
        my $loc = $self->{url}{$id}{loc};
        print "$loc\n";
    }
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
