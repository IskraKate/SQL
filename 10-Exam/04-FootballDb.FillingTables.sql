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
------------------------------------------------------------------------------------------


