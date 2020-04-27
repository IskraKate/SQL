USE FootballChampionship
GO

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
		DECLARE @commandFk1 INT;
		EXECUTE GetRandIdCommand @CommandFk1 OUTPUT;

		DECLARE @commandFk2 INT;
		EXECUTE GetRandIdCommand @CommandFk2 OUTPUT;

		DECLARE @commandFk3 INT;
		EXECUTE GetRandIdCommand @CommandFk3 OUTPUT;

		DECLARE @commandFk4 INT;
		EXECUTE GetRandIdCommand @CommandFk4 OUTPUT;

		WHILE @commandFk2 = @commandFk1
		BEGIN
			EXECUTE GetRandIdCommand @commandFk2 OUTPUT;
		END

		WHILE @commandFk3 = @commandFk1 OR @commandFk3 = @commandFk2
		BEGIN
			EXECUTE GetRandIdCommand @commandFk3 OUTPUT;
		END

		WHILE @commandFk4 = @commandFk1 OR @commandFk4 = @commandFk2 OR @commandFk4 = @commandFk3
		BEGIN
			EXECUTE GetRandIdCommand @commandFk4 OUTPUT;
		END

		INSERT INTO Groups(CommandFk1, CommandFk2, CommandFk3, CommandFk4)
		VALUES(@commandFk1, @commandFk2, @commandFk3, @commandFk4);

		DECLARE @groupId INT;

		SET  @groupId = (SELECT Groups.Id
						FROM Groups
						WHERE CommandFk1 = @commandFk1 AND CommandFk2 = @commandFk2 AND CommandFk3 = @commandFk3 AND CommandFk4 = @commandFk4)

		UPDATE Points 
		SET GroupFk = @groupId
		WHERE CommandFk = @commandFk1 

		UPDATE Points 
		SET GroupFk = @groupId
		WHERE CommandFk = @commandFk2

		UPDATE Points 
		SET GroupFk = @groupId
		WHERE CommandFk = @commandFk3

		UPDATE Points 
		SET GroupFk = @groupId
		WHERE CommandFk = @commandFk4

	SET @id+=1;
	END
END
GO

EXECUTE FillGroups; 
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE FUNCTION GetTime(@id INT)
RETURNS DATETIME 
AS
BEGIN
DECLARE @dateTimeMatch DATETIME;

SELECT @dateTimeMatch = DatesOfGroup.schedule
FROM DatesOfGroup
WHERE DatesOfGroup.Id = @id

RETURN @dateTimeMatch
END
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE PROCEDURE FillGroupMatches
AS
BEGIN
	DECLARE @id INT;
	DECLARE @groupId INT;
	SET @id = (SELECT TOP 1 DatesOfGroup.Id FROM DatesOfGroup);
	SET @groupId = (SELECT TOP 1 Groups.Id FROM Groups);
	WHILE @id < ((SELECT COUNT(DatesOfGroup.Id) FROM DatesOfGroup) + 1)
	BEGIN

	DECLARE @schedule DATETIME;
	SET @schedule = dbo.GetTime(@id);
	
	DECLARE @commandFk1 INT;
	SELECT @commandFk1 = Groups.CommandFk1 FROM Groups WHERE Groups.Id = @groupId;

	DECLARE @commandFk2 INT;
	SELECT @commandFk2 = Groups.CommandFk2 FROM Groups WHERE Groups.Id = @groupId;

	DECLARE @commandFk3 INT;
	SELECT @commandFk3 = Groups.CommandFk3 FROM Groups WHERE Groups.Id = @groupId;

	DECLARE @commandFk4 INT;
	SELECT @commandFk4 = Groups.CommandFk4 FROM Groups WHERE Groups.Id = @groupId;

	DECLARE @judgeFk INT;
	EXECUTE GetRandIdJudge @judgeFk OUTPUT;

	DECLARE @stadiumFk INT;
	EXECUTE GetRandIdStadium @stadiumFk OUTPUT;

	DECLARE @matchType NVARCHAR(10);
	SET @matchType = 'Group';

	IF((@id - 1)%6 = 0)
	INSERT INTO Matches(Schedule, CommandFk1, CommandFk2, JudgeFk, StadiumFk, MatchType)
	VALUES (@schedule, @commandFk1, @commandFk2, @judgeFk, @stadiumFk, @matchType)

	IF((@id - 2)%6 = 0)
	INSERT INTO Matches(Schedule, CommandFk1, CommandFk2, JudgeFk, StadiumFk, MatchType)
	VALUES (@schedule, @commandFk1, @commandFk3, @judgeFk, @stadiumFk, @matchType)

	IF((@id - 3)%6 = 0)
	INSERT INTO Matches(Schedule, CommandFk1, CommandFk2, JudgeFk, StadiumFk, MatchType)
	VALUES (@schedule, @commandFk1, @commandFk4, @judgeFk, @stadiumFk, @matchType)

	IF((@id - 4)%6 = 0)
	INSERT INTO Matches(Schedule, CommandFk1, CommandFk2, JudgeFk, StadiumFk, MatchType)
	VALUES (@schedule, @commandFk2, @commandFk3, @judgeFk, @stadiumFk, @matchType)

	IF((@id - 5)%6 = 0)
	INSERT INTO Matches(Schedule, CommandFk1, CommandFk2, JudgeFk, StadiumFk, MatchType)
	VALUES (@schedule, @commandFk2, @commandFk4, @judgeFk, @stadiumFk, @matchType)

	IF(@id%6=0)
	INSERT INTO Matches(Schedule, CommandFk1, CommandFk2, JudgeFk, StadiumFk, MatchType)
	VALUES (@schedule, @commandFk3, @commandFk4, @judgeFk, @stadiumFk, @matchType)

		
	SET @id+=1;	

    IF((@id - 1)%6 = 0)
    SET @groupId +=1;

	END
