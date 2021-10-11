#!/usr/bin/perl
package controller;

# Force to push the current working directory into the INC-List before importing the "modules" PM.
BEGIN{
	use Cwd;
	my $cwd = cwd();
	push @INC, $cwd;
	push @INC, $cwd . "/model";
	push @INC, $cwd . "/view";
	push @INC, $cwd . "/controller";
}

use modules;

my $ALLOWED = 1;


my $cgi = CGI->new;

#my $rand_date = " ";
## JUST IF SOMEBODY WAS LOGIN WITH ADMIN-RIGHTS, IT IS POSSIBLE TO USE THIS PMs, RESP. TO MAKE AN INSTANCE OF IT
#my @listOfPm = 
#( 
#	"mysave", 
#	"myupdate", 
#	"mydelete", 
#	"mytruncate", 
#	"newprice", 
#	"productlimit2" 
#);
#
#
#$rand_date = $cgi->param("rand_date") if defined $cgi->param("rand_date");
##open(MYLOG, ">>mylog.txt") or die $!;
#
#if( $rand->[0][1] == 0 && $rand->[0][0] !~ /$rand_date/){
#	map {
#		if( defined $cgi->param("action") && $cgi->param("action") =~ /$_/gi ) {
#			$ALLOWED = 0;
#			last;	
#		}
#	} @listOfPm;
#} 


$ALLOWED == 1 ? $cgi->param("action")->new()->printres([ @ARGV ]) : print JSON->new->utf8->encode(["Functon denied"]);
