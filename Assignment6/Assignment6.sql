-- name: Yadlapalli Saisrihitha
-- sqlite was used for this assignment


-- Added attributes email, ebook_count, paperback_count and total_book_count for the purpose of this assignment

CREATE TABLE IF NOT EXISTS "Author" (
  "aid" INTEGER PRIMARY KEY NOT NULL,
  "name" VARCHAR(255) NOT NULL,
  "email" VARCHAR(255) NOT NULL,
  "bio" TEXT,
  "ebook_count" INTEGER,
  "paperback_count" INTEGER,
  "total_book_count" INTEGER
);

-- Trigger 1 creation - Managing a constraint that ensures that email of author is of the form '%_@_%.__%'  via trigger

CREATE TRIGGER validate_email_before_insert_author 
   BEFORE INSERT ON Author
BEGIN
   SELECT
      CASE
	WHEN NEW.email NOT LIKE '%_@_%.__%' THEN
   	  RAISE (ABORT,'email address given is invalid')
       END;
END;

-- Trigger 2 creation - Calculation of derived attribute 'total_book_count' using trigger such that it is the sum of ebook_count and paperback_count

CREATE TRIGGER total_book_count
   AFTER INSERT ON Author FOR EACH ROW
BEGIN
   UPDATE Author SET total_book_count = ebook_count + paperback_count WHERE aid = NEW.aid;
END;

-- Trigger 1 constraint pass check

INSERT INTO Author (aid,name,email,bio)
VALUES(14,'Charles','charles@gmail.com','Creativity is life!');

/* Execution Output:
Execution finished without errors.
Result: query executed successfully. Took 0ms, 1 rows affected
At line 1: 
INSERT INTO Author (aid,name,email,bio)
VALUES(14,'Charles','charles@gmail.com','Creativity is life!'); */

-- Trigger 2 check

INSERT INTO Author (aid,name,email,bio,ebook_count,paperback_count)
VALUES(15,'Sidney Sheldon','sydney@yahoo.com','I write thrillers!',22,46),(34,'Enid','enid@hotmail.com','Hi!',12,65),(90,'J.K Rowling','rowling@edu.com','I write HP!',8,17) ;
SELECT * FROM Author WHERE Author.aid = 15 OR Author.aid = 34 OR Author.aid = 90;

/* OUTPUT with calculated derived attribute total_book_count using trigger

15	Sidney Sheldon	sydney@yahoo.com	I write thrillers!	22	46	68
34	Enid	          enid@hotmail.com	Hi!	                12	65	77
90	J.K Rowling	    rowling@edu.com	  I write HP!	        8	  17	25

*/

-- Trigger 1 constraint fail check

INSERT INTO Author (aid,name,email,bio)
VALUES(12,'Mark Frost','arandomemail','I love writing books');

/* Execution Output:
Execution finished with errors.
Result: email address given is invalid
At line 1:
INSERT INTO Author (aid,name,email,bio)
VALUES(12,'Mark Frost','arandomemail','I love writing books'); */
