USE FootballChampionship
GO

CREATE TABLE #ImportPositions
(
	[Name] NVARCHAR(100) NOT NULL
)
GO
BULK INSERT #ImportPositions
FROM 'C:\Users\katei\source\repos\sql-homework\10-Exam\Positions.txt'
WITH 
( 
    ROWTERMINATOR = '\n'
)

INSERT INTO Positions([Name])
SELECT #ImportPositions.[Name]
FROM #ImportPositions
GO

SELECT * FROM Positions

DROP TABLE #ImportPositions
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE TABLE #ImportEquipment
(
    [Name] VARCHAR(max)
)
GO
BULK INSERT #ImportEquipment
FROM 'C:\Users\katei\source\repos\sql-homework\10-Exam\Equipment.txt'
WITH 
( 
    ROWTERMINATOR = '\n'
)

SELECT * FROM  #ImportEquipment

INSERT INTO Equipment([Name])
SELECT #ImportEquipment.[Name]
FROM #ImportEquipment
GO

DROP TABLE #ImportEquipment
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE TABLE #ImportEquipment
(
    [Name] VARCHAR(max)
)
GO
BULK INSERT #ImportEquipment
FROM 'C:\Users\katei\source\repos\sql-homework\10-Exam\Equipment.txt'
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
FROM 'C:\Users\katei\source\repos\sql-homework\10-Exam\Countries.txt'
WITH 
( 
    ROWTERMINATOR = '\n'
)

SELECT * FROM  #ImportCountries

INSERT INTO Countries([Name])
SELECT #ImportCountries.[Name]
FROM #ImportCountries
GO

DROP TABLE #ImportCountries
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE TABLE #ImportTrainers
(	
	CountryFk int,
	CountryFkChamp int,
    [Name] NVARCHAR(100)
)
GO
BULK INSERT #ImportTrainers
FROM 'C:\Users\katei\source\repos\sql-homework\10-Exam\Trainers.txt'
WITH 
( 	
	FIELDTERMINATOR = '|',
    ROWTERMINATOR = '\n'
)

SELECT * FROM  #ImportTrainers

INSERT INTO Trainers([Name], CountryFk, CountryChampFk)
SELECT #ImportTrainers.[Name], #ImportTrainers.CountryFk, #ImportTrainers.CountryFkChamp
FROM #ImportTrainers
GO

DROP TABLE #ImportCountries
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE TABLE #ImportCities
(
    [Name] NVARCHAR(100),
	CountryFk int
)
GO
BULK INSERT #ImportCities
FROM 'C:\Users\katei\source\repos\sql-homework\10-Exam\Cities.txt'
WITH 
( 
	FIELDTERMINATOR = '|',
    ROWTERMINATOR = '\n'
)

SELECT * FROM  #ImportCities

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
FROM 'C:\Users\katei\source\repos\sql-homework\10-Exam\Stadiums.txt'
WITH 
( 
	FIELDTERMINATOR = '|',
    ROWTERMINATOR = '\n'
)

SELECT * FROM  #ImportStadiums

INSERT INTO Stadiums([Name], CityFk, Capacity)
SELECT #ImportStadiums.[Name], #ImportStadiums.CityFk, #ImportStadiums.Capacity
FROM #ImportStadiums
GO

DROP TABLE #ImportStadiums
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE TABLE #ImportCommands
(
	CountryFk int,
    TrainerFk VARCHAR(max),
	EquipmentFk int
)
GO
BULK INSERT #ImportCommands
FROM 'C:\Users\katei\source\repos\sql-homework\10-Exam\Commands.txt'
WITH 
( 
	FIELDTERMINATOR = '|',
    ROWTERMINATOR = '\n'
)

INSERT INTO Commands(CountryFk, TrainerFk, EquipmentFk)
SELECT #ImportCommands.CountryFk, #ImportCommands.TrainerFk, #ImportCommands.EquipmentFk
FROM #ImportCommands
GO

DROP TABLE #ImportCommands
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE TABLE #ImportPlayers
(
	 [Name] NVARCHAR(100),
	 PositionFk int,
	 CommandFk int
)
GO
BULK INSERT #ImportPlayers
FROM 'C:\Users\katei\source\repos\sql-homework\10-Exam\Players.txt'
WITH 
( 
	FIELDTERMINATOR = '|',
    ROWTERMINATOR = '\n'
)

INSERT INTO Players([Name], PositionFk, CommandFk)
SELECT #ImportPlayers.[Name],  #ImportPlayers.PositionFk, #ImportPlayers.CommandFk
FROM #ImportPlayers
GO

DROP TABLE #ImportPlayers
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE TABLE #ImportAssociations
(
	 [Name] NVARCHAR(100)
)
GO
BULK INSERT #ImportAssociations
FROM 'C:\Users\katei\source\repos\sql-homework\10-Exam\Associations.txt'
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
	 CountryFk int,
	 [Name] NVARCHAR(100),
	 AssociationFk int
)
GO
BULK INSERT #ImportJudges
FROM 'C:\Users\katei\source\repos\sql-homework\10-Exam\Judges.txt'
WITH 
( 
	FIELDTERMINATOR = '|',
    ROWTERMINATOR = '\n'
)

