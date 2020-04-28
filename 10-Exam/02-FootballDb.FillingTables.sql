USE FootballChampionship
GO

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

EXEC FillPointsNulls;
Go

EXEC FillGoalsNulls;
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








