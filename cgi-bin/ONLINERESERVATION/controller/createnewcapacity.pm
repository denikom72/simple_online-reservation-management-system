#!/usr/bin/perl
package createnewcapacity;
#use strict;

#use lib '/home/denis/simple_online-reservation-management-system/cgi-bin/ONLINERESERVATION';
use Data::Dumper;
use modules;
 
use param_accessors;

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

	my $persons = $cgi->param('persQuantity');

	my $par = param_accessors->new;

	
	$par->startDate( $cgi->param('startDate') );
	
	$par->endDate( $cgi->param('endDate') );
	
	$par->startTime( $cgi->param('startTime') );
	
	$par->endTime( $cgi->param('endTime') );
	
	$par->start( $par->startDate, $par->startTime ); 	
	
	$par->end( $par->endDate, $par->endTime ); 	
	

	my $message = $DB_DATA::inst->db_crud( $DB_DATA::dbh, $DB_DATA::createnewcap, [$persons, $par->start, $par->end] );

	print JSON->new->utf8->encode( [$message] );
}

1;