SELECT * FROM #ImportJudges

INSERT INTO Judges([Name], AssociationFk, CountryFk)
SELECT #ImportJudges.[Name],  #ImportJudges.AssociationFk, #ImportJudges.CountryFk
FROM #ImportJudges
GO

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
FROM 'C:\Users\katei\source\repos\sql-homework\10-Exam\GroupTime.txt'
WITH 
( 
	FIELDTERMINATOR = '|',
    ROWTERMINATOR = '\n'
)

SELECT * FROM #ImportDates

INSERT INTO Dates(Schedule)
SELECT #ImportDates.Schedule
FROM #ImportDates
GO

DROP TABLE #ImportDates
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE PROCEDURE GetRandIdCommand
@id INT OUTPUT
AS
BEGIN
	IF (SELECT count(Groups.Id) FROM Groups) > 0
	BEGIN
		SET @id = (SELECT TOP 1 Commands.Id
				   FROM Commands
				   WHERE Commands.Id NOT IN (SELECT Commands.Id
						      				 FROM Commands, Groups
											 WHERE Groups.CommandFk1 = Commands.Id OR Groups.CommandFk2 = Commands.Id OR Groups.CommandFk3 = Commands.Id OR Groups.CommandFk4 = Commands.Id)
				   ORDER BY NEWID());
	END
	ELSE
	BEGIN
		SET @id = (SELECT TOP 1 Commands.Id
				   FROM Commands
				   ORDER BY NEWID());
	END
RETURN
END
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE PROCEDURE GetRandIdJudge
@id INT OUTPUT
AS
BEGIN
	SET @id = (SELECT TOP 1 Judges.Id
			   FROM Judges
			   ORDER BY NEWID());
RETURN;
END
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE PROCEDURE GetRandIdStadium
@id INT OUTPUT
AS
BEGIN
	SET @id = (SELECT TOP 1 Stadiums.Id
			   FROM Stadiums
			   ORDER BY NEWID());
RETURN
END
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE PROCEDURE FillGroups
AS
BEGIN
	DECLARE @id INT;
	SET @id = 0;
	WHILE @id < 8
	BEGIN
		DECLARE @CommandFk1 INT;
		EXECUTE GetRandIdCommand @CommandFk1 OUTPUT;

		DECLARE @CommandFk2 INT;
		EXECUTE GetRandIdCommand @CommandFk2 OUTPUT;

		DECLARE @CommandFk3 INT;
		EXECUTE GetRandIdCommand @CommandFk3 OUTPUT;

		DECLARE @CommandFk4 INT;
		EXECUTE GetRandIdCommand @CommandFk4 OUTPUT;

		WHILE @CommandFk2 = @CommandFk1
		BEGIN
			EXECUTE GetRandIdCommand @CommandFk2 OUTPUT;
		END

		WHILE @CommandFk3 = @CommandFk1 OR @CommandFk3 = @CommandFk2
		BEGIN
			EXECUTE GetRandIdCommand @CommandFk3 OUTPUT;
		END

		WHILE @CommandFk4 = @CommandFk1 OR @CommandFk4 = @CommandFk2 OR @CommandFk4 = @CommandFk3
		BEGIN
			EXECUTE GetRandIdCommand @CommandFk4 OUTPUT;
		END

		INSERT INTO Groups(CommandFk1, CommandFk2, CommandFk3, CommandFk4)
		VALUES(@CommandFk1, @CommandFk2, @CommandFk3, @CommandFk4);

	SET @id+=1;
	END
END
GO

EXECUTE FillGroups;
DROP PROCEDURE FillGroups;
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE PROCEDURE FillMatches
AS
BEGIN

END
GO












--CREATE PROCEDURE Replay
--AS
--BEGIN
--	DECLARE @id INT;
--	SET @id = 0;
--	WHILE @id < 16
--	BEGIN
--		DECLARE @CommandFk1 INT;
--		EXECUTE GetRandIdCommand @CommandFk1 OUTPUT;

--		DECLARE @CommandFk2 INT;
--		EXECUTE GetRandIdCommand @CommandFk2 OUTPUT;

--		WHILE @CommandFk2 = @CommandFk1
--		BEGIN
--			EXECUTE GetRandIdCommand @CommandFk2 OUTPUT;
--		END

--		DECLARE @JudgeFk INT;
--		EXECUTE GetRandIdJudge @JudgeFk OUTPUT;

--		DECLARE @StadiumFk INT;
--		EXECUTE GetRandIdStadium @StadiumFk OUTPUT;

--		INSERT INTO Matches (Schedule, CommandFk1, CommandFk2, JudgeFk, StadiumFk)
--		VALUES ('2020-04-15', @CommandFk1, @CommandFk2, @JudgeFk, @StadiumFk);

--		SET @id += 1;
--	END
--END
--DROP PROCEDURE Replay

--EXECUTE Replay;