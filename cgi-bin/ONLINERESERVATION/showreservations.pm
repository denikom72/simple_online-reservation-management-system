#!/usr/bin/perl
package showreservations;
#use strict;
use Data::Dumper;
use modules;
 
####DB-LOGIN-DATA
#$modules::DB_DATA::table = "es";

####ACCESSORS
our $accIns_el = sub {
                # make plausibility check with sprintf ...
                my ( $ref, $sql ) = ( shift, shift );
                $ins_post = $sql if $sql ne "";
                $ins_post;
};

####CONSTRUCTOR### 
sub new { 
	my $type = shift;
        my $self = {};       
	bless $self, $type;
        $self;
}

####DB-METHODS###

sub printres {
	my $self = shift;
	my $args = shift;
	
	my $cgi = CGI->new;
	
	#FORMATTER FOR DATETIME
	( my $startDate = $cgi->param('startDate') ) =~ s/\//-/gi;	
	my @strtD = split /\-/, $startDate;
	$startDate = $strtD[2]."/".$strtD[0]."/".$strtD[1];

	( my $endDate = $cgi->param('endDate') ) =~ s/\//-/gi;	
	my @endD = split( /\-/, $endDate );
	$endDate = $endD[2]."/".$endD[0]."/".$endD[1];
	
	( my $startTime = $cgi->param('startTime') ) =~ s/(am|pm)/:00/gi;
	( my $endTime = $cgi->param('endTime') ) =~ s/(am|pm)/:00/gi;
	

	( my $start = $startDate." ".$startTime ) =~ s/(^\s*|\s*$)//gi;
	( my $end = $endDate." ".$endTime ) =~ s/(^\s*|\s*$)//gi;


	print "Content-type: text/json\n\n";
	$res_set = $DB_DATA::inst->sel_query( $DB_DATA::dbh, $DB_DATA::all_res, [ $start, $end, $start, $end ] );
	
	print JSON->new->utf8->encode($res_set);
}

1;