END
GO

EXECUTE FillGroupMatches;
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE PROCEDURE TopScorersFill(@matchId INT, @commandFk INT, @goals INT, @matchType NVARCHAR(10))
AS
BEGIN
DECLARE @index INT;
DECLARE @player INT;
DECLARE @m INT;
DECLARE @s INT;
DECLARE @minutes NVARCHAR(2);
DECLARE @seconds NVARCHAR(2);
DECLARE @timeString NVARCHAR(8);

SET @index = @goals;
	WHILE(@index>0)
	BEGIN

	SET @timeString = ('');
	SET @minutes = '';
	SET @seconds = '';

	SET @player = (SELECT TOP 1 Players.Id
				   FROM Players
				   WHERE Players.CommandFk = @commandFk
				   ORDER BY NEWID())
    
	SET @m = (SELECT FLOOR(RAND()*(90-1)+1));

	IF(@m < 10)
	BEGIN
	SET @minutes += '0';
	END

	SET @minutes += (SELECT CAST((@m) AS NVARCHAR(2)));
	
	SET @s = (SELECT FLOOR(RAND()*59))

	IF(@s<10)
	BEGIN 
	SET @seconds += '0';
	END

	SET @seconds += (SELECT CAST(@s AS NVARCHAR(2)));

	SET @timeString += @minutes + ':' + @seconds;
	
	IF(@matchType = '1/8')
	BEGIN 
	INSERT INTO TopScorers(TimeOfGoal, PlayerFk, Match1s8Fk, MatchType)
	VALUES (@timeString, @player, @matchId, @matchType)
	END

	IF(@matchType = '1/4')
	BEGIN
	INSERT INTO TopScorers(TimeOfGoal, PlayerFk, Match1s4Fk, MatchType)
	VALUES (@timeString, @player, @matchId, @matchType)
	END

	IF(@matchType = '1/2')
	BEGIN
	INSERT INTO TopScorers(TimeOfGoal, PlayerFk, Match1s2Fk, MatchType)
	VALUES (@timeString, @player, @matchId, @matchType)
	END

	IF(@matchType = 'Final')
	BEGIN
	INSERT INTO TopScorers(TimeOfGoal, PlayerFk, MatchFinalFk, MatchType)
	VALUES (@timeString, @player, @matchId, @matchType)
	END

	IF(@matchType = 'Group')
	BEGIN
	INSERT INTO TopScorers(TimeOfGoal, PlayerFk, MatchFk, MatchType)
	VALUES (@timeString, @player, @matchId, @matchType)
	END

	SET @index -=1;
	END
