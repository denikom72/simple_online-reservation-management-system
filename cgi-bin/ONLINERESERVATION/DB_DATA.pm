package DB_DATA;
use strict;
use warnings;


use lib "/var/www/cgi-bin/ONLINERESERVATION/";
use db_manager;

use Exporter;
our @ISA = 'Exporter';

our @EXPORT = qw( $db $db_user $db_pw $table);

###CREDENTIALS###
our ( $db, $db_user, $db_pw ) = ("onlineReservation", "root", "t00rt00r");

our $table = "elems";
our $table1 = "reservations";
our $table2 = "containers";

our $inst = db_manager->new( $db, $db_user, $db_pw );	
our $dbh = $inst->con( $inst->{"db_name"}, $inst->{"user"}, $inst->{"pw"} );

###SQL-QUERIES###


our $checkreserv11 =' 
SELECT c.cont_id, c.capacity, r.pers_quant, c.start, c.the_end FROM containers AS c LEFT JOIN reservations AS r 
		ON c.cont_id = r.cont_id WHERE 
			( c.capacity > ? 
			AND 
			( 
				UNIX_TIMESTAMP(?) < r.reserv_at 
				AND 
				UNIX_TIMESTAMP(?) < r.reserv_at 
					OR 
				UNIX_TIMESTAMP(?) > r.reserv_until 
				AND 
				UNIX_TIMESTAMP(?) > r.reserv_until
				/*TODO CHECK IF IT IS BETWEEN THE ALLOWED TIMEAREA*/
			)
);
';

#SELECT c.cont_id AS ccontid, c.capacity, c.start, c.the_end 
#FROM containers AS c 
#LEFT JOIN reservations AS r
#ON c.cont_id = r.cont_id
#HAVING  ccontid NOT IN
#(
#     SELECT t1.cont_id
#     FROM reservations AS t1
#     INNER JOIN containers AS t2
#     ON t1.cont_id = t2.cont_id
#        
#)    

our $checkreserv =' 
SELECT c.cont_id AS ccontid, c.capacity AS ccap, c.start, c.the_end 
FROM containers AS c 
LEFT JOIN reservations AS r 
ON c.cont_id = r.cont_id  
GROUP BY ccontid
HAVING ccontid NOT IN 
(
	SELECT res.cont_id 
	FROM ' .$table1. ' AS res 
	WHERE
	UNIX_TIMESTAMP(?) >= UNIX_TIMESTAMP(res.reserv_at) 
	AND 
	UNIX_TIMESTAMP(?) <= UNIX_TIMESTAMP(res.reserv_until)
	OR
	UNIX_TIMESTAMP(?) >= UNIX_TIMESTAMP(res.reserv_at) 
	AND
	UNIX_TIMESTAMP(?) <= UNIX_TIMESTAMP(res.reserv_until)
	OR
	UNIX_TIMESTAMP(?) <= UNIX_TIMESTAMP(res.reserv_at) 
	AND
	UNIX_TIMESTAMP(?) >= UNIX_TIMESTAMP(res.reserv_at)
) AND  ? <= ccap;';

our $checkreserv2 ='
SELECT * FROM containers AS c
WHERE EXISTS ( SELECT * FROM reservations AS r WHERE
                                c.cont_id = r.cont_id
                        AND
                                c.capacity > ?
                        AND
                        (
                                UNIX_TIMESTAMP(?) < r.reserv_at
                                AND
                                UNIX_TIMESTAMP(?) < r.reserv_at
                                OR
                                UNIX_TIMESTAMP(?) > r.reserv_until
                                AND
                                UNIX_TIMESTAMP(?) > r.reserv_until
                                /*TODO CHECK IF IT IS BETWEEN THE ALLOWED TIMEAREA*/
                        )
);';

our $freeIDs = '
SELECT c.cont_id FROM containers AS c
WHERE c.cont_id NOT IN (
         SELECT r.cont_id FROM reservations AS r WHERE
         c.capacity > ? 
         AND (
                 UNIX_TIMESTAMP(?) > r.reserv_at AND UNIX_TIMESTAMP(?) < r.reserv_until
				OR
                 UNIX_TIMESTAMP(?) > r.reserv_at AND UNIX_TIMESTAMP(?) < r.reserv_until
				OR
                 UNIX_TIMESTAMP(?) < r.reserv_at AND UNIX_TIMESTAMP(?) > r.reserv_at
        )
);
';

our $createnewcap =
'
INSERT INTO containers (`capacity`, `start`, `the_end`) VALUES ( ?, ?, ? );
';

our $makres =
"
INSERT INTO reservations ( `cont_id`, `pers_quant`,`reserv_at`, `reserv_until`) 
SELECT d.* FROM (
	SELECT
	? AS `contId`,
	? AS `pers`,
	UNIX_TIMESTAMP(?) AS `strt`,
	UNIX_TIMESTAMP(?) AS `thnd`
) AS d
WHERE NOT EXISTS (
	SELECT * FROM reservations WHERE cont_id = d.contId
	AND  
	(
		d.strt >= reserv_at AND d.strt <= reserv_until 
																
		OR

		d.thnd >= reserv_at AND d.thnd <= reserv_until
					
		OR

		d.strt <= reserv_at AND d.thnd >= reserv_at
										
	)
);

";

our $makereserv1_dummy = 
'
INSERT INTO reservations ( `cont_id`, `pers_quant`,`reserv_at`, `reserv_until`)
SELECT ? AS cid, ? AS per,  ?,  ?  FROM containers AS c
WHERE ? NOT IN (
         SELECT r.cont_id FROM reservations AS r WHERE
                 UNIX_TIMESTAMP(?) >= UNIX_TIMESTAMP(r.reserv_at) 
		 AND 
		 UNIX_TIMESTAMP(?) <= UNIX_TIMESTAMP(r.reserv_until)
				OR
                 UNIX_TIMESTAMP(?) >= UNIX_TIMESTAMP(r.reserv_at) 
		 AND UNIX_TIMESTAMP(?) <= UNIX_TIMESTAMP(r.reserv_until)
				OR
                 UNIX_TIMESTAMP(?) <= UNIX_TIMESTAMP(r.reserv_at) 
		 AND UNIX_TIMESTAMP(?) >= UNIX_TIMESTAMP(r.reserv_at)
        
) AND UNIX_TIMESTAMP(?) < UNIX_TIMESTAMP(?) AND UNIX_TIMESTAMP(?) > UNIX_TIMESTAMP(NOW()) AND ? < ( SELECT capacity AS cap FROM containers AS con WHERE con.cont_id = ? )LIMIT 0,1;
';



our $makereserv2 = 'INSERT INTO reservations ( `cont_id`, `pers_quant`,`reserv_at`, `reserv_until`) VALUES ( ?,?,?,? );';

our $makereserv1 = '

SET @PERS = 3;
SET @ST = UNIX_TIMESTAMP("2017-12-06 00:22:38");
SET @END = UNIX_TIMESTAMP("2017-12-06 03:22:38");
/*
SET @PERS = ?;
SET @ST = ?;
SET @END = ?;
*/
INSERT INTO reservations ( `cont_id`, `pers_quant`,`reserv_at`, `reserv_until`)
SELECT c.cont_id, @PERS,  @ST,  @END  FROM containers AS c WHERE c.cont_id NOT IN
( SELECT r.cont_id FROM reservations AS r WHERE
          c.capacity > @PERS 
                AND
        (
                @ST > r.reserv_at AND @ST < r.reserv_until
                 OR
                @END > r.reserv_at AND @END < r.reserv_until
                 OR
                @ST < r.reserv_at AND @END > r.reserv_at
        ) 
 ) LIMIT 0,1;';


our $makereserv =" 
/* START TRANSACTION; */
INSERT INTO reservations ( `cont_id`, `pers_quant`,`reserv_at`, `reserv_until`) 
SELECT d.* FROM (
	SELECT
	6 AS `contId`,
	4 AS `cap`,
	\"2017-12-06 00:22:38\" AS `strt`,
	\"2017-12-06 03:22:38\" AS `thnd`
) AS d
WHERE NOT EXISTS (
	/*
	d.strt > d.thnd
	AND
	*/
	SELECT * FROM reservations WHERE cont_id = contId
	AND  
	(
		d.strt >= reserv_at AND d.strt <= reserv_until 
																
		OR

		d.thnd >= reserv_at AND d.thnd <= reserv_until
					
		OR

		d.strt <= reserv_at AND d.thnd >= reserv_at
										
	)
);
/* COMMIT; */

