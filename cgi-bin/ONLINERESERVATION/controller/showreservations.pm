#!/usr/bin/perl
package showreservations;
#use strict;
#

use Data::Dumper;
use modules;

use param_accessors;

sub new { 
	my $type = shift;
        my $self = {};       
	bless $self, $type;
        $self;
}


sub printres {
	my $self = shift;
	my $args = shift;
	
	my $cgi = CGI->new;
	

	my $par = param_accessors->new;

	
	$par->startDate( $cgi->param('startDate') );

	$par->endDate( $cgi->param('endDate') );


	$par->startTime( $cgi->param('startTime') );
	
	$par->endTime( $cgi->param('endTime') );
	
	$par->start( $par->startDate, $par->startTime ); 	
	
	$par->end( $par->endDate, $par->endTime ); 	

	print "Content-type: text/json\n\n";
	
	$res_set = $DB_DATA::inst->sel_query( $DB_DATA::dbh, $DB_DATA::all_res, [ $par->start, $par->start, $par->start, $par->end ] );
	
	print JSON->new->utf8->encode($res_set);
}

1;