END
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE PROCEDURE Play(@matchId INT, @commandFk1 INT, @commandFk2 INT, @matchType NVARCHAR(10))
AS
BEGIN

DECLARE @command1Goals INT;
DECLARE @command2Goals INT;

SET @command1Goals = (SELECT FLOOR(RAND()*5));
SET @command2Goals = (SELECT FLOOR(RAND()*5));
	
DECLARE @result NVARCHAR(5);
SET @result = '';

SET @result += CAST(@command1Goals AS NVARCHAR(2)) + ':' + CAST(@command2Goals AS NVARCHAR(2));

IF(@command1Goals > @command2Goals)
BEGIN
INSERT INTO MatchResults(Id, WinnerFk, LooserFk, Result)
VALUES(@matchId, @commandFk1, @commandFk2, @result)
END

IF(@command2Goals > @command1Goals)
BEGIN
INSERT INTO MatchResults(Id, WinnerFk, LooserFk, Result)
VALUES(@matchId, @commandFk2, @commandFk1, @result)
END

If(@command1Goals = @command2Goals)
BEGIN
INSERT INTO MatchResults(Id, Result)
VALUES(@matchId, @result)
END

EXECUTE TopScorersFill @matchId, @commandFk1, @command1Goals, @matchType;
EXECUTE TopScorersFill @matchId, @commandFk2, @command2Goals, @matchType;

END
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE PROCEDURE PlayGroupMatches
AS
BEGIN
	DECLARE @matchId INT;
	SET @matchId = (SELECT TOP 1 Matches.Id FROM Matches)
	WHILE (@matchId < ((SELECT MAX(Matches.Id) FROM Matches)+1) )
	BEGIN

	DECLARE @commandFk1 INT;
	DECLARE @commandFk2 INT;
	DECLARE @matchType NVARCHAR(10);

	SET @commandFk1 = (SELECT Matches.CommandFk1 FROM Matches WHERE Matches.Id = @matchId);
	SET @commandFk2 = (SELECT Matches.CommandFk2 FROM Matches WHERE Matches.Id = @matchId);
	SET @matchType =  (SELECT Matches.MatchType FROM Matches WHERE Matches.Id = @matchId)

	EXEC Play @matchId, @commandFk1, @commandFk2, @matchType

	SET @matchId += 1;
	END
END
GO

EXECUTE PlayGroupMatches;
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE PROCEDURE CountPoints
AS
BEGIN
DECLARE @index INT;
DECLARE @commandFk INT;
SET @index = (SELECT TOP 1 MatchResults.Id FROM MatchResults);
WHILE @index < (SELECT MAX(MatchResults.Id) FROM MatchResults)
	BEGIN
		IF((SELECT MatchResults.LooserFk FROM MatchResults WHERE MatchResults.Id = @index) IS NOT NULL)
		BEGIN
			SET @commandFk = (SELECT MatchResults.LooserFk FROM MatchResults WHERE MatchResults.Id = @index)

			UPDATE Points 
			SET PointsSum += 0
			WHERE CommandFk = @commandFk 

			SET @commandFk = (SELECT MatchResults.WinnerFk FROM MatchResults WHERE MatchResults.Id = @index)

			UPDATE Points 
			SET PointsSum += 3
			WHERE CommandFk = @commandFk 
		END
		ELSE
		BEGIN
			SET @commandFk = (SELECT Matches.CommandFk1 FROM Matches WHERE Matches.Id = @index)

			UPDATE Points 
			SET PointsSum += 1
			WHERE CommandFk = @commandFk 

			SET @commandFk = (SELECT Matches.CommandFk2 FROM Matches WHERE Matches.Id = @index)

			UPDATE Points 
			SET PointsSum += 1
			WHERE CommandFk = @commandFk 

		END
			SET @index +=1;
	END
END
GO

EXECUTE CountPoints
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
EXECUTE CheckSimilarPoints
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE FUNCTION Get1s8Time(@id INT)
RETURNS DATETIME 
AS
BEGIN
DECLARE @dateTimeMatch DATETIME;

SELECT @dateTimeMatch = DatesOf1s8.schedule
FROM DatesOf1s8
WHERE DatesOf1s8.Id = @id

RETURN @dateTimeMatch
END
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE PROCEDURE Fill1s8Matches
AS
BEGIN
DECLARE @index INT;
DECLARE @commandFk1 INT;
DECLARE @commandFk2 INT;
DECLARE @schedule DATETIME;
DECLARE @judgeFk INT;
DECLARE @stadiumFk INT;
DECLARE @matchType NVARCHAR(10);

SET @matchType = '1/8';

SET @index = (SELECT TOP 1 Groups.Id FROM Groups);
 
	WHILE (@index <(SELECT MAX(Groups.Id) FROM Groups))
	BEGIN

		SET @commandFk1 = (SELECT TOP 1 CommandFk 
						   FROM Points
						   WHERE GroupFk = @index
						   ORDER BY PointsSum DESC);

		SET @commandFk2 = (SELECT TOP 1 CommandFk 
						   FROM Points
						   WHERE GroupFk = @index + 1
						   ORDER BY PointsSum DESC);

		EXECUTE GetRandIdJudge @judgeFk OUTPUT;
		EXECUTE GetRandIdStadium @stadiumFk OUTPUT;	


		SET @schedule = dbo.Get1s8Time(@index);

		INSERT INTO Matches1s8(Schedule, CommandFk1, CommandFk2, JudgeFk, StadiumFk, MatchType)
		VALUES (@schedule, @commandFk1, @commandFk2, @judgeFk, @stadiumFk, @matchType)



		SET @commandFk1 = (SELECT TOP 1 t.CommandFk
						   FROM	 (SELECT TOP 2 CommandFk, PointsSum
								  FROM Points
								  WHERE GroupFk = @index
								  ORDER BY PointsSum DESC)t
						   ORDER BY t.PointsSum ASC);

		SET @commandFk2 = (SELECT TOP 1 t.CommandFk
						   FROM	 (SELECT TOP 2 CommandFk, PointsSum
								  FROM Points
								  WHERE GroupFk = @index + 1
								  ORDER BY PointsSum DESC)t
						   ORDER BY t.PointsSum ASC);

		EXECUTE GetRandIdJudge @judgeFk OUTPUT;
		EXECUTE GetRandIdStadium @stadiumFk OUTPUT;	

		SET @schedule = dbo.Get1s8Time(@index + 1);

		INSERT INTO Matches1s8(Schedule, CommandFk1, CommandFk2, JudgeFk, StadiumFk, MatchType)
		VALUES (@schedule, @commandFk1, @commandFk2, @judgeFk, @stadiumFk, @matchType)

		SET @index += 2;
	END

END
GO

EXEC Fill1s8Matches
GO
------------------------------------------------------------------------------------------


 

------------------------------------------------------------------------------------------
CREATE PROCEDURE Play1s8(@matchId INT, @commandFk1 INT, @commandFk2 INT, @matchType NVARCHAR(10))
AS
BEGIN

DECLARE @command1Goals INT;
DECLARE @command2Goals INT;

SET @command1Goals = (SELECT FLOOR(RAND()*5));
SET @command2Goals = (SELECT FLOOR(RAND()*5));
	
DECLARE @result NVARCHAR(5);
SET @result = '';

SET @result += CAST(@command1Goals AS NVARCHAR(2)) + ':' + CAST(@command2Goals AS NVARCHAR(2));

IF(@command1Goals > @command2Goals)
BEGIN
INSERT INTO Match1s8Results(Id, WinnerFk, LooserFk, Result)
VALUES(@matchId, @commandFk1, @commandFk2, @result)
END

IF(@command2Goals > @command1Goals)
BEGIN
INSERT INTO Match1s8Results(Id, WinnerFk, LooserFk, Result)
VALUES(@matchId, @commandFk2, @commandFk1, @result)
END

If(@command1Goals = @command2Goals)
BEGIN

EXECUTE TopScorersFill @matchId, @commandFk1, @command1Goals, @matchType;
EXECUTE TopScorersFill @matchId, @commandFk2, @command2Goals, @matchType;

EXEC Play1s8 @matchId, @commandFk1, @commandFk2, @matchType;
END

