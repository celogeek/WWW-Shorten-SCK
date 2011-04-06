use strict;
use warnings;

# ABSTRACT: WWW::Shorten::SCK - Perl interface to sck.to

=head1 SYNOPSIS

    use WWW::Shorten::SCK;
    use WWW::Shorten 'SCK';

    $short_url = makeashorterlink($long_url);
    $long_url = makealongerlink($short_url);

=head1 DESCRIPTION

A Perl interface to the web sck.to. SCK keep a database of long URLs,
and give you a tiny one.

=cut

package WWW::Shorten::SCK;

use 5.006;

use base qw( WWW::Shorten::generic Exporter );
our @EXPORT  = qw( makeashorterlink makealongerlink );
our $VERSION = '1.90';

use Carp;

=method makeashorterlink

The function C<makeashorterlink> will call the SCK web site passing
it your long URL and will return the shorter SCK version.

=cut

sub makeashorterlink {
    my $url     = shift or croak 'No URL passed to makeashorterlink';
    my $ua      = __PACKAGE__->ua();
    my $sck_url = 'http://sck.to';
    my $resp    = $ua->get(
        $sck_url,
        [
            a   => 1,
            url => $url,
        ]
    );
    return unless $resp->is_success;
    my $content = $resp->content;
    if ( $content =~ qr{\Qhttp://sck.to/\E} ) {
        return $content;
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
    $sck_url = "http://sck.to/$sck_url"
      unless $sck_url =~ m!^http://!i;

    #short should contain sck.to
    return unless $sck_url = qr{^\Qhttp://sck.to/\E};

    my $resp = $ua->get( $sck_url, [ a => 1 ] );

    return unless $resp->is_success;
    return $resp->content;
}

1;

__END__

=head1 SUPPORT, LICENCE, THANKS and SUCH

See the main L<WWW::Shorten> docs.

=head1 SEE ALSO

L<WWW::Shorten>, L<perl>, L<http://sck.to/>

=cut

