# This is -*-Perl-*- code
## Bioperl Test Harness Script for Modules
##
# $Id: MitoProt.t,v 1.1 2003/07/26 
# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.t'
use strict;
use vars qw($NUMTESTS $DEBUG $ERROR);
$DEBUG = $ENV{'BIOPERLDEBUG'} || 0;
BEGIN {
    # to handle systems with no installed Test module
    # we include the t dir (where a copy of Test.pm is located)
    # as a fallback
    eval { require Test; };
    $ERROR = 0;
    if( $@ ) {
	use lib 't';
    }
    use Test;

    $NUMTESTS = 8;
    plan tests => $NUMTESTS;

    eval {
	require IO::String; 
	require LWP::UserAgent;
    }; 
    if( $@ ) {
        warn("IO::String or LWP::UserAgent not installed. This means that the module is not usable. Skipping tests");
	$ERROR = 1;
    }
}

END {
    foreach ( $Test::ntest..$NUMTESTS) {
	skip('unable to run all of the tests depending on web access',1);
    }
}

exit 0 if $ERROR ==  1;

use Data::Dumper;

require Bio::Tools::Analysis::Protein::Mitoprot;
use Bio::PrimarySeq;
require Bio::WebAgent;

ok 1;

my $verbose = 0;
$verbose = 1 if $DEBUG;

ok my $tool = Bio::WebAgent->new(-verbose =>$verbose);



my $seq = Bio::PrimarySeq->new(-seq => 'MSADQRWRQDSQDSFGDSFDGDSFFGSDFDGDSDFGSDFGSDGDFGSDFGDSFGDGFSDRSRQDQRS',
						-display_id => 'test2');

ok $tool = Bio::Tools::Analysis::Protein::Mitoprot->new( -seq=>$seq);
ok $tool->run ();
ok my $raw = $tool->result('');
ok my $parsed = $tool->result('parsed');
ok ($parsed->{'charge'}, -13);
my @res = $tool->result('Bio::SeqFeatureI');
if (scalar @res > 0) {
    ok 1;
} else {
    skip('No network access - could not connect to NetPhos server', 1);
}
