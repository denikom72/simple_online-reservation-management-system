#!/usr/bin/perl
package checkreservations;
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

	#TODO define accessor-mutator or getter/setter for it. Functional-Parad. == stable code	
	my $persons = sprintf( "%d", $cgi->param('persQuantity') );
	
	
	my $par = param_accessors->new;

	
	$par->startDate( $cgi->param('startDate') );

	$par->endDate( $cgi->param('endDate') );


	$par->startTime( $cgi->param('startTime') );
	
	$par->endTime( $cgi->param('endTime') );
	
	$par->start( $par->startDate, $par->startTime ); 	
	
	$par->end( $par->endDate, $par->endTime ); 	

	#TODO define accessor-mutator or getter/setter for it. Functional-Parad == stable code	
	$res_set = $DB_DATA::inst->sel_query( $DB_DATA::dbh, $DB_DATA::checkreserv, [ $par->start, $par->start, $par->end, $par->end, $par->start, $par->end, $persons ] );
	
	
	print JSON->new->utf8->encode($res_set);
}

1;