EXECUTE TopScorersFill @matchId, @commandFk1, @command1Goals, @matchType;
EXECUTE TopScorersFill @matchId, @commandFk2, @command2Goals, @matchType;

END
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE PROCEDURE Play1s8Matches
AS
BEGIN
DECLARE @commandFk1 INT;
DECLARE @commandFk2 INT;
DECLARE @matchType NVARCHAR(10);
DECLARE @matchId INT;

SET @matchId = (SELECT TOP 1 Matches1s8.Id FROM Matches1s8)

WHILE (@matchId < ((SELECT MAX(Matches1s8.Id) FROM Matches1s8)+1))
BEGIN

	SET @commandFk1 = (SELECT Matches1s8.CommandFk1 FROM Matches1s8 WHERE Matches1s8.Id = @matchId);
	SET @commandFk2 = (SELECT Matches1s8.CommandFk2 FROM Matches1s8 WHERE Matches1s8.Id = @matchId);
	SET @matchType =  (SELECT Matches1s8.MatchType FROM Matches1s8 WHERE Matches1s8.Id = @matchId)

	EXEC Play1s8 @matchId, @commandFk1, @commandFk2,  @matchType

	SET @matchId += 1;

END

END
GO

EXECUTE Play1s8Matches;
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE FUNCTION Get1s4Time(@id INT)
RETURNS DATETIME 
AS
BEGIN
DECLARE @dateTimeMatch DATETIME;

SELECT @dateTimeMatch = DatesOf1s4.schedule
FROM DatesOf1s4
WHERE DatesOf1s4.Id = @id

RETURN @dateTimeMatch
END
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE PROCEDURE Fill1s4Matches
AS
BEGIN
DECLARE @index INT;
DECLARE @maxIndex INT;
DECLARE @judgeFk INT;
DECLARE @stadiumFk INT;
DECLARE @schedule DATETIME;
DECLARE @commandFk1 INT;
DECLARE @commandFk2 INT;
DECLARE @matchType NVARCHAR(10);

SET @index = (SELECT TOP 1 (Match1s8Results.Id) FROM Match1s8Results)
SET @maxIndex = (SELECT MAX(Match1s8Results.Id) FROM Match1s8Results);
SET @matchType = '1/4';

WHILE (@index < ((@maxIndex/2) + 1))
BEGIN 

		SET @schedule = dbo.Get1s4Time(@index);

		EXECUTE GetRandIdJudge @judgeFk OUTPUT;
		EXECUTE GetRandIdStadium @stadiumFk OUTPUT;	

		SET @commandFk1 = (SELECT WinnerFk FROM Match1s8Results WHERE Match1s8Results.Id = @index);
		SET @commandFk2 = (SELECT WinnerFk FROM Match1s8Results WHERE Match1s8Results.Id = ((@maxIndex + 1) - @index));

		INSERT INTO Matches1s4(Schedule, CommandFk1, CommandFk2, JudgeFk, StadiumFk, MatchType) 
		VALUES (@schedule, @commandFk1, @commandFk2, @judgeFk, @stadiumFk, @matchType);

		SET @index += 1;

	END
END
GO

EXECUTE Fill1s4Matches;
GO
------------------------------------------------------------------------------------------


 

------------------------------------------------------------------------------------------
CREATE PROCEDURE Play1s4(@matchId INT, @commandFk1 INT, @commandFk2 INT, @matchType NVARCHAR(10))
AS
BEGIN

DECLARE @command1Goals INT;
DECLARE @command2Goals INT;

SET @command1Goals = (SELECT FLOOR(RAND()*5));
SET @command2Goals = (SELECT FLOOR(RAND()*5));
	
DECLARE @result NVARCHAR(5);
SET @result = '';

SET @result += CAST(@command1Goals AS NVARCHAR(2)) + ':' + CAST(@command2Goals AS NVARCHAR(2));

IF(@command1Goals > @command2Goals)
BEGIN
INSERT INTO Match1s4Results(Id, WinnerFk, LooserFk, Result)
VALUES(@matchId, @commandFk1, @commandFk2, @result)
END

IF(@command2Goals > @command1Goals)
BEGIN
INSERT INTO Match1s4Results(Id, WinnerFk, LooserFk, Result)
VALUES(@matchId, @commandFk2, @commandFk1, @result)
END

