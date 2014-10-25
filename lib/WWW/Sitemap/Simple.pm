package WWW::Sitemap::Simple;
use strict;
use warnings;
use Carp qw/croak/;
use Digest::MD5 qw/md5_hex/;
use Class::Accessor::Lite (
    rw  => [qw/ urlset indent /],
    ro  => [qw/ url /],
);

our $VERSION = '0.01';

my $DEFAULT_XMLNS  = 'http://www.sitemaps.org/schemas/sitemap/0.9';
my $DEFAULT_INDENT = "\t";
my @KEYS = qw/ loc lastmod changefreq priority /;

sub new {
    my $class = shift;
    my $args  = shift || +{};

    bless {
        urlset => {
            xmlns => $DEFAULT_XMLNS,
        },
        indent => $DEFAULT_INDENT,
        %{$args},
        url => +{},
    }, $class;
}

sub add {
    my ($self, $url, $params) = @_;

    my $id = $self->get_id($url);

    $self->url->{$id} = {
        %{$params || +{}},
        loc => $url,
    };

    return $id;
}

sub add_params {
    my ($self, $id, $params) = @_;

    croak "key is not exists: $id" unless exists $self->{url}{$id};

    for my $key (@KEYS) {
        $self->url->{$id}{$key} = $params->{$key} if exists $params->{$key};
    }
}

sub get_id {
    my ($self, $url) = @_;

    return md5_hex(__PACKAGE__ . $url);
}

sub write {
    my ($self) = @_;

    my $indent = $self->{indent} || '';

    my $xml = $self->_write_xml_header;

    for my $id (keys %{$self->url}) {
        my $item = "$indent<url>\n";
        for my $key (@KEYS) {
            if ( my $value = $self->url->{$id}{$key} ) {
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

    my $urlset_attr = '';
    for my $key (keys %{$self->urlset}) {
        my $value = $self->urlset->{$key};
        $urlset_attr .= qq| $key="$value"|;
    }
    my $header = <<"_XML_";
<?xml version="1.0" encoding="UTF-8"?>
<urlset$urlset_attr>
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


=head1 METHODS

=head2 new

constractor. There are parameters below.

=over 4

=item urlset // { xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9' }

=item indent // "\t"

=back

=head2 add

add new url. return an id(md5 hex string).

=head2 add_params

add parameters to url by id

=head2 write

write sitemap


=head1 CAVEAT

Your Sitemap must be UTF-8 encoded (you can generally do this when you save the file). As with all XML files, any data values (including URLs) must use entity escape codes for the characters.

see more detail: L<http://www.sitemaps.org/protocol.html#escaping>


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
