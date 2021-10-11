#!/usr/bin/perl
package showcapacities;
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
	$res_set = $DB_DATA::inst->sel_query( $DB_DATA::dbh, $DB_DATA::all_cont, [] );
	
	my $ind = 0;
	map {
		#print Dumper $_->[$];

		$res_set->[$ind]->[2] = [ split " ", $_->[2] ]->[1] if $_->[2] != undefined;
		$res_set->[$ind]->[3] = [ split " ", $_->[3] ]->[1] if $_->[3] != undefined;
		$ind++;

	} @{$res_set};

	print JSON->new->utf8->encode($res_set);
}

1;
