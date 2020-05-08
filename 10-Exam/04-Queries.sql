USE FootballChampionship
GO

--1. ����� ���������� �����, ������� �� ���������� ���������� 
------------------------------------------------------------------------------------------
SELECT (balls.MaxId - balls.MinId) AS 'All Goals'
FROM (SELECT TOP 1 Topscorers.Id As MinId, MaxId
	  FROM (SELECT Max(TopScorers.Id) AS MaxId
		    FROM TopScorers) b, TopScorers) balls
------------------------------------------------------------------------------------------



--2. ������� ���������� ����� � ������ ����� 
------------------------------------------------------------------------------------------
SELECT AVG(ct.cnt) AS 'Average goals in match'
FROM TopScorers, 
(SELECT COUNT(TopScorers.PlayerFk) AS cnt FROM TopScorers GROUP BY MatchFk, Match1s8Fk, Match1s4Fk, Match1s2Fk, MatchFinalFk) ct 
------------------------------------------------------------------------------------------



--3.���������� � ���������� ���������� �����, ������� ��������� (2 �������) 
------------------------------------------------------------------------------------------
SELECT Countries.[Name] AS 'Name Of Country', Goals.maxGC AS 'Min/Max Goals'
FROM 
	(SELECT TOP 1 GoalsCount AS maxGC, CommandFk AS maxCFk, t.minGC, t.minCFk
	 FROM Goals, 
			(SELECT TOP 1 GoalsCount AS minGC, CommandFk AS minCFk
			FROM Goals
			ORDER BY GoalsCount ASC) t
	 ORDER BY GoalsCount DESC) Goals, Countries, Commands
WHERE Countries.Id = Commands.CountryFk AND ( Commands.Id = Goals.maxCFk)
UNION SELECT Countries.[Name], Goals.minGc
FROM 
	(SELECT TOP 1 GoalsCount AS maxGC, CommandFk AS maxCFk, t.minGC, t.minCFk
	 FROM Goals, 
			(SELECT TOP 1 GoalsCount AS minGC, CommandFk AS minCFk
			FROM Goals
			ORDER BY GoalsCount ASC) t
	 ORDER BY GoalsCount DESC) Goals, Countries, Commands
WHERE Countries.Id = Commands.CountryFk AND ( Commands.Id = Goals.minCFk)
------------------------------------------------------------------------------------------



--4. ���������� � ���������� ���������� �����, ����������� ��������� (2 �������) 
-------------------------------------------------------------------------------------------
SELECT Countries.[Name] AS 'Name Of Country', Goals.maxGC AS 'Min/Max Goals'
FROM 
	(SELECT TOP 1 GoalsCount AS maxGC, CommandFk AS maxCFk, t.minGC, t.minCFk
	 FROM Goals, 
			(SELECT TOP 1 GoalsCount AS minGC, CommandFk AS minCFk
			FROM GoalsScored
			ORDER BY GoalsCount ASC) t
	 ORDER BY GoalsCount DESC) Goals, Countries, Commands
WHERE Countries.Id = Commands.CountryFk AND ( Commands.Id = Goals.maxCFk)
UNION SELECT Countries.[Name], Goals.minGc
FROM 
	(SELECT TOP 1 GoalsCount AS maxGC, CommandFk AS maxCFk, t.minGC, t.minCFk
	 FROM Goals, 
			(SELECT TOP 1 GoalsCount AS minGC, CommandFk AS minCFk
			FROM GoalsScored
			ORDER BY GoalsCount ASC) t
	 ORDER BY GoalsCount DESC) Goals, Countries, Commands
WHERE Countries.Id = Commands.CountryFk AND ( Commands.Id = Goals.minCFk)
-------------------------------------------------------------------------------------------



--5.  ��������� ������������ ���� ������ 
-------------------------------------------------------------------------------------------
SELECT SUM(MatchesGroup.PeopleOnTheStadium) + SUM(Matches1s8.PeopleOnTheStadium) + 
	   SUM(Matches1s4.PeopleOnTheStadium) + SUM(Matches1s2.PeopleOnTheStadium) +
	   SUM(MatchesFinal.PeopleOnTheStadium) AS 'Summary People On the Stadiums All Matches'
