#!/usr/bin/perl
package createnewcapacity;
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
	print "Content-type: text/json\n\n";
	
	my $cgi = CGI->new;

	
	my $persons = $cgi->param('persQuantity');

#	print $cgi->param("startDate")."|".$cgi->param("startTime");
#	print "\n";
#	print $cgi->param("endDate"). "|".$cgi->param("endTime");
#	die();	
	#FORMATTER FOR DATETIME

	( my $startDate = $cgi->param('startDate') ) =~ s/\//-/gi;	
	my @strtD = split /\-/, $startDate;
	$startDate = $strtD[2]."/".$strtD[1]."/".$strtD[0];

	( my $endDate = $cgi->param('endDate') ) =~ s/\//-/gi;	
	my @endD = split( /\-/, $endDate );
	$endDate = $endD[2]."/".$endD[1]."/".$endD[0];
	
	( my $startTime = $cgi->param('startTime') ) =~ s/(am|pm)/:00/gi;
	( my $endTime = $cgi->param('endTime') ) =~ s/(am|pm)/:00/gi;
	

	( my $start = $startDate." ".$startTime ) =~ s/(^\s*|\s*$)//gi;
	( my $end = $endDate." ".$endTime ) =~ s/(^\s*|\s*$)//gi;
	
	#my $res_set =  [ $start, $end ];

	#print $DB_DATA::checkreserv." - ".$start." - ".$end;die();
	#print $start." - ".$end;die();

		
	my $message = $DB_DATA::inst->db_crud( $DB_DATA::dbh, $DB_DATA::createnewcap, [$persons, $start, $end] );
	#$DB_DATA::inst->db_crud( $DB_DATA::dbh, $DB_DATA::makereserv1_dummy, [$persons, "2017-01-06 00:22:38", "2017-02-06 03:22:38"] );
	#$DB_DATA::inst->db_crud( $DB_DATA::dbh, $DB_DATA::makereserv1_dummy, [$persons] );
	
	print JSON->new->utf8->encode([$message]);
}

1;
