/* Primary keys always need to be unique, foreign keys need to allow non-unique values if the table is a one-to-many relationship. It is perfectly fine to use a foreign key as the primary key if the table is connected by a one-to-one relationship, not a one-to-many relationship 

A foreign key is a field (or a set of fields) in a table that uniquely identifies a row of another table. The table in which the foreign key is defined is called the “child table” and it (often) refers to the primary key in the parent table.

A foreign key (FK) is a column or combination of columns that is used to establish and enforce a link between the data in two tables. You can create a foreign key by defining a FOREIGN KEY constraint when you create or modify a table

The FOREIGN KEY constraint is used to prevent actions that would destroy links between tables. The FOREIGN KEY constraint also prevents invalid data from being inserted into the foreign key column, because it has to be one of the values contained in the table it points to

SQL > Constraint > Foreign Key. A foreign key is a column (or columns) that references a column (most often the primary key) of another table. The purpose of the foreign key is to ensure referential integrity of the data. In other words, only values that are supposed to appear ( erscheinen ) in the database are permitted.

EXAMPLES
For the purpose of this example, we will create two simple database tables. They are not well designed, but will demonstrate the power of foreign keys!

employee: a table of company employees where each member is assigned a unique ID
borrowed: a table of borrowed books. Every record will reference a borrower’s employee ID.
We will define a foreign key relationship between the employee’s ID in both tables. This provides a couple of advantages:

It is not possible to enter an invalid employee ID in the ‘borrowed’ table.
Employee changes are handled automatically by MySQL.

CREATE DATABASE mydb;
USE mydb;

CREATE TABLE employee (
	id smallint(5) unsigned NOT NULL,
	firstname varchar(30),
	lastname varchar(30),
	birthdate date,
	PRIMARY KEY (id),
	KEY idx_lastname (lastname)
) ENGINE=InnoDB;

CREATE TABLE borrowed (
	ref int(10) unsigned NOT NULL auto_increment,
	employeeid smallint(5) unsigned NOT NULL,
	book varchar(50),
	PRIMARY KEY (ref)
) ENGINE=InnoDB;


ALTER TABLE borrowed 
ADD CONSTRAINT FK_borrowed 
FOREIGN KEY (employeeid) REFERENCES employee(id) 
ON UPDATE CASCADE
ON DELETE CASCADE;


Adding Table Data
We will now populate the tables with data. Remember that our employees must be added first:

employee:

id	firstname	lastname	birthdate
1	John	Smith	1976-01-02
2	Laura	Jones	1969-09-05
3	Jane	Green	1967-07-15
borrowed:

ref	employeeid	book
1	1	SitePoint Simply SQL
2	1	SitePoint Ultimate HTML Reference
3	1	SitePoint Ultimate CSS Reference
4	2	SitePoint Art and Science of JavaScript


SELECT book FROM borrowed 
JOIN employee ON employee.id=borrowed.employeeid 
WHERE employee.lastname='Smith';
Result:
SitePoint Simply SQL
SitePoint Ultimate HTML Reference
SitePoint Ultimate CSS Reference

Cascading in Action
The Accounts Department calls us with a problem: Laura’s employee ID must be changed from 2 to 22 owing to a clerical error. With standard MyISAM tables, you would need to change every table that referenced the employee ID. However, our InnoDB constraints ensure that changes are cascaded following a single update:


UPDATE employee SET id=22 WHERE id=2;

borrowed:

ref	employeeid	book
1	1	SitePoint Simply SQL
2	1	SitePoint Ultimate HTML Reference
3	1	SitePoint Ultimate CSS Reference
4	22	SitePoint Art and Science of JavaScript

DELETE FROM employee WHERE id=1;
The deletion is cascaded through to our borrowed table, so all John’s references are removed:

borrowed:

ref	employeeid	book
4	22	SitePoint Art and Science of JavaScript
Although this is a simple example, it demonstrates the power of foreign keys. It is easy to retain data integrity without additional code or complex series of SQL commands. Note there are other alternatives to ‘CASCADE’ in your UPDATE and DELETE definitions:

NO ACTION or RESTRICT: the update/delete is rejected if there are one or more related foreign key values in a referencing table, i.e. you could not delete the employee until their books had been returned.

SET NULL: update/delete the parent table row, but set the mis-matching foreign key columns in our child table to NULL (note that the table column must not be defined as NOT NULL).

The same concepts can be applied to large-scale databases containing dozens of tables with inter-linked relationships.


Meet the author
Craig Buckler 
Craig is a freelance UK web consultant who built his first page for IE2.0 in 1995. Since that time he's been advocating standards, accessibility, and best-practice HTML5 techniques. He's written more than 1,000 articles for SitePoint and you can find him @craigbuckler
SPONSORS


*/
/* PUT IF-QUERY IN THE BACKEND AND IF CAPACITY IS HIGHER THEN THE NUMBER OF PERSONS */
/*
DECLARE contId INT UNSIGNED DEFAULT 1;
*/

