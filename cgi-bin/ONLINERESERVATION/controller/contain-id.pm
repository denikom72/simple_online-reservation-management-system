#!/usr/bin/perl
package showreservations;
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
	$res_set = $DB_DATA::inst->sel_query( $DB_DATA::dbh, $DB_DATA::all_res, [] );
	
	print JSON->new->utf8->encode($res_set);
}

1;
