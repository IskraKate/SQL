IF DB_ID('FootballChampionship') IS NOT NULL
BEGIN
	USE master
		 ALTER DATABASE FootballChampionship SET single_user with rollback immediate
    DROP DATABASE FootballChampionship
END
GO 

CREATE DATABASE FootballChampionship
GO

USE FootballChampionship
GO

CREATE TABLE Positions
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100) NOT NULL
)
GO

CREATE TABLE Equipment
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100) NOT NULL
)
GO


CREATE TABLE Countries
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100) NOT NULL
)
GO

CREATE TABLE Trainers
(
	Id int PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100) NOT NULL,
	CountryFk INT,
	CountryChampFk INT,

	FOREIGN KEY (CountryFk) REFERENCES Countries(Id),
	FOREIGN KEY (CountryChampFk) REFERENCES Countries(Id)
)
GO

CREATE TABLE Cities
(
	Id int PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100) NOT NULL,
	CountryFk INT

	FOREIGN KEY (CountryFk) REFERENCES Countries(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
GO

CREATE TABLE Stadiums
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100) NOT NULL,
	Capacity INT,
	CityFk INT

	FOREIGN KEY (CityFk) REFERENCES Cities(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
GO

CREATE TABLE Commands
(	
	Id int PRIMARY KEY IDENTITY,
	CountryFk INT NOT NULL,
	TrainerFk INT NOT NULL,
	EquipmentFk int NOT NULL

	FOREIGN KEY (CountryFk) REFERENCES Countries(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (TrainerFk) REFERENCES Trainers(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (EquipmentFk) REFERENCES Equipment(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
Go


CREATE TABLE Players
(
	Id int PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100) NOT NULL,
	PositionFk INT NOT NULL,
	CommandFk INT NOT NULL

	FOREIGN KEY (CommandFk) REFERENCES Commands(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (PositionFk) REFERENCES Positions(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
GO

CREATE TABLE Associations
(
	Id int PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100) NOT NULL
)
Go

CREATE TABLE DatesOfGroup
(
	Id int PRIMARY KEY IDENTITY,
	Schedule DATETIME
)

CREATE TABLE DatesOf1s8
(
	Id int PRIMARY KEY IDENTITY,
	Schedule DATETIME
)

CREATE TABLE DatesOf1s4
(
	Id int PRIMARY KEY IDENTITY,
	Schedule DATETIME
)

CREATE TABLE DatesOf1s2
(
	Id int PRIMARY KEY IDENTITY,
	Schedule DATETIME
)

CREATE TABLE DatesofFinal
(
	Id int PRIMARY KEY IDENTITY,
	Schedule DATETIME
)

CREATE TABLE Judges
(
	Id int PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100) NOT NULL,
	AssociationFk INT NOT NULL, 
	CountryFk INT NOT NULL

	FOREIGN KEY (AssociationFk) REFERENCES Associations(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
Go

CREATE TABLE Groups
(
    Id INT PRIMARY KEY IDENTITY,
	CommandFk1 INT NOT NULL,
	CommandFk2 INT NOT NULL,
	CommandFk3 INT NOT NULL,
	CommandFk4 INT NOT NULL

	FOREIGN KEY (CommandFk1) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (CommandFk2) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,	
	FOREIGN KEY (CommandFk3) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (CommandFk4) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
)
GO

CREATE TABLE Points
(
	CommandFk INT PRIMARY KEY NOT NULL,
	GroupFk INT NULL,
	PointsSum INT 

	FOREIGN KEY (CommandFk) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (GroupFk) REFERENCES Groups(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
)
GO

CREATE TABLE MatchWinLoses
(
  CommandFk INT PRIMARY KEY NOT NULL,
  Wins INT NULL,
  Loses INT NULL 

  FOREIGN KEY (CommandFk) REFERENCES Commands(Id)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
)
GO

CREATE TABLE MatchesGroup
(
	Id INT PRIMARY KEY IDENTITY,
	Schedule DATETIME NOT NULL,
	CommandFk1 INT NOT NULL,
	CommandFk2 INT NOT NULL,
	JudgeFk INT NOT NULL,
	StadiumFk INT NOT NULL,
	MatchType NVARCHAR(10) NOT NULL,
	PeopleOnTheStadium INT NOT NULL,


	FOREIGN KEY (JudgeFk) REFERENCES Judges(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (StadiumFk) REFERENCES Stadiums(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (CommandFk1) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (CommandFk2) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
)
GO

CREATE TABLE Matches1s8 
(
	Id INT PRIMARY KEY IDENTITY,
	Schedule DATETIME NOT NULL,
	CommandFk1 INT NOT NULL,
	CommandFk2 INT NOT NULL,
	JudgeFk INT NOT NULL,
	StadiumFk INT NOT NULL,
	MatchType NVARCHAR(10) NOT NULL,
	PeopleOnTheStadium INT NOT NULL,

	FOREIGN KEY (JudgeFk) REFERENCES Judges(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (StadiumFk) REFERENCES Stadiums(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (CommandFk1) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (CommandFk2) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
)
GO

CREATE TABLE Matches1s4
(
	Id INT PRIMARY KEY IDENTITY,
	Schedule DATETIME NOT NULL,
	CommandFk1 INT NOT NULL,
	CommandFk2 INT NOT NULL,
	JudgeFk INT NOT NULL,
	StadiumFk INT NOT NULL,
	MatchType NVARCHAR(10) NOT NULL,
	PeopleOnTheStadium INT NOT NULL,

	FOREIGN KEY (JudgeFk) REFERENCES Judges(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (StadiumFk) REFERENCES Stadiums(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (CommandFk1) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (CommandFk2) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
)
GO

CREATE TABLE Matches1s2
(
	Id INT PRIMARY KEY IDENTITY,
	Schedule DATETIME NOT NULL,
	CommandFk1 INT NOT NULL,
	CommandFk2 INT NOT NULL,
	JudgeFk INT NOT NULL,
	StadiumFk INT NOT NULL,
	MatchType NVARCHAR(10) NOT NULL,
	PeopleOnTheStadium INT NOT NULL,

	FOREIGN KEY (JudgeFk) REFERENCES Judges(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (StadiumFk) REFERENCES Stadiums(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (CommandFk1) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (CommandFk2) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
)
GO

CREATE TABLE MatchesFinal
(
	Id INT PRIMARY KEY IDENTITY,
	Schedule DATETIME NOT NULL,
	CommandFk1 INT NOT NULL,
	CommandFk2 INT NOT NULL,
	JudgeFk INT NOT NULL,
	StadiumFk INT NOT NULL,
	MatchType NVARCHAR(10) NOT NULL,
	PeopleOnTheStadium INT NOT NULL,

	FOREIGN KEY (JudgeFk) REFERENCES Judges(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (StadiumFk) REFERENCES Stadiums(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (CommandFk1) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (CommandFk2) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
)
GO

CREATE TABLE MatchGroupResults
(
	Id INT PRIMARY KEY NOT NULL,
	WinnerFk INT NULL,
	LooserFk INT NULL,
	Result NVARCHAR(10) NULL,

	FOREIGN KEY (Id) REFERENCES MatchesGroup(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (WinnerFk) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (LooserFk) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
)
GO

CREATE TABLE Match1s8Results
(
	Id INT PRIMARY KEY NOT NULL,
	WinnerFk INT NULL,
	LooserFk INT NULL,
	Result NVARCHAR(10) NULL,

	FOREIGN KEY (Id) REFERENCES Matches1s8(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (WinnerFk) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (LooserFk) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
)
GO

CREATE TABLE Match1s4Results
(
	Id INT PRIMARY KEY NOT NULL,
	WinnerFk INT NULL,
	LooserFk INT NULL,
	Result NVARCHAR(10) NULL,

	FOREIGN KEY (Id) REFERENCES Matches1s4(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (WinnerFk) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (LooserFk) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
)
GO

CREATE TABLE Match1s2Results
(
	Id INT PRIMARY KEY NOT NULL,
	WinnerFk INT NULL,
	LooserFk INT NULL,
	Result NVARCHAR(10) NULL,

	FOREIGN KEY (Id) REFERENCES Matches1s2(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (WinnerFk) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (LooserFk) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
)
GO

CREATE TABLE MatchFinalResults
(
	Id INT PRIMARY KEY NOT NULL,
	WinnerFk INT NULL,
	LooserFk INT NULL,
	Result NVARCHAR(10) NULL,

	FOREIGN KEY (Id) REFERENCES MatchesFinal(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (WinnerFk) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (LooserFk) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
)
GO

CREATE TABLE TopScorers
(
	Id INT PRIMARY KEY IDENTITY,
	TimeOfGoal NVARCHAR(10) NOT NULL,
	PlayerFk INT NOT NULL,
	MatchFk INT NULL,
	Match1s8Fk INT NULL,
	Match1s4Fk INT NULL,
	Match1s2Fk INT NULL, 
	MatchFinalFk INT NULL, 
	MatchType NVARCHAR(10),

	FOREIGN KEY (PlayerFk) REFERENCES Players(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE, 
	FOREIGN KEY(MatchFk) REFERENCES MatchesGroup(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY(Match1s8Fk) REFERENCES Matches1s8(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY(Match1s4Fk) REFERENCES Matches1s4(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY(Match1s2Fk) REFERENCES Matches1s2(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY(MatchFinalFk) REFERENCES MatchesFinal(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
)
GO

CREATE TABLE Winners
(
	Id INT PRIMARY KEY IDENTITY,
	FirstPlaceFk INT NOT NULL,
	SecondPlaceFk INT NOT NULL,
	ThirdPlaceFk INT NOT NULL,

	FOREIGN KEY (FirstPlaceFk) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (SecondPlaceFk) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (ThirdPlaceFk) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
)
GO

CREATE TABLE Goals
(
	CommandFk INT PRIMARY KEY ,
	GoalsCount INT, 

	FOREIGN KEY (CommandFk) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
)
GO

CREATE TABLE GoalsScored
(
	CommandFk INT PRIMARY KEY ,
	GoalsCount INT, 

	FOREIGN KEY (CommandFk) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
)
GO

------------------------------------------------------------------------------------------

CREATE TABLE #ImportPositions
(
	[Name] NVARCHAR(100) NOT NULL
)
GO
BULK INSERT #ImportPositions
FROM 'C:\Users\katei\source\repos\sql-homework\10-Exam\TextFiles\Positions.txt'
WITH 
( 
    ROWTERMINATOR = '\n'
)

INSERT INTO Positions([Name])
SELECT #ImportPositions.[Name]
FROM #ImportPositions
GO

DROP TABLE #ImportPositions
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE TABLE #ImportEquipment
(
    [Name] VARCHAR(max)
)
GO
BULK INSERT #ImportEquipment
FROM 'C:\Users\katei\source\repos\sql-homework\10-Exam\TextFiles\Equipment.txt'
WITH 
( 
    ROWTERMINATOR = '\n'
)

INSERT INTO Equipment([Name])
SELECT #ImportEquipment.[Name]
FROM #ImportEquipment
GO

DROP TABLE #ImportEquipment
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE TABLE #ImportCountries
(
    [Name] NVARCHAR(100)
)
GO
BULK INSERT #ImportCountries
FROM 'C:\Users\katei\source\repos\sql-homework\10-Exam\TextFiles\Countries.txt'
WITH 
( 
    ROWTERMINATOR = '\n'
)

INSERT INTO Countries([Name])
SELECT #ImportCountries.[Name]
FROM #ImportCountries
GO

DROP TABLE #ImportCountries
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE TABLE #ImportTrainers
(	
    Id INT,
	CountryFk int,
    [Name] NVARCHAR(100)
)
GO
BULK INSERT #ImportTrainers
FROM 'C:\Users\katei\source\repos\sql-homework\10-Exam\TextFiles\Trainers.txt'
WITH 
( 	
	FIELDTERMINATOR = '|',
    ROWTERMINATOR = '\n'
)
GO

CREATE PROCEDURE FillTrainers
AS
BEGIN

DECLARE @index INT;
SET @index = (SELECT TOP 1 #ImportTrainers.Id FROM #ImportTrainers)

DECLARE @maxIndex INT;
SET @maxIndex = (SELECT MAX(#ImportTrainers.Id) FROM #ImportTrainers)


WHILE(@index <  @maxIndex)
BEGIN
	 
    INSERT INTO Trainers([Name], CountryFk, CountryChampFk)
	SELECT #ImportTrainers.[Name], #ImportTrainers.CountryFk, t.ctry
	FROM #ImportTrainers, (SELECT TOP 1 Countries.Id AS ctry FROM Countries ORDER BY NEWID()) t
	WHERE #ImportTrainers.Id = @index

	SET @index +=1;

END

END
GO

EXECUTE FillTrainers;
GO

DROP TABLE #ImportTrainers
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE TABLE #ImportCities
(
    [Name] NVARCHAR(100),
	CountryFk int
)
GO
BULK INSERT #ImportCities
FROM 'C:\Users\katei\source\repos\sql-homework\10-Exam\TextFiles\Cities.txt'
WITH 
( 
	FIELDTERMINATOR = '|',
    ROWTERMINATOR = '\n'
)

INSERT INTO Cities([Name], CountryFk)
SELECT #ImportCities.[Name], #ImportCities.CountryFk
FROM #ImportCities
GO

DROP TABLE #ImportCities
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE TABLE #ImportStadiums
(
	CityFk int,
    [Name] VARCHAR(100),
	Capacity int
)
GO
BULK INSERT #ImportStadiums
FROM 'C:\Users\katei\source\repos\sql-homework\10-Exam\TextFiles\Stadiums.txt'
WITH 
( 
	FIELDTERMINATOR = '|',
    ROWTERMINATOR = '\n'
)

INSERT INTO Stadiums([Name], CityFk, Capacity)
SELECT #ImportStadiums.[Name], #ImportStadiums.CityFk, #ImportStadiums.Capacity
FROM #ImportStadiums
GO

DROP TABLE #ImportStadiums
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE PROCEDURE FillRndCommands
AS
BEGIN

DECLARE @index INT;
SET @index = 32

WHILE(@index >  0)
BEGIN
	INSERT INTO Commands(CountryFk, TrainerFk, EquipmentFk)
	SELECT t1.Country, t1.Trainer, t2.Equipment
	FROM (SELECT Trainers.CountryFk AS Country, t.trn AS Trainer
		  FROM Trainers, (SELECT TOP 1 Trainers.Id trn 
						  FROM Trainers		
						  ORDER BY NEWID())t  
		  WHERE Trainers.Id = t.trn) t1,
		 (SELECT TOP 1 Equipment.Id AS Equipment FROM Equipment ORDER BY NEWID()) t2
	SET @index -=1;
END

END
GO

EXECUTE FillRndCommands;
GO

CREATE PROCEDURE FillPointsNulls
AS
BEGIN
INSERT INTO Points(CommandFk, PointsSum)
SELECT Commands.Id, 0
FROM Commands
END
GO

CREATE PROCEDURE FillGoalsNulls
AS 
BEGIN
INSERT INTO Goals(CommandFk, GoalsCount)
SELECT Commands.Id, 0
FROM Commands
END
GO

CREATE PROCEDURE FillGoalsScoredNulls
AS 
BEGIN
INSERT INTO GoalsScored(CommandFk, GoalsCount)
SELECT Commands.Id, 0
FROM Commands
END
GO

CREATE PROCEDURE FillMatchWinsLosesNulls
AS 
BEGIN
INSERT INTO MatchWinLoses(CommandFk, Wins, Loses)
SELECT Commands.Id, 0, 0
FROM Commands
END
GO

EXEC FillPointsNulls;
Go

EXEC FillGoalsNulls;
GO

EXEC FillMatchWinsLosesNulls;
GO

EXEC FillGoalsScoredNulls;
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE TABLE  #ImportPlayers
(    
	 [Name] NVARCHAR(100),
	 PositionFk INT
)
GO
BULK INSERT #ImportPlayers
FROM 'C:\Users\katei\source\repos\sql-homework\10-Exam\TextFiles\Players.txt'
WITH 
( 
	FIELDTERMINATOR = '|',
    ROWTERMINATOR = '\n'
)
GO

ALTER TABLE  #ImportPlayers 
ADD Id INT PRIMARY KEY IDENTITY
GO

CREATE PROCEDURE FillPlayers 
AS 
BEGIN
	DECLARE @i INT;
	DECLARE @minIndex INT;
	DECLARE @maxIndex INT;
	DECLARE @commandFk INT;
	DECLARE @position INT;

	DECLARE @name NVARCHAR(30);
	DECLARE @playerId INT;

	SET @playerId = (SELECT TOP 1 #ImportPlayers.Id FROM #ImportPlayers);

	SET @minIndex = (SELECT TOP 1 Commands.Id FROM Commands)
	SET @maxIndex = (SELECT MAX(Commands.Id) FROM Commands)

	SET @i = 0;

	WHILE(@i < (SELECT COUNT(*) FROM #ImportPlayers))
	BEGIN
		IF @minIndex = @maxIndex + 1
		BEGIN
			SET @minIndex = (SELECT TOP 1 Commands.Id FROM Commands)
		END

		SET @name = (SELECT #ImportPlayers.[Name] FROM #ImportPlayers WHERE #ImportPlayers.Id = @playerId)

		SET @position = (SELECT PositionFk FROM #ImportPlayers WHERE  #ImportPlayers.Id = @playerId);

		SET @commandFk = (@minIndex);

		INSERT INTO Players([Name], PositionFk, CommandFk) VALUES (@name, @position, @commandFk)

		SET @minIndex += 1;
		SET @playerId += 1;

		SET @i += 1;
	END
END
GO

EXECUTE FillPlayers;
GO

DROP TABLE #ImportPlayers;
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE TABLE #ImportAssociations
(
	 [Name] NVARCHAR(100)
)
GO
BULK INSERT #ImportAssociations
FROM 'C:\Users\katei\source\repos\sql-homework\10-Exam\TextFiles\Associations.txt'
WITH 
( 
	FIELDTERMINATOR = '|',
    ROWTERMINATOR = '\n'
)

INSERT INTO Associations([Name])
SELECT #ImportAssociations.[Name]
FROM #ImportAssociations
GO

DROP TABLE #ImportAssociations
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE TABLE #ImportJudges
(
	 [Name] NVARCHAR(100)
)
GO
BULK INSERT #ImportJudges
FROM 'C:\Users\katei\source\repos\sql-homework\10-Exam\TextFiles\Judges.txt'
WITH 
( 
    ROWTERMINATOR = '\n'
)
GO

ALTER TABLE #ImportJudges
ADD Id INT PRIMARY KEY IDENTITY
GO

CREATE PROCEDURE FillRndJudges
AS
BEGIN

DECLARE @maxIndex INT;
DECLARE @countryFk INT;
DECLARE @name NVARCHAR(30);
DECLARE @assotiationFk INT;
DECLARE @i INT;

SET @maxIndex = (SELECT MAX(Id) FROM #ImportJudges)
SET @i = (SELECT TOP 1 Id FROM #ImportJudges)

WHILE(@i <= @maxIndex)
BEGIN

	SET @countryFk = (SELECT TOP 1 Id FROM Countries ORDER BY NEWID());

	SET @assotiationFk =  (SELECT TOP 1 Id FROM Associations ORDER BY NEWID());

	SET @name = (SELECT #ImportJudges.[Name] FROM #ImportJudges WHERE #ImportJudges.Id = @i) 

	INSERT INTO Judges ([Name], AssociationFk, CountryFk) 
	VALUES(@name, @assotiationFk, @countryFk);

 	SET @i +=1;
END

END
GO

EXECUTE FillRndJudges

DROP TABLE #ImportJudges
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE TABLE #ImportDates
(
	 Schedule Datetime
)
GO
BULK INSERT #ImportDates
FROM 'C:\Users\katei\source\repos\sql-homework\10-Exam\TextFiles\GroupTime.txt'
WITH 
( 
	FIELDTERMINATOR = '|',
    ROWTERMINATOR = '\n'
)

SELECT * FROM #ImportDates

INSERT INTO DatesOfGroup(Schedule)
SELECT #ImportDates.Schedule
FROM #ImportDates
GO

DROP TABLE #ImportDates
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE TABLE #ImportDates
(
	 Schedule Datetime
)
GO
BULK INSERT #ImportDates
FROM 'C:\Users\katei\source\repos\sql-homework\10-Exam\TextFiles\1s8Time.txt'
WITH 
( 
	FIELDTERMINATOR = '|',
    ROWTERMINATOR = '\n'
)

SELECT * FROM #ImportDates

INSERT INTO DatesOf1s8(Schedule)
SELECT #ImportDates.Schedule
FROM #ImportDates
GO

DROP TABLE #ImportDates
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE TABLE #ImportDates
(
	 Schedule Datetime
)
GO
BULK INSERT #ImportDates
FROM 'C:\Users\katei\source\repos\sql-homework\10-Exam\TextFiles\1s4Time.txt'
WITH 
(
    ROWTERMINATOR = '\n'
)

SELECT * FROM #ImportDates

INSERT INTO DatesOf1s4(Schedule)
SELECT #ImportDates.Schedule
FROM #ImportDates
GO

DROP TABLE #ImportDates
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE TABLE #ImportDates
(
	 Schedule Datetime
)
GO
BULK INSERT #ImportDates
FROM 'C:\Users\katei\source\repos\sql-homework\10-Exam\TextFiles\1s2Time.txt'
WITH 
( 
    ROWTERMINATOR = '\n'
)

SELECT * FROM #ImportDates

INSERT INTO DatesOf1s2(Schedule)
SELECT #ImportDates.Schedule
FROM #ImportDates
GO

DROP TABLE #ImportDates
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE TABLE #ImportDates
(
	 Schedule Datetime
)
GO
BULK INSERT #ImportDates
FROM 'C:\Users\katei\source\repos\sql-homework\10-Exam\TextFiles\FinalTime.txt'
WITH 
( 
    ROWTERMINATOR = '\n'
)

SELECT * FROM #ImportDates

INSERT INTO DatesOfFinal(Schedule)
SELECT #ImportDates.Schedule
FROM #ImportDates
GO

DROP TABLE #ImportDates
GO
------------------------------------------------------------------------------------------







