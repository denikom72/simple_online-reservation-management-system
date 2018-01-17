#!/usr/bin/perl
package makereservation;
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

	my $contId = sprintf("%d", $cgi->param('contIDs'));
	#$contId = 5;	
	my $persons = sprintf("%d", $cgi->param('persQuantity'));
	#print $contId; die();


#	print $cgi->param("startDate")."|".$cgi->param("startTime");
#	print "\n";
#	print $cgi->param("endDate"). "|".$cgi->param("endTime");
#	die();	
	#FORMATTER FOR DATETIME

	( my $startDate = $cgi->param('startDate') ) =~ s/\//-/gi;	
	my @strtD = split /\-/, $startDate;
	$startDate = $strtD[2]."-".$strtD[0]."-".$strtD[1];

	( my $endDate = $cgi->param('endDate') ) =~ s/\//-/gi;	
	my @endD = split( /\-/, $endDate );
	$endDate = $endD[2]."-".$endD[0]."-".$endD[1];
	
	( my $startTime = $cgi->param('startTime') ) =~ s/(am|pm)/:00/gi;
	( my $endTime = $cgi->param('endTime') ) =~ s/(am|pm)/:00/gi;
	

	( my $start = $startDate." ".$startTime ) =~ s/(^\s*|\s*$)//gi;
	( my $end = $endDate." ".$endTime ) =~ s/(^\s*|\s*$)//gi;
	
	#my $res_set =  [ $start, $end ];

	#print $DB_DATA::checkreserv." - ".$start." - ".$end;die();
	#print $start." - ".$end;die();

	#if( $contId != "" ){	
		#$DB_DATA::inst->db_crud( $DB_DATA::dbh, $DB_DATA::makres, [sprintf ( "%d", $contId), sprintf("%d",$persons), $start, $end] );
	#} else {
		$DB_DATA::inst->db_crud( $DB_DATA::dbh, $DB_DATA::makereserv1_dummy, [$contId, $persons, $start, $end, $contId, $start, $start, $end, $end, $start, $end, $start, $end, $start, $persons, $contId] );
	#}
	#$DB_DATA::inst->db_crud( $DB_DATA::dbh, $DB_DATA::makereserv1_dummy, [$persons] );
	
	print JSON->new->utf8->encode(["Reservation done"]);
}

1;
