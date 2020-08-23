CREATE TABLE IF NOT EXISTS "Author" (
  "aid" INTEGER PRIMARY KEY NOT NULL,
  "name" VARCHAR(255) NOT NULL,
  "bio" TEXT
);

-- Certifications exists as a separate table as it is a multivalued attribute i.e one author can have many certification and one certification can have many authors (Many to Many)

CREATE TABLE IF NOT EXISTS "Certification" (
	"id" INTEGER PRIMARY KEY NOT NULL,
	"name" VARCHAR(15) NOT NULL,
	CHECK (name IN ('CAP','CSM','CSTE','CBAP','PMP'))
);

-- Linking table for the many-to-many relationship between Author and Certification, On Delete Cascade used to maintain referential integrity

CREATE TABLE IF NOT EXISTS "AuthorCertification" (
	"cert_id" INTEGER,
	"author_id" INTEGER,
	PRIMARY KEY ("cert_id", "author_id"),
	FOREIGN KEY("author_id") REFERENCES "Author"("aid") ON DELETE CASCADE,
    FOREIGN KEY("cert_id") REFERENCES "Certification"("id") ON DELETE CASCADE
);

-- Foreign key "aid" present in topic in order to satisfy the One to Many relationship between Author and Topic, On Delete Set Null used to maintain referential integrity
-- I have used UNIQUE constraint to ensure that no two rows have all same attributes except "tid"

CREATE TABLE IF NOT EXISTS "Topic" (
	"tid" INTEGER PRIMARY KEY NOT NULL,
	"aid" INTEGER,
	"name" VARCHAR(255) NOT NULL,
	"topic_length" INTEGER,
	"subjectArea" VARCHAR(255) NOT NULL,
	UNIQUE("aid", "name", "topic_length", "subjectArea"),
	FOREIGN KEY("aid") REFERENCES "Author"("aid") ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS "Course" (
	"number" VARCHAR(255) PRIMARY KEY NOT NULL,
	"title" VARCHAR(255) NOT NULL,
	"course_length" INTEGER,
	UNIQUE("title", "course_length")
);

-- Linking table for the many-to-many relationship between Course and Topic, On Delete Cascade used to maintain referential integrity

CREATE TABLE IF NOT EXISTS "CourseTopic" (
	 "course_id" VARCHAR(255),
     "topic_id" INTEGER,
     PRIMARY KEY ("course_id", "topic_id"),
     FOREIGN KEY("course_id") REFERENCES "Course"("number") ON DELETE CASCADE,
     FOREIGN KEY("topic_id") REFERENCES "Topic"("tid") ON DELETE CASCADE
);

/*

Note1: Ensuring that every author has authored "at least one" (total participation) topic cannot be implemented via DDL alone and can can only be 
implemented via triggers which are small procedures (code) attached to a table that is run before or after some modification on the table

Note2: SQLite uses what it calls a dynamic typing system, which ultimately means that you can store text in integer fields and integers in text fields.
Flexible typing is considered a feature of SQLite, not a bug.

Note3: SQLite allows the primary key column to contain NULL values. Hence, there is a need to explicitly add NOT NULL constraint even though PRIMARY KEY is used.

*/