If(@command1Goals = @command2Goals)
BEGIN

EXECUTE TopScorersFill @matchId, @commandFk1, @command1Goals, @matchType;
EXECUTE TopScorersFill @matchId, @commandFk2, @command2Goals, @matchType;

EXEC Play1s4 @matchId, @commandFk1, @commandFk2, @matchType;
END

EXECUTE TopScorersFill @matchId, @commandFk1, @command1Goals, @matchType;
EXECUTE TopScorersFill @matchId, @commandFk2, @command2Goals, @matchType;

END
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE PROCEDURE Play1s4Matches
AS
BEGIN
DECLARE @commandFk1 INT;
DECLARE @commandFk2 INT;
DECLARE @matchType NVARCHAR(10);
DECLARE @matchId INT;

SET @matchId = (SELECT TOP 1 Matches1s4.Id FROM Matches1s4)

WHILE (@matchId < ((SELECT MAX(Matches1s4.Id) FROM Matches1s4)+1))
BEGIN

	SET @commandFk1 = (SELECT Matches1s4.CommandFk1 FROM Matches1s4 WHERE Matches1s4.Id = @matchId);
	SET @commandFk2 = (SELECT Matches1s4.CommandFk2 FROM Matches1s4 WHERE Matches1s4.Id = @matchId);
	SET @matchType =  (SELECT Matches1s4.MatchType FROM Matches1s4 WHERE Matches1s4.Id = @matchId)

	EXEC Play1s4 @matchId, @commandFk1, @commandFk2,  @matchType

	SET @matchId += 1;

END

END
GO

EXECUTE Play1s4Matches;
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE FUNCTION Get1s2Time(@id INT)
RETURNS DATETIME 
AS
BEGIN
DECLARE @dateTimeMatch DATETIME;

SELECT @dateTimeMatch = DatesOf1s2.schedule
FROM DatesOf1s2
WHERE DatesOf1s2.Id = @id

RETURN @dateTimeMatch
END
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE PROCEDURE Fill1s2Matches
AS
BEGIN
DECLARE @index INT;
DECLARE @maxIndex INT;
DECLARE @judgeFk INT;
DECLARE @stadiumFk INT;
DECLARE @schedule DATETIME;
DECLARE @commandFk1 INT;
DECLARE @commandFk2 INT;
DECLARE @matchType NVARCHAR(10);

SET @index = (SELECT TOP 1 (Match1s4Results.Id) FROM Match1s4Results)
SET @maxIndex = (SELECT MAX(Match1s4Results.Id) FROM Match1s4Results);
SET @matchType = '1/2';

WHILE (@index < ((@maxIndex/2) + 1))
BEGIN 

		SET @schedule = dbo.Get1s2Time(@index);

		EXECUTE GetRandIdJudge @judgeFk OUTPUT;
		EXECUTE GetRandIdStadium @stadiumFk OUTPUT;	

		SET @commandFk1 = (SELECT WinnerFk FROM Match1s4Results WHERE Match1s4Results.Id = @index);
		SET @commandFk2 = (SELECT WinnerFk FROM Match1s4Results WHERE Match1s4Results.Id = ((@maxIndex + 1) - @index));

		INSERT INTO Matches1s2(Schedule, CommandFk1, CommandFk2, JudgeFk, StadiumFk, MatchType) 
		VALUES (@schedule, @commandFk1, @commandFk2, @judgeFk, @stadiumFk, @matchType);

		SET @index += 1;

	END
END
GO

EXECUTE Fill1s2Matches;
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE PROCEDURE Play1s2(@matchId INT, @commandFk1 INT, @commandFk2 INT, @matchType NVARCHAR(10))
AS
BEGIN

DECLARE @command1Goals INT;
DECLARE @command2Goals INT;

SET @command1Goals = (SELECT FLOOR(RAND()*5));
SET @command2Goals = (SELECT FLOOR(RAND()*5));
	
DECLARE @result NVARCHAR(5);
SET @result = '';

SET @result += CAST(@command1Goals AS NVARCHAR(2)) + ':' + CAST(@command2Goals AS NVARCHAR(2));

