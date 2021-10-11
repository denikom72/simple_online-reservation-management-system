#!/usr/bin/perl
package makereservation;
#use strict;
use Data::Dumper;
use modules;
 
####CONSTRUCTOR### 
sub new { 
	my $type = shift;
        my $self = {};       
	bless $self, $type;
        $self;
}

sub printres {
	my $self = shift;
	my $args = shift;
	print "Content-type: text/json\n\n";
	
	my $cgi = CGI->new;

	my $contId = sprintf("%d", $cgi->param('contIDs'));
	my $persons = sprintf("%d", $cgi->param('persQuantity'));
	
	my $par = param_accessors->new;
	
	$par->startDate( $cgi->param('startDate') );

	$par->endDate( $cgi->param('endDate') );

	$par->startTime( $cgi->param('startTime') );
	
	$par->endTime( $cgi->param('endTime') );
	
	$par->start( $par->startDate, $par->startTime ); 	
	
	$par->end( $par->endDate, $par->endTime ); 	

	$DB_DATA::inst->db_crud( $DB_DATA::dbh, $DB_DATA::makereserv_fixed, [$contId, $persons, $par->start, $par->end, $contId, $par->start, $par->start, $par->end, $par->end, $par->start, $par->end, $par->start, $par->end, $par->start, $persons, $contId, $par->start, $par->start, $par->end, $par->end, $par->start, $par->end, $par->start, $par->end, $par->start, $persons, $contId, $par->start, $contId, $par->end, $contId ] );
	
	print JSON->new->utf8->encode(["Reservation done"]);
}

1;
