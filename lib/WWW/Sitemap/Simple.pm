package WWW::Sitemap::Simple;
use strict;
use warnings;
use Carp qw/croak/;
use Digest::MD5 qw/md5_hex/;

our $VERSION = '0.01';

my @KEYS = qw/ loc lastmod changefreq priority /;

sub new {
    my $class = shift;
    my $args  = shift || +{};

    bless {
        urlset => {
            xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9',
        },
        indent => "\t",
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

    for my $key (@KEYS) {
        $self->{url}{$id}{$key} = $params->{$key} if exists $params->{$key};
    }
}

sub write {
    my ($self) = @_;

    my $indent = $self->{indent} || '';

    my $xml = $self->_write_xml_header;

    for my $id (keys %{$self->{url}}) {
        my $item = "$indent<url>\n";
        for my $key (@KEYS) {
            if ( my $value = $self->{url}{$id}{$key} ) {
                $item .= "$indent$indent<$key>$value</$key>\n";
            }
        }
        $xml .= "$item$indent</url>\n";
    }

    $xml .= $self->_write_xml_footer;

    print $xml;
}

sub _write_xml_header {
    my ($self) = @_;

    my $header = <<"_XML_";
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="$self->{urlset}{xmlns}">
_XML_
    return $header;
}

sub _write_xml_footer {
    my ($self) = @_;

    my $footer = <<"_XML_";
</urlset>
_XML_
    return $footer;
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
