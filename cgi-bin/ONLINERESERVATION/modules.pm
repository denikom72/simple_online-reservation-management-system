package modules;
#use DBI;
use CGI;
use JSON;
use Data::Dumper;

use lib '/var/www/cgi-bin/ONLINERESERVATON';
use db_manager;
use showcapacities;
use showreservations;
use checkreservations;
use makereservation;
use createnewcapacity;
use deletecapacity;
use DB_DATA;

1; 