FROM MatchesGroup, Matches1s8, Matches1s4, Matches1s2, MatchesFinal
-------------------------------------------------------------------------------------------



--6. ������� ������������ ������ ����� 
-------------------------------------------------------------------------------------------
SELECT AVG(MatchesGroup.PeopleOnTheStadium) + AVG(Matches1s8.PeopleOnTheStadium) + 
	   AVG(Matches1s4.PeopleOnTheStadium) + AVG(Matches1s2.PeopleOnTheStadium) +
       AVG(MatchesFinal.PeopleOnTheStadium) AS 'Average People On the Stadiums All Matches'
FROM MatchesGroup, Matches1s8, Matches1s4, Matches1s2, MatchesFinal
-------------------------------------------------------------------------------------------



--7. ���������� � ���������� ����� ����� (2 ������������ �������) 
-------------------------------------------------------------------------------------------
SELECT Countries.[Name] AS 'Country', MAX(MatchWinLoses.Wins) AS 'Max Loses'
FROM MatchWinLoses, Commands, Countries
WHERE CommandFk = Commands.Id AND Commands.CountryFk = Countries.Id AND
MatchWinLoses.Wins = 
			(SELECT MAX(MatchWinLoses.Wins) 
			FROM MatchWinLoses)
GROUP BY CommandFk, Countries.[Name]

SELECT Countries.[Name] AS 'Country', MIN(MatchWinLoses.Wins) AS 'Min Wins'
FROM MatchWinLoses, Commands, Countries
WHERE CommandFk = Commands.Id AND Commands.CountryFk = Countries.Id AND
MatchWinLoses.Wins = 
			(SELECT MIN(MatchWinLoses.Wins) 
			FROM MatchWinLoses)
GROUP BY CommandFk, Countries.[Name]
-------------------------------------------------------------------------------------------



--8. ���������� � ���������� ���������� ��������� (2 �������) 
-------------------------------------------------------------------------------------------
SELECT Countries.[Name] AS 'Country', MAX(MatchWinLoses.Loses) AS 'Max Loses'
FROM MatchWinLoses, Commands, Countries
WHERE CommandFk = Commands.Id AND Commands.CountryFk = Countries.Id AND
MatchWinLoses.Loses = 
			(SELECT MAX(MatchWinLoses.Loses)
			FROM MatchWinLoses)
GROUP BY CommandFk, Countries.[Name]

SELECT Countries.[Name] AS 'Country', MIN(MatchWinLoses.Loses) AS 'Min Loses'
FROM MatchWinLoses, Commands, Countries
WHERE CommandFk = Commands.Id AND Commands.CountryFk = Countries.Id AND
MatchWinLoses.Loses = 
			(SELECT MIN(MatchWinLoses.Loses)
			FROM MatchWinLoses)
GROUP BY CommandFk, Countries.[Name]
-------------------------------------------------------------------------------------------



--9. ������ ���������� (������, �������� ���������� ���������� �����) 
-------------------------------------------------------------------------------------------
SELECT Players.[Name] AS 'Top Scorers' , t.[Max Goals]
FROM Players, (SELECT MAX(t1.cnt) AS 'Max Goals'
			   FROM(SELECT COUNT(PlayerFk) AS cnt, PlayerFk  
					FROM TopScorers 
					GROUP BY PlayerFk) t1)t
WHERE Players.Id IN
					(SELECT TopScorers.PlayerFk
					 FROM TopScorers
					 GROUP BY PlayerFk
					 HAVING COUNT(TopScorers.PlayerFk) = (SELECT MAX(t1.cnt) 
														  FROM(SELECT COUNT(PlayerFk) AS cnt, PlayerFk  
															   FROM TopScorers 
									                           GROUP BY PlayerFk) t1)) 
-------------------------------------------------------------------------------------------



--10. ������ ������, �������� �������� ����� 
-------------------------------------------------------------------------------------------
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
-------------------------------------------------------------------------------------------