";

our $test3 = 'SELECT * FROM containers AS c WHERE c.cont_id IN (
        SELECT c.cont_id FROM reservations AS r WHERE
         c.capacity > 3 AND (

                "2017-12-06 00:22:38" > r.reserv_at AND "2017-12-06 00:22:38" < r.reserv_until

                OR

                "2017-12-06 02:22:38" > r.reserv_at AND "2017-12-06 02:22:38" < r.reserv_until

                OR

                "2017-12-06 00:22:38" < r.reserv_at AND "2017-12-06 02:22:38" > r.reserv_at
        )

);

';
#our $all_res = "SELECT * FROM " .$table1. ";";
our $all_res = "SELECT t1.reserv_id, t1.cont_id, t2.capacity, t1.pers_quant, t1.reserv_at AS t1resat, t1.reserv_until AS t1resuntil FROM " .$table1. " AS t1 INNER JOIN " .$table2. " AS t2 ON t1.cont_id = t2.cont_id HAVING UNIX_TIMESTAMP(?) >= UNIX_TIMESTAMP(t1resat) AND UNIX_TIMESTAMP(?) <= UNIX_TIMESTAMP(t1resuntil) OR UNIX_TIMESTAMP(?) <= UNIX_TIMESTAMP(t1resat) AND UNIX_TIMESTAMP(?) >= UNIX_TIMESTAMP(t1resuntil);";
our $all_cont = "SELECT * FROM " .$table2. ";";

#index
our $sql_sess = "SELECT rand_date, sess_act FROM login WHERE sess_act = ?;";

#controler
our $sql_sess_ofId = "SELECT rand_date, sess_act FROM login WHERE id = ?;";

#login
our $ins_credentials = "INSERT INTO login (user, pw) VALUES (?, ?);";
# this query select id from assigned categorie ( which is to an simple element ) and the column cat have to be be use to check is it zero,
# cause just then it can be used as a category for other elements
our $check_credentials = "SELECT id, sess_act FROM login WHERE user = ? AND pw = ?;";
our $set_random = "UPDATE login SET sess_act = ?, rand_date = ? ;";

#update
our $upd_logout = "UPDATE login SET sess_act = 0;";

#mysave, categs
our $ins_el = "INSERT INTO " . $table . " (el, cat, singleprice) VALUES (?, ?, ?);";
# this query select id from assigned categorie ( which is to an simple element ) and the column cat gonna be use to check is it zero, cause just then it can be used as a category for other elements
our $elem_id = "SELECT id FROM elems WHERE el = ?;";
our $categ_id = "SELECT cat FROM elems WHERE el = ?;";

#mytruncate
our $trunc_el = "TRUNCATE TABLE ". $table .";";
our $sel_categs = "SELECT el FROM " . $table . " WHERE cat=?;";
our $ins_price = "INSERT INTO " . $table . " (total_price) VALUES (?);";
# this query select id from assigned categorie ( which is to an simple element ) and the column cat gonna be use to check is it zero, cause just then it can be used as a category for other elements
our $price = "SELECT total_price FROM price;";

#mydelete
our $del_el = "DELETE FROM " . $table . " WHERE el = ?;";

#myupdate
our $update_el = "UPDATE " . $table . " SET cat = ? WHERE el = ?;";

#newprice
our $upd_price = "UPDATE price SET total_price = ? WHERE id = 1;";

our $sel_with_rownumb = "SELECT SQL_CALC_FOUND_ROWS * FROM " . $table;
our $sel_all = "SELECT * FROM " . $table . ";";
our $sel_all_categs = "SELECT cat FROM " . $table . ";";

our $del_container = "DELETE FROM containers WHERE cont_id = ?;";
#____________ONLINERESERVATION_CRUD_AND_QUERIES_____________

1;