START TRANSACTION;
INSERT INTO reservations ( `cont_id`, `pers_quant`,`reserv_at`, `reserv_until`) 
SELECT d.* FROM (
	SELECT
	6 AS `contId`,
	4 AS `cap`,
	'2017-12-06 00:22:38' AS `strt`,
	'2017-12-06 03:22:38' AS `thnd`
) AS d
WHERE NOT EXISTS (
	d.strt > d.thnd
	AND
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
COMMIT;
--ROLLBACK

/* POPULATE DATABASE WITH DUMMYDATA - CONTAINERS ( TABLES, PLACES, ROOMS, ANY THINK ELSE  ) */

/* START AND THE_END MEANS THE TIMEAREA BETWEEN WHICH IT IS POSSIBLE TO MAKE A TIMERESERVATION */

--INSERT INTO containers ( `capacity`, `start`, `the_end`) VALUES ( 4, UNIX_TIMESTAMP('2017-12-05 00:22:38'), UNIX_TIMESTAMP('2017-12-05 03:22:38') );

INSERT INTO containers ( `capacity`, `start`, `the_end`) VALUES ( 4, '2017-12-05 00:22:38', '2017-12-05 03:22:38' );

CREATE TABLE `containers` (
  `cont_id` int(3) unsigned NOT NULL AUTO_INCREMENT,
  `capacity` int(2) unsigned NOT NULL,
  `start` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `the_end` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`cont_id`),
  UNIQUE KEY `cont_id` (`cont_id`,`start`),
  UNIQUE KEY `cont_id_2` (`cont_id`,`the_end`),
  UNIQUE KEY `cont_id_3` (`cont_id`)
) ENGINE=InnoDB;

CREATE TABLE `reservations` (
  `reserv_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cont_id` int(2) unsigned NOT NULL,
  `pers_quant` int(2) unsigned NOT NULL,
  `reserv_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `reserv_until` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`reserv_id`),
  UNIQUE KEY `reserv_id` (`reserv_id`,`reserv_at`),
  UNIQUE KEY `reserv_id_2` (`reserv_id`,`reserv_until`),
  UNIQUE KEY `reserv_id_3` (`reserv_id`),
) ENGINE=InnoDB;


ALTER TABLE `containers` MODIFY `cont_id` int(10)  UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY;


SELECT * FROM containers AS c LEFT JOIN reservations AS r 
		ON c.cont_id = r.cont_id WHERE 
			( c.capacity > 3 
			AND 
			( 
				"2017-12-06 00:22:35" < r.reserv_at 
				AND 
				"2017-12-06 00:22:34" < r.reserv_at 
				OR "2017-12-06 00:22:35" > r.reserv_until 
				AND "2017-12-06 00:22:37" > r.reserv_until
				/*TODO CHECK IF IT IS BETWEEN THE ALLOWED TIMEAREA*/
			)
)

