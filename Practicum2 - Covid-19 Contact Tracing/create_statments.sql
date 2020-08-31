CREATE DATABASE contactTracer;
USE contactTracer;

CREATE TABLE appUser(
userID INT PRIMARY KEY,
userPassword VARCHAR(30) NOT NULL,
firstName CHAR(30) NOT NULL,
lastName CHAR(30),
phone VARCHAR(13) NOT NULL UNIQUE
);


CREATE TABLE address(
zipcode INT PRIMARY KEY,
city CHAR(20) NOT NULL,
state CHAR(20) NOT NULL
);


CREATE TABLE healthMonitorAdmin(
adminID INT PRIMARY KEY,
regLat DECIMAL(10,8) signed NOT NULL,
regLong DECIMAL(11,8) signed NOT NULL,
qualification VARCHAR(30),
CONSTRAINT hm_admin FOREIGN KEY(adminID) REFERENCES appUser(userID)
);


CREATE TABLE naiveUser(
naiveUserID INT PRIMARY KEY,
gender ENUM('Male', 'Female', 'Other'),
dob DATE NOT NULL,
age INT,
immunoCompromised BOOLEAN NOT NULL,
lastSync DATETIME,
livingSituation ENUM('Group','isolated'),
infectionStatus ENUM('infected','suspected','not-infected') NOT NULL, 
zipcode INT NOT NULL,
CONSTRAINT naivU FOREIGN KEY(naiveUserID) REFERENCES appUser(userID),
CONSTRAINT zip FOREIGN KEY(zipcode) REFERENCES address(zipcode) ON DELETE CASCADE
    ON UPDATE CASCADE
);


CREATE TABLE GPSlocation(
gpsLoc INT PRIMARY KEY,
gpsLat DECIMAL(10,8) signed NOT NULL,
gpsLong DECIMAL(11,8) signed NOT NULL,
date DATE NOT NULL
);


CREATE TABLE tracker(
trackerID INT PRIMARY KEY,
gpsLoc INT NOT NULL,
naiveUserID INT NOT NULL,
CONSTRAINT gps_track FOREIGN KEY(gpsLoc) REFERENCES GPSlocation(gpsLoc)
ON DELETE CASCADE
    ON UPDATE CASCADE,

CONSTRAINT track_naive FOREIGN KEY(naiveUserID) REFERENCES naiveUser(naiveUserID)
ON DELETE CASCADE
    ON UPDATE CASCADE
);



CREATE TABLE travelHistory(
country VARCHAR(20),
naiveUserID INT,
CONSTRAINT cn_naive PRIMARY KEY (country, naiveUserID),
CONSTRAINT travel_naive FOREIGN KEY(naiveUserID) REFERENCES naiveUser(naiveUserID)
ON DELETE CASCADE
    ON UPDATE CASCADE
);




CREATE TABLE survey(
surveyID INT PRIMARY KEY,
temperature INT,
maskWorn BOOLEAN NOT NULL,
dateOfSurvey DATE NOT NULL,
naiveUserID INT NOT NULL,
CONSTRAINT survey_user FOREIGN KEY(naiveUserID) REFERENCES naiveUser(naiveUserID)
ON DELETE CASCADE
    ON UPDATE CASCADE
);


CREATE TABLE lab(
labID INT PRIMARY KEY,
labName VARCHAR(30),
zipcode INT NOT NULL,
CONSTRAINT zip_lab FOREIGN KEY(zipcode) REFERENCES address(zipcode)
ON DELETE CASCADE
    ON UPDATE CASCADE
);


CREATE TABLE test(
testID INT PRIMARY KEY,
testType TEXT,
testDate DATE NOT NULL,
result BOOLEAN NOT NULL,
naiveUserID INT NOT NULL,
labID INT NOT NULL,
CONSTRAINT test_lab FOREIGN KEY(labID) REFERENCES lab(labID),
CONSTRAINT test_user FOREIGN KEY(naiveUserID) REFERENCES naiveUser(naiveUserID)
ON DELETE CASCADE
    ON UPDATE CASCADE
);


CREATE TABLE symptom(
symptomID INT PRIMARY KEY,
symptomName ENUM('Fever', 'Dry Cough', 'Chest Pain', 'Shortness of Breath', 'tiredness') 
);


CREATE TABLE surveySymptom (
symptomID INT,
surveyID INT,
CONSTRAINT sy_sr PRIMARY KEY(symptomID,surveyID),
CONSTRAINT sym_sur FOREIGN KEY(symptomID) REFERENCES symptom(symptomID)
ON DELETE CASCADE
    ON UPDATE CASCADE,
CONSTRAINT sur_sym FOREIGN KEY(surveyID) REFERENCES survey(surveyID)
ON DELETE CASCADE
    ON UPDATE CASCADE
);


CREATE TABLE notification(
notificationID INT PRIMARY KEY,
infectionRisk ENUM('High','low'),
userID INT NOT NULL,
CONSTRAINT notif_user FOREIGN KEY(userID) REFERENCES appUser(userID)
ON DELETE CASCADE
    ON UPDATE CASCADE
);
 















