#!/usr/bin/perl
package service;
#use strict;
use Data::Dumper;
#use lib '/var/www/cgi-bin/CONFIGURATORCMS';
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
	$res_set = $DB_DATA::inst->sel_query( $DB_DATA::dbh, $DB_DATA::sel_all, [] );
	
	##########CONVERTER - LIST OF LIST TO LIST OF HASHREFs
	
	my ( $max, $ind, @listOfHash ) = ( 0, 0 );
	
	#my $test = [["1","TEST1","1"],["2","TEST1","1"],["3","TESTOSTERON","1"],["4","TEST1","1"],["5","TEST1","1"],["6","TEST1","1"],["7","TEST1","1"],["8","TEST1","1"],["9","TEST1","1"],["10","TEST1","1"],["11","TEST1","1"],["12","TEST1","1"],["13","TEST1","1"],["14","TEST1","1"],["15","TEST1","1"],["16","TEST1","1"],["17","TEST1","1"],["18","TEST1","1"],["19","TEST1","1"],["20","TEST1","1"],["21","TEST1","1"],["22","TEST1","1"],["23","TEST1","1"],["24","TEST1","1"],["25","TEST1","1"],["26","TEST1","1"],["27","TEST1","1"],["28","TEST1","1"],["29","TEST1","1"],["30","TEST1","1"],["31","TEST1","1"],["32","TEST1","1"],["33","TEST1","1"],["34","TEST1","1"],["35","TEST1","1"],["36","TEST4","3"],["37","TEST4","3"],["38","TEST4","3"]];
	
	#print $test->[0]->[1];
	
	map {
		#print $_->[2];
		#print "\n";
		if( $max < $_->[2] ){
			$max = $_->[2];
		}	
		#for(@{$_}){
		#	print;print "\n";
		#}
	} @{$res_set};
	
	
	
	
	for my $i( 0..$max ){
		#print;
		my ( %tmphash, @tmplist );
		my $ind = 0;
		map {
			if($_->[2] == $i && $_->[2] != 0){
				#print $res_set->[$i-1]->[1];
	
				#id begins from 1 and the row indisizes from 0, so that's why [$i-1]
				$tmphash{ $res_set->[$i-1]->[1] }->[$ind] = [ $_->[1], "EUR:".$_->[3] ];
	
				#@tmplist = ( @tmplist, $_->[1] );
				$ind++;
				#print "yess";
			}
		} @{$res_set};
	
		my @keysnumb = keys %tmphash;
		
		#print Dumper \%tmphash if $#keysnumb > -1; 
		#DONT FILL LIST WITH EMPTY HASHES, CREATED BY THE LOOP for example - max. is 4, but 3 and 2 are not categories ....
		push( @listOfHash, \%tmphash ) if $#keysnumb > -1;
	}
	
	#############END CONVERTER####################
	
	print JSON->new->utf8->encode(\@listOfHash);
}

1;
