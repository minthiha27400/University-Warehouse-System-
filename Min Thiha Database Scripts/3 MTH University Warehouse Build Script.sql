--University Warehouse Build 
-- Drop Tables
DROP TABLE Student_Dim CASCADE CONSTRAINTS;
DROP TABLE Enroll_Dim CASCADE CONSTRAINTS;   
DROP TABLE Lecturer_Dim CASCADE CONSTRAINTS;   
DROP TABLE Module_Dim CASCADE CONSTRAINTS;   
DROP TABLE Course_Dim CASCADE CONSTRAINTS;
DROP TABLE University_Fact CASCADE CONSTRAINTS;     

--Create Table for Warehouse Database
-- Create the Student_Dim table
CREATE TABLE Student_Dim (
    Student_ID NUMBER PRIMARY KEY,
    Student_name VARCHAR2(255),
    Email VARCHAR2(255)
);


-- Create the Lecturer_Dim table
CREATE TABLE Lecturer_Dim (
    Lecturer_ID NUMBER PRIMARY KEY,
    Lecturer_name VARCHAR2(255),
    Email VARCHAR2(255)
);

-- Create the Course_Dim table
CREATE TABLE Course_Dim (
    Course_ID NUMBER PRIMARY KEY,
    Course_name VARCHAR2(255),
    Start_Date DATE,
    End_Date DATE
);

-- Create Enroll_Dim table with partition
CREATE TABLE Enroll_Dim (
    Enroll_ID NUMBER PRIMARY KEY,
    Student_ID NUMBER,
    Course_ID NUMBER,
    Academic_year NUMBER
)
PARTITION BY RANGE (Academic_year) (
    PARTITION p2020 VALUES LESS THAN (2021),
    PARTITION p2021 VALUES LESS THAN (2022),
    PARTITION p2022 VALUES LESS THAN (2023),
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (MAXVALUE)
);

-- Create the Module_Dim table
CREATE TABLE Module_Dim (
    Module_ID NUMBER PRIMARY KEY,
    Module_name VARCHAR2(255),
    Course_ID NUMBER,
    Lecturer_ID NUMBER
    
);
-- Create University fact table
CREATE TABLE University_Fact (
    Fact_ID NUMBER GENERATED by default on null as IDENTITY,
    Academic_year NUMBER,
    Course_ID NUMBER,
    no_of_students NUMBER,
    no_of_passed_students NUMBER,
    no_of_failed_students NUMBER
);


CREATE INDEX idx_Student_Name ON Student_Dim(Student_name);
CREATE INDEX idx_Student_Email ON Student_Dim(Email);
CREATE INDEX idx_Lecturer_Name ON Lecturer_Dim(Lecturer_name);
CREATE INDEX idx_Lecturer_Email ON Lecturer_Dim(Email);
CREATE INDEX idx_Course_Name ON Course_Dim(Course_name);
CREATE INDEX idx_Enroll_Student_Course ON Enroll_Dim(Student_ID, Course_ID);
CREATE INDEX idx_Enroll_Academic_Year ON Enroll_Dim(Academic_year);
CREATE INDEX idx_Module_Name ON Module_Dim(Module_name);

-- Indexes for University_Fact table
CREATE INDEX idx_University_Fact_Academic_Year ON University_Fact(Academic_year);
CREATE INDEX idx_University_Fact_Course_ID ON University_Fact(Course_ID);


ALTER TABLE University_Fact
ADD CONSTRAINT pk_University_Fact PRIMARY KEY (Fact_ID);


--Foreign Keys
ALTER TABLE Enroll_Dim
ADD CONSTRAINT fk_Enroll_Student_Student_Dim
FOREIGN KEY (Student_ID)
REFERENCES Student_Dim (Student_ID);


ALTER TABLE Enroll_Dim
ADD CONSTRAINT fk_Enroll_Course_Course_Dim
FOREIGN KEY (Course_ID)
REFERENCES Course_Dim (Course_ID);


ALTER TABLE Module_Dim
ADD CONSTRAINT fk_Module_Course_Course_Dim
FOREIGN KEY (Course_ID)
REFERENCES Course_Dim (Course_ID);


ALTER TABLE Module_Dim
ADD CONSTRAINT fk_Module_Lecturer_Lecturer_Dim
FOREIGN KEY (Lecturer_ID)
REFERENCES Lecturer_Dim (Lecturer_ID);


COMMIT;
