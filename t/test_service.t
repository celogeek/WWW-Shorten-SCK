use strict;
use warnings;

use Carp;
use Test::More tests => 2;                      # last test to print
use WWW::Shorten "SCK";

my $long_url = "http://qa.celogeek.com/";
my $short_url = "http://sck.to/g/vJcSy";

is(makeashorterlink($long_url), $short_url, "Shorter works");
is(makealongerlink($short_url), $long_url, "Longer works");