IF(@command1Goals > @command2Goals)
BEGIN
INSERT INTO Match1s2Results(Id, WinnerFk, LooserFk, Result)
VALUES(@matchId, @commandFk1, @commandFk2, @result)
END

IF(@command2Goals > @command1Goals)
BEGIN
INSERT INTO Match1s2Results(Id, WinnerFk, LooserFk, Result)
VALUES(@matchId, @commandFk2, @commandFk1, @result)
END

If(@command1Goals = @command2Goals)
BEGIN

EXECUTE TopScorersFill @matchId, @commandFk1, @command1Goals, @matchType;
EXECUTE TopScorersFill @matchId, @commandFk2, @command2Goals, @matchType;

EXEC Play1s2 @matchId, @commandFk1, @commandFk2, @matchType;
END

EXECUTE TopScorersFill @matchId, @commandFk1, @command1Goals, @matchType;
EXECUTE TopScorersFill @matchId, @commandFk2, @command2Goals, @matchType;

END
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE PROCEDURE Play1s2Matches
AS
BEGIN
DECLARE @commandFk1 INT;
DECLARE @commandFk2 INT;
DECLARE @matchType NVARCHAR(10);
DECLARE @matchId INT;

SET @matchId = (SELECT TOP 1 Matches1s2.Id FROM Matches1s2)

WHILE (@matchId < ((SELECT MAX(Matches1s2.Id) FROM Matches1s2)+1))
BEGIN

	SET @commandFk1 = (SELECT Matches1s2.CommandFk1 FROM Matches1s2 WHERE Matches1s2.Id = @matchId);
	SET @commandFk2 = (SELECT Matches1s2.CommandFk2 FROM Matches1s2 WHERE Matches1s2.Id = @matchId);
	SET @matchType =  (SELECT Matches1s2.MatchType FROM Matches1s2 WHERE Matches1s2.Id = @matchId)

	EXEC Play1s2 @matchId, @commandFk1, @commandFk2,  @matchType

	SET @matchId += 1;

END

END
GO

EXECUTE Play1s2Matches;
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE FUNCTION GetFinalTime(@id INT)
RETURNS DATETIME 
AS
BEGIN
DECLARE @dateTimeMatch DATETIME;

SELECT @dateTimeMatch = DatesOfFinal.schedule
FROM DatesOfFinal
WHERE DatesOfFinal.Id = @id

RETURN @dateTimeMatch
END
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE PROCEDURE FillFinalMatches
AS
BEGIN
DECLARE @index INT;
DECLARE @maxIndex INT;
DECLARE @judgeFk INT;
DECLARE @stadiumFk INT;
DECLARE @schedule DATETIME;
DECLARE @commandFk1 INT;
DECLARE @commandFk2 INT;
DECLARE @matchType NVARCHAR(10);

SET @index = (SELECT TOP 1 (Match1s2Results.Id) FROM Match1s2Results)
SET @maxIndex = (SELECT MAX(Match1s2Results.Id) FROM Match1s2Results);
SET @matchType = 'Final';

SET @schedule = dbo.GetFinalTime(@index);

EXECUTE GetRandIdJudge @judgeFk OUTPUT;
EXECUTE GetRandIdStadium @stadiumFk OUTPUT;	

SET @commandFk1 = (SELECT WinnerFk FROM Match1s2Results WHERE Match1s2Results.Id = @index);
SET @commandFk2 = (SELECT WinnerFk FROM Match1s2Results WHERE Match1s2Results.Id = @maxIndex);

INSERT INTO MatchesFinal(Schedule, CommandFk1, CommandFk2, JudgeFk, StadiumFk, MatchType) 
VALUES (@schedule, @commandFk1, @commandFk2, @judgeFk, @stadiumFk, @matchType);

SET @schedule = dbo.GetFinalTime(@maxIndex);

EXECUTE GetRandIdJudge @judgeFk OUTPUT;
EXECUTE GetRandIdStadium @stadiumFk OUTPUT;	

SET @commandFk1 = (SELECT LooserFk FROM Match1s2Results WHERE Match1s2Results.Id = @index);
SET @commandFk2 = (SELECT LooserFk FROM Match1s2Results WHERE Match1s2Results.Id = @maxIndex);

