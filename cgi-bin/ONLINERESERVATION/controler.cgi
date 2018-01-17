#!/usr/bin/perl
package controler;

use modules;

my $rand_date = " ";
# JUST IF SOMEBODY WAS LOGIN WITH ADMIN-RIGHTS, IT IS POSSIBLE TO USE THIS PMs, RESP. TO MAKE AN INSTANCE OF IT
my @listOfPm = 
( 
	"mysave", 
	"myupdate", 
	"mydelete", 
	"mytruncate", 
	"newprice", 
	"productlimit2" 
);

my $cgi = CGI->new;

$rand_date = $cgi->param("rand_date") if defined $cgi->param("rand_date");
### CONNECT DB, SEND QUERY ###
#my $rand = $DB_DATA::inst->sel_query( $DB_DATA::dbh, $DB_DATA::sql_sess_ofId, [1] );

#open(MYLOG, ">>mylog.txt") or die $!;

my $ALLOWED = 1;

if( $rand->[0][1] == 0 && $rand->[0][0] !~ /$rand_date/){
	map {
		if( defined $cgi->param("action") && $cgi->param("action") =~ /$_/gi ) {
			$ALLOWED = 0;
			last;	
		}
	} @listOfPm;
} 

$ALLOWED == 1 ? $cgi->param("action")->new()->printres([ @ARGV ]) : print JSON->new->utf8->encode(["foo"]);
