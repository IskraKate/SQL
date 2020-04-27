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
FROM 'C:\Users\katei\source\repos\sql-homework\10-Exam\TextFiles\Equipment.txt'
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
FROM 'C:\Users\katei\source\repos\sql-homework\10-Exam\TextFiles\Trainers.txt'
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
FROM 'C:\Users\katei\source\repos\sql-homework\10-Exam\TextFiles\Stadiums.txt'
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
FROM 'C:\Users\katei\source\repos\sql-homework\10-Exam\TextFiles\Commands.txt'
WITH 
( 
	FIELDTERMINATOR = '|',
    ROWTERMINATOR = '\n'
)

INSERT INTO Commands(CountryFk, TrainerFk, EquipmentFk)
SELECT #ImportCommands.CountryFk, #ImportCommands.TrainerFk, #ImportCommands.EquipmentFk
FROM #ImportCommands
GO

INSERT INTO Points(CommandFk, PointsSum)
SELECT Commands.Id, 0
FROM Commands
GO

DROP TABLE #ImportCommands
GO
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
FROM 'C:\Users\katei\source\repos\sql-homework\10-Exam\TextFiles\Players.txt'
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
	 CountryFk int,
	 [Name] NVARCHAR(100),
	 AssociationFk int
)
GO
BULK INSERT #ImportJudges
FROM 'C:\Users\katei\source\repos\sql-homework\10-Exam\TextFiles\Judges.txt'
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








