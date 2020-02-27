IF DB_ID('StepComputerAcademy') IS NOT NULL
BEGIN
	USE master
	 ALTER DATABASE StepComputerAcademy SET single_user with rollback immediate
    DROP DATABASE StepComputerAcademy
END
GO 

CREATE DATABASE StepComputerAcademy
GO

USE StepComputerAcademy
GO

CREATE TABLE Subjects
(
	Id bigint NOT NULL PRIMARY KEY,
	Name nvarchar(50) NOT NULL
)
GO

CREATE TABLE Specializations
(
	Id bigint NOT NULL PRIMARY KEY,
	Name nvarchar(50) NOT NULL,
)
GO

CREATE TABLE Groups
(
	Id bigint NOT NULL PRIMARY KEY,
	Name nvarchar(50) NOT NULL,
	SpecializationFk bigint

	FOREIGN KEY (SpecializationFk) REFERENCES Specializations(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
GO

CREATE TABLE Students
(
	Id bigint NOT NULL PRIMARY KEY,
	FullName nvarchar(50) NOT NULL,
	GroupFk bigint

	FOREIGN KEY (GroupFk) REFERENCES Groups(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
GO

CREATE TABLE Teachers
(
	Id bigint NOT NULL PRIMARY KEY,
	FullName nvarchar(50) NOT NULL,
	GroupFk bigint,

	FOREIGN KEY (GroupFk) REFERENCES Groups(Id)
	    ON DELETE CASCADE
        ON UPDATE CASCADE
)
GO

CREATE TABLE TeachersAndSubjects
(
	Id bigint NOT NULL PRIMARY KEY,
	TeacherFk bigint,
	SubjectFk bigint,

	FOREIGN KEY (TeacherFk) REFERENCES Teachers(Id)
	    ON DELETE CASCADE
        ON UPDATE CASCADE,
	FOREIGN KEY (SubjectFk) REFERENCES Subjects(Id)
	    ON DELETE CASCADE
        ON UPDATE CASCADE
)
GO

CREATE TABLE Schedules
(
	TeacherAndSubjectFk bigint,
	StudentFk bigint,
	ThisDateTime datetime,

	FOREIGN KEY (TeacherAndSubjectFk) REFERENCES TeachersAndSubjects(Id)
	    ON DELETE NO ACTION
        ON UPDATE NO ACTION,
	FOREIGN KEY (StudentFk) REFERENCES Students(Id)
	    ON DELETE NO ACTION 
        ON UPDATE NO ACTION
)
GO

INSERT INTO Specializations VALUES (1, 'Программирование')
INSERT INTO Specializations VALUES (2, 'Дизайн')
INSERT INTO Specializations VALUES (3, 'Администрирование')

INSERT INTO Groups VALUES (1, 'ЕКО-18П3', 1)
INSERT INTO Groups VALUES (2, 'ЕКО-18П1', 3)
INSERT INTO Groups VALUES (3, 'БПУ-1821', 2)

INSERT INTO Students VALUES (1, 'Ваня Иванов', 3)
INSERT INTO Students VALUES (2, 'Степа Степанов', 2)
INSERT INTO Students VALUES (3, 'Кузьма Кузьмин', 1)

INSERT INTO Teachers VALUES (1, 'Иванов Иванович Иванов', 2)
INSERT INTO Teachers VALUES (2, 'Петр Петрович Петров', 1)
INSERT INTO Teachers VALUES (3, 'Сидор Сидорович Сидоров', 3)

INSERT INTO Subjects VALUES (1, 'Cpp')
INSERT INTO Subjects VALUES (2, 'Рисование')
INSERT INTO Subjects VALUES (3, 'Cisco')

INSERT INTO TeachersAndSubjects VALUES (1, 1, 2)
INSERT INTO TeachersAndSubjects VALUES (2, 2, 3)
INSERT INTO TeachersAndSubjects VALUES (3, 3, 1)
INSERT INTO TeachersAndSubjects VALUES (4, 2, 1)
INSERT INTO TeachersAndSubjects VALUES (5, 1, 3)
INSERT INTO TeachersAndSubjects VALUES (6, 3, 2)

INSERT INTO Schedules VALUES (1, 1, '2020-02-02 09:00')
INSERT INTO Schedules VALUES (2, 2, '2020-02-03 12:00')
INSERT INTO Schedules VALUES (3, 3, '2020-02-04 13:20')

GO

SELECT Schedules.ThisDateTime AS 'Date and Time', Teachers.FullName AS 'Teacher`s Full Name',
 Students.FullName AS 'Student`s Full Name', Subjects.Name AS 'Subject',
 Groups.Name AS 'Group', Specializations.Name AS 'Specialization'
FROM Schedules, Teachers, Students, Subjects, Groups, Specializations, TeachersAndSubjects
WHERE Schedules.TeacherAndSubjectFk = TeachersAndSubjects.Id AND
Schedules.StudentFk = Students.Id AND
Groups.SpecializationFk = Specializations.Id AND
TeachersAndSubjects.TeacherFk = Teachers.Id AND
TeachersAndSubjects.SubjectFk = Subjects.Id AND
Students.GroupFk = Groups.Id