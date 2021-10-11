#!/usr/bin/perl
package showcapacities;
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
	$res_set = $DB_DATA::inst->sel_query( $DB_DATA::dbh, $DB_DATA::all_cont, [] );
	#TEST
	#print $res_set->[3]->[3];	
	#print [ split " ", $res_set->[3]->[3] ]->[1];
	
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
