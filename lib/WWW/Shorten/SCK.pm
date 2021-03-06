package WWW::Shorten::SCK;
use strict;
use warnings;
use LWP::Protocol::https;
use URI::Escape qw/uri_escape_utf8/;
use JSON;
# VERSION

# ABSTRACT: Perl interface to sck.pm

=head1 SYNOPSIS

    use WWW::Shorten 'SCK';

    my $long_url = "a long url";
    my $short_url = "";
    $short_url = makeashorterlink($long_url);
    $long_url = makealongerlink($short_url);

=head1 DESCRIPTION

A Perl interface to the web sck.pm. SCK keep a database of long URLs,
and give you a tiny one.

=cut

use 5.006;

use parent qw( WWW::Shorten::generic Exporter );
use vars qw(@EXPORT_OK %EXPORT_TAGS);
@EXPORT_OK  = qw( makeashorterlink makealongerlink );
%EXPORT_TAGS = ( all => [@EXPORT_OK] );

use Carp;

=method makeashorterlink

The function C<makeashorterlink> will call the SCK web site passing
it your long URL and will return the shorter SCK version.

=cut

sub makeashorterlink {
    my $url     = shift or croak 'No URL passed to makeashorterlink';
    my $ua      = __PACKAGE__->ua();
    my $sck_url = 'https://api.sck.pm';
    my $resp    = $ua->get(
        $sck_url . '/shorten?' . $url,
    );
    return unless $resp->is_success;
    my $content = decode_json($resp->content);
    if (ref $content && $content->{status} eq 'OK') {
        return $content->{short_url};
    }
    return;
}

=head2 makealongerlink

The function C<makealongerlink> does the reverse. C<makealongerlink>
will accept as an argument either the full SCK URL or just the
SCK identifier.

If anything goes wrong, then either function will return nothing.

=cut

sub makealongerlink {
    my $sck_url = shift
      or croak 'No SCK key / URL passed to makealongerlink';
    my $ua = __PACKAGE__->ua();

    #call api to get long url from the short
    if ($sck_url =~ /^https?:\/\/sck.pm\/(.*)$/x) {
        $sck_url = $1;
    }

    my $resp = $ua->get( "https://api.sck.pm/expand?" . $sck_url );
    return unless $resp->is_success;
    my $content = decode_json($resp->content);
    if (ref $content && $content->{status} eq 'OK') {
        return $content->{url};
    }
    return;

}

1;

__END__

=head1 SUPPORT, LICENSE, THANKS and SUCH

See the main L<WWW::Shorten> docs.

=head1 SEE ALSO

L<WWW::Shorten>, L<perl>, L<https://www.sck.pm/>

=cut

