USE FootballChampionship
GO

--1. Общее количество голов, забитых на протяжении чемпионата 
------------------------------------------------------------------------------------------
SELECT (balls.MaxId - balls.MinId)
FROM (SELECT TOP 1 Topscorers.Id As MinId, MaxId
	  FROM (SELECT Max(TopScorers.Id) AS MaxId
		    FROM TopScorers) b, TopScorers) balls
------------------------------------------------------------------------------------------



--2. Среднее количество голов в каждом матче 
------------------------------------------------------------------------------------------
SELECT AVG(ct.cnt)
FROM TopScorers, 
(SELECT COUNT(TopScorers.PlayerFk) AS cnt FROM TopScorers GROUP BY MatchFk, Match1s8Fk, Match1s4Fk, Match1s2Fk, MatchFinalFk) ct 
------------------------------------------------------------------------------------------



--3.Наибольшее и наименьшее количество мячей, забитых командами (2 команды) 
------------------------------------------------------------------------------------------
SELECT TOP 1 GoalsCount AS maxGC, CommandFk AS maxCFk, t.minGC, t.minCFk
FROM Goals, (SELECT TOP 1 GoalsCount AS minGC, CommandFk AS minCFk
			FROM Goals
			ORDER BY GoalsCount ASC) t
ORDER BY GoalsCount DESC
------------------------------------------------------------------------------------------



--4. Наибольшее и наименьшее количество мячей, пропущенных командами (2 команды) 
-------------------------------------------------------------------------------------------
SELECT TOP 1 GoalsCount AS maxGC, CommandFk AS maxCFk, t.minGC, t.minCFk
FROM GoalsScored, (SELECT TOP 1 GoalsCount AS minGC, CommandFk AS minCFk
			FROM GoalsScored
			ORDER BY GoalsCount ASC) t
ORDER BY GoalsCount DESC
-------------------------------------------------------------------------------------------



--9. Лучшие бомбардиры (игроки, забившие наибольшее количество голов) 
-------------------------------------------------------------------------------------------
SELECT t2.pFk AS 'Top players'
FROM (SELECT COUNT(TopScorers.PlayerFk) AS cnt, PlayerFk AS pFk  FROM TopScorers GROUP BY PlayerFk) t2
WHERE t2.cnt = 
			(SELECT MAX(t1.cnt) 
			 FROM(SELECT COUNT(PlayerFk) AS cnt, PlayerFk  
				  FROM TopScorers 
				  GROUP BY PlayerFk) t1)
-------------------------------------------------------------------------------------------



--10. Список команд, занявших призовые места 
------------------------------------------------------------------------------------------
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