INSERT INTO MatchesFinal(Schedule, CommandFk1, CommandFk2, JudgeFk, StadiumFk, MatchType) 
VALUES (@schedule, @commandFk1, @commandFk2, @judgeFk, @stadiumFk, @matchType);
 
END
GO

EXECUTE FillFinalMatches;
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE PROCEDURE PlayFinal(@matchId INT, @commandFk1 INT, @commandFk2 INT, @matchType NVARCHAR(10))
AS
BEGIN

DECLARE @command1Goals INT;
DECLARE @command2Goals INT;

SET @command1Goals = (SELECT FLOOR(RAND()*5));
SET @command2Goals = (SELECT FLOOR(RAND()*5));
	
DECLARE @result NVARCHAR(5);
SET @result = '';

SET @result += CAST(@command1Goals AS NVARCHAR(2)) + ':' + CAST(@command2Goals AS NVARCHAR(2));

IF(@command1Goals > @command2Goals)
BEGIN
INSERT INTO MatchFinalResults(Id, WinnerFk, LooserFk, Result)
VALUES(@matchId, @commandFk1, @commandFk2, @result)
END

IF(@command2Goals > @command1Goals)
BEGIN
INSERT INTO MatchFinalResults(Id, WinnerFk, LooserFk, Result)
VALUES(@matchId, @commandFk2, @commandFk1, @result)
END

If(@command1Goals = @command2Goals)
BEGIN

EXECUTE TopScorersFill @matchId, @commandFk1, @command1Goals, @matchType;
EXECUTE TopScorersFill @matchId, @commandFk2, @command2Goals, @matchType;

EXEC PlayFinal @matchId, @commandFk1, @commandFk2, @matchType;
END

EXECUTE TopScorersFill @matchId, @commandFk1, @command1Goals, @matchType;
EXECUTE TopScorersFill @matchId, @commandFk2, @command2Goals, @matchType;

END
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE PROCEDURE PlayFinalMatches
AS
BEGIN
DECLARE @commandFk1 INT;
DECLARE @commandFk2 INT;
DECLARE @matchType NVARCHAR(10);
DECLARE @matchId INT;

SET @matchId = (SELECT TOP 1 MatchesFinal.Id FROM MatchesFinal)

WHILE (@matchId < ((SELECT MAX(MatchesFinal.Id) FROM MatchesFinal)+1))
BEGIN

	SET @commandFk1 = (SELECT MatchesFinal.CommandFk1 FROM MatchesFinal WHERE MatchesFinal.Id = @matchId);
	SET @commandFk2 = (SELECT MatchesFinal.CommandFk2 FROM MatchesFinal WHERE MatchesFinal.Id = @matchId);
	SET @matchType =  (SELECT MatchesFinal.MatchType FROM MatchesFinal WHERE MatchesFinal.Id = @matchId)

	EXEC PlayFinal @matchId, @commandFk1, @commandFk2, @matchType

	SET @matchId += 1;

END

END
GO

EXECUTE PlayFinalMatches;
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE PROCEDURE FillWinners
AS 
BEGIN

DECLARE @firstPlace INT;
DECLARE @secondPlace INT;
DECLARE @thirdPlace INT;
DECLARE @index INT;
DECLARE @maxIndex INT;

SET @index = (SELECT TOP 1 MatchFinalResults.Id FROM MatchFinalResults);
SET @maxIndex = (SELECT MAX(MatchFinalResults.Id) FROM MatchFinalResults);

SET @firstPlace = (SELECT MatchFinalResults.WinnerFk FROM MatchFinalResults WHERE MatchFinalResults.Id = @index);
SET @secondPlace =  (SELECT MatchFinalResults.LooserFk FROM MatchFinalResults WHERE MatchFinalResults.Id = @index);
SET @thirdPlace = (SELECT MatchFinalResults.WinnerFk FROM MatchFinalResults WHERE MatchFinalResults.Id = @maxIndex);

INSERT INTO Winners(FirstPlaceFk, SecondPlaceFk, ThirdPlaceFk) VALUES (@firstPlace, @secondPlace, @thirdPlace);

END
GO

EXEC FillWinners;