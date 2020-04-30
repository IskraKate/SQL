USE FootballChampionship
GO

--0. Вывод чемпионата в удобном формате
------------------------------------------------------------------------------------------
CREATE PROCEDURE CreateTempTables
AS 
BEGIN
CREATE TABLE tempOne
(
  Id INT PRIMARY KEY IDENTITY,
  [Name] VARCHAR(100)
)

CREATE TABLE tempTwo
(
  Id INT PRIMARY KEY IDENTITY,
  [Name] VARCHAR(100)
)

END
GO

CREATE PROCEDURE DropTempTables
AS
BEGIN
DROP TABLE tempOne
DROP TABLE tempTwo
END
GO
-------------------------------------------------------------------------------------------



--Groups Create
-------------------------------------------------------------------------------------------
CREATE PROCEDURE ShowAllMatchesOfGroup
AS
BEGIN

INSERT INTO tempOne([Name])
(SELECT Countries.[Name] AS 'Command One'
FROM MatchesGroup, Countries, Commands
WHERE Countries.Id = Commands.CountryFk AND Commands.Id = MatchesGroup.CommandFk1)

INSERT INTO tempTwo([Name])
(SELECT Countries.[Name] AS 'Command Two'
FROM MatchesGroup, Countries, Commands
WHERE Countries.Id = Commands.CountryFk AND Commands.Id = MatchesGroup.CommandFk2) 

SELECT MatchesGroup.Schedule , tempOne.[Name] AS 'Command One', tempTwo.[Name] AS 'Command Two', Judges.[Name] AS 'Judge',
Stadiums.[Name] AS 'Stadium', Stadiums.Capacity, MatchesGroup.PeopleOnTheStadium AS 'People on the stadium'
FROM tempOne, tempTwo, MatchesGroup, Judges, Stadiums
WHERE tempTwo.Id = tempOne.Id AND MatchesGroup.Id = tempOne.ID AND MatchesGroup.JudgeFk  = Judges.Id AND MatchesGroup.StadiumFk = Stadiums.Id

EXECUTE DeleteFromTempTables;

END
GO

CREATE PROCEDURE ShowResultsOfGroup
AS
BEGIN

INSERT INTO tempOne([Name])
(SELECT Countries.[Name] AS 'Winner'
FROM MatchGroupResults, Countries, Commands
WHERE Countries.Id = Commands.CountryFk AND Commands.Id = MatchGroupResults.WinnerFk)

INSERT INTO tempTwo([Name])
(SELECT Countries.[Name] AS 'Looser'
FROM MatchGroupResults, Countries, Commands
WHERE Countries.Id = Commands.CountryFk AND Commands.Id = MatchGroupResults.LooserFk) 

SELECT tempOne.[Name] AS 'Winner', tempTwo.[Name] AS 'Looser', Result
FROM tempOne, tempTwo, MatchGroupResults
WHERE tempOne.Id = tempTwo.Id AND MatchGroupResults.Id = tempOne.Id

EXECUTE DeleteFromTempTables;

END 
GO
-------------------------------------------------------------------------------------------



--1/8 Create
-------------------------------------------------------------------------------------------
CREATE PROCEDURE ShowAllMatchesOf1s8
AS
BEGIN

INSERT INTO tempOne([Name])
(SELECT Countries.[Name] AS 'Command One'
FROM Matches1s8, Countries, Commands
WHERE Countries.Id = Commands.CountryFk AND Commands.Id = Matches1s8.CommandFk1)

INSERT INTO tempTwo([Name])
(SELECT Countries.[Name] AS 'Command Two'
FROM Matches1s8, Countries, Commands
WHERE Countries.Id = Commands.CountryFk AND Commands.Id = Matches1s8.CommandFk2) 

SELECT Matches1s8.Schedule , tempOne.[Name] AS 'Command One', tempTwo.[Name] AS 'Command Two', Judges.[Name] AS 'Judge',
Stadiums.[Name] AS 'Stadium', Stadiums.Capacity, Matches1s8.PeopleOnTheStadium AS 'People on the stadium'
FROM tempOne, tempTwo, Matches1s8, Judges, Stadiums
WHERE tempTwo.Id = tempOne.Id AND Matches1s8.Id = tempOne.ID AND Matches1s8.JudgeFk  = Judges.Id AND Matches1s8.StadiumFk = Stadiums.Id

END 
GO

CREATE PROCEDURE ShowResultsOf1s8
AS
BEGIN 
INSERT INTO tempOne([Name])
(SELECT Countries.[Name] AS 'Winner'
FROM Match1s8Results, Countries, Commands
WHERE Countries.Id = Commands.CountryFk AND Commands.Id = Match1s8Results.WinnerFk)

INSERT INTO tempTwo([Name])
(SELECT Countries.[Name] AS 'Looser'
FROM Match1s8Results, Countries, Commands
WHERE Countries.Id = Commands.CountryFk AND Commands.Id = Match1s8Results.LooserFk) 

SELECT tempOne.[Name] AS 'Winner', tempTwo.[Name] AS 'Looser', Result
FROM tempOne, tempTwo, Match1s8Results
WHERE tempOne.Id = tempTwo.Id AND Match1s8Results.Id = tempOne.ID 
END
GO
-------------------------------------------------------------------------------------------



--1/4 Create
-------------------------------------------------------------------------------------------
CREATE PROCEDURE ShowAllMatchesOf1s4
AS
BEGIN
INSERT INTO tempOne([Name])
(SELECT Countries.[Name] AS 'Command One'
FROM Matches1s4, Countries, Commands
WHERE Countries.Id = Commands.CountryFk AND Commands.Id = Matches1s4.CommandFk1)

INSERT INTO tempTwo([Name])
(SELECT Countries.[Name] AS 'Command Two'
FROM Matches1s4, Countries, Commands
WHERE Countries.Id = Commands.CountryFk AND Commands.Id = Matches1s4.CommandFk2) 

SELECT Matches1s4.Schedule , tempOne.[Name] AS 'Command One', tempTwo.[Name] AS 'Command Two', Judges.[Name] AS 'Judge',
Stadiums.[Name] AS 'Stadium', Stadiums.Capacity, Matches1s4.PeopleOnTheStadium AS 'People on the stadium'
FROM tempOne, tempTwo, Matches1s4, Judges, Stadiums
WHERE tempTwo.Id = tempOne.Id AND Matches1s4.Id = tempOne.ID AND Matches1s4.JudgeFk  = Judges.Id AND Matches1s4.StadiumFk = Stadiums.Id
END
GO

CREATE PROCEDURE ShowResultsOf1s4
AS
BEGIN 
INSERT INTO tempOne([Name])
(SELECT Countries.[Name] AS 'Winner'
FROM Match1s4Results, Countries, Commands
WHERE Countries.Id = Commands.CountryFk AND Commands.Id = Match1s4Results.WinnerFk)

INSERT INTO tempTwo([Name])
(SELECT Countries.[Name] AS 'Looser'
FROM Match1s4Results, Countries, Commands
WHERE Countries.Id = Commands.CountryFk AND Commands.Id = Match1s4Results.LooserFk) 

SELECT tempOne.[Name] AS 'Winner', tempTwo.[Name] AS 'Looser', Result
FROM tempOne, tempTwo, Match1s4Results
WHERE tempOne.Id = tempTwo.Id AND Match1s4Results.Id = tempOne.ID 
END
GO
-------------------------------------------------------------------------------------------



--1/2 Create
-------------------------------------------------------------------------------------------
CREATE PROCEDURE ShowAllMatchesOf1s2
AS
BEGIN
INSERT INTO tempOne([Name])
(SELECT Countries.[Name] AS 'Command One'
FROM Matches1s2, Countries, Commands
WHERE Countries.Id = Commands.CountryFk AND Commands.Id = Matches1s2.CommandFk1)

INSERT INTO tempTwo([Name])
(SELECT Countries.[Name] AS 'Command Two'
FROM Matches1s2, Countries, Commands
WHERE Countries.Id = Commands.CountryFk AND Commands.Id = Matches1s2.CommandFk2) 

SELECT Matches1s2.Schedule , tempOne.[Name] AS 'Command One', tempTwo.[Name] AS 'Command Two', Judges.[Name] AS 'Judge',
Stadiums.[Name] AS 'Stadium', Stadiums.Capacity, Matches1s2.PeopleOnTheStadium AS 'People on the stadium'
FROM tempOne, tempTwo, Matches1s2, Judges, Stadiums
WHERE tempTwo.Id = tempOne.Id AND Matches1s2.Id = tempOne.ID AND Matches1s2.JudgeFk  = Judges.Id AND Matches1s2.StadiumFk = Stadiums.Id
END
GO

CREATE PROCEDURE ShowResultsOf1s2
AS
BEGIN 
INSERT INTO tempOne([Name])
(SELECT Countries.[Name] AS 'Winner'
FROM Match1s2Results, Countries, Commands
WHERE Countries.Id = Commands.CountryFk AND Commands.Id = Match1s2Results.WinnerFk)

INSERT INTO tempTwo([Name])
(SELECT Countries.[Name] AS 'Looser'
FROM Match1s2Results, Countries, Commands
WHERE Countries.Id = Commands.CountryFk AND Commands.Id = Match1s2Results.LooserFk) 

SELECT tempOne.[Name] AS 'Winner', tempTwo.[Name] AS 'Looser', Result
FROM tempOne, tempTwo, Match1s2Results
WHERE tempOne.Id = tempTwo.Id AND Match1s2Results.Id = tempOne.ID 
END
GO
-------------------------------------------------------------------------------------------



--Final Create
-------------------------------------------------------------------------------------------
CREATE PROCEDURE ShowAllMatchesOfFinal
AS
BEGIN

INSERT INTO tempOne([Name])
(SELECT Countries.[Name] AS 'Command One'
FROM MatchesFinal, Countries, Commands
WHERE Countries.Id = Commands.CountryFk AND Commands.Id = MatchesFinal.CommandFk1)

INSERT INTO tempTwo([Name])
(SELECT Countries.[Name] AS 'Command Two'
FROM MatchesFinal, Countries, Commands
WHERE Countries.Id = Commands.CountryFk AND Commands.Id = MatchesFinal.CommandFk2) 

SELECT MatchesFinal.Schedule , tempOne.[Name] AS 'Command One', tempTwo.[Name] AS 'Command Two', Judges.[Name] AS 'Judge',
Stadiums.[Name] AS 'Stadium', Stadiums.Capacity, MatchesFinal.PeopleOnTheStadium AS 'People on the stadium'
FROM tempOne, tempTwo, MatchesFinal, Judges, Stadiums
WHERE tempTwo.Id = tempOne.Id AND MatchesFinal.Id = tempOne.ID AND MatchesFinal.JudgeFk  = Judges.Id AND MatchesFinal.StadiumFk = Stadiums.Id
END
GO

CREATE PROCEDURE ShowWinners
AS
BEGIN

SELECT t1.[First Place], t2.[Second Place], t3.[Third Place]
FROM
(SELECT Countries.[Name] AS [First Place]
FROM Winners, Commands, Countries
WHERE (Commands.Id = Winners.FirstPlaceFk AND Commands.CountryFk = Countries.Id)) t1,

(SELECT Countries.[Name] AS [Second Place]
FROM Winners, Commands, Countries
WHERE (Commands.Id = Winners.SecondPlaceFk AND Commands.CountryFk = Countries.Id)) t2,

(SELECT Countries.[Name] AS [Third Place]
FROM Winners, Commands, Countries
WHERE (Commands.Id = Winners.ThirdPlaceFk AND Commands.CountryFk = Countries.Id)) t3

END
GO
-------------------------------------------------------------------------------------------
