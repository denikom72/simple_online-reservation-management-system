#!/usr/bin/perl -w

BEGIN{
	use Cwd;
	my $cwd = cwd();
	push @INC, $cwd;
	
	push @INC, $cwd . "/view";
	push @INC, $cwd . "/model";
}

use CGI;
use DB_DATA;
use Data::Dumper;
my $cgi = new CGI;

my $SESSION = 0;

$RANDOM_DATE = $cgi->param("rand_date") ? $cgi->param("rand_date") : "PLACEHOLDER";

# INCLUDE STATIC HTML-FRAGMENTS
require header;	
#require loginForm if $SESSION != 1;
require ngNameSpace;

require ReservManagSys if $SESSION == 1;

#configurator-output
#require resSetTable;

require mainContent;

#javascript
require footerJs;

require ngNameSpaceEnd;


# END OF HTML
print "<pre>";
# OUTPUT SOME DEBUG DATA
print "</pre>";

print "</body></html>";
