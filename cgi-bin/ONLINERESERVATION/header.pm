print "Content-type: text/html\n\n";

# <<HTML allowed interpolation, <<'HTML' remove interpolation of $-character, vars ...
print <<'HTML';

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>Insert title here</title>
<base href="http://localhost/ONLINERESERVATION/layoutIt2/src/" target="_blank">
 
<script src="js/angular.min.js"></script>
	
<script src="jquery.min.js"></script>
<link href="css/bootstrap.min.css" rel="stylesheet">
<link href="css/style.css" rel="stylesheet">

<script type="text/javascript" src="jquery.timepicker.js"></script>
<link rel="stylesheet" type="text/css" href="jquery.timepicker.css">

<script type="text/javascript" src="bootstrap-datepicker.js"></script>
<link rel="stylesheet" type="text/css" href="bootstrap-datepicker.css">

<script type="text/javascript" src="site.js"></script>
<link rel="stylesheet" type="text/css" href="site.css">

<!-- link href="../../.././dataT_css/lib/jquery.dataTables.min.css" rel="stylesheet" -->

<link href="../../jquery.dataTables.css" rel="stylesheet">

<script type="text/javascript" src="jquery.dataTables.min.js"></script>
</head>


HTML
