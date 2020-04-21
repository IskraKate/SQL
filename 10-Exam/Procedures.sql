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

SELECT @dateTimeMatch = Dates.schedule
FROM Dates
WHERE Dates.Id = @id

RETURN @dateTimeMatch
END
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE PROCEDURE FillMatches
AS
BEGIN
	DECLARE @id INT;
	DECLARE @groupId INT;
	SET @id = (SELECT TOP 1 Dates.Id FROM Dates);
	SET @groupId = (SELECT TOP 1 Groups.Id FROM Groups);
	WHILE @id < ((SELECT COUNT(Dates.Id) FROM Dates) + 1)
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
	EXECUTE GetRandIdJudge @JudgeFk OUTPUT;

	DECLARE @stadiumFk INT;
	EXECUTE GetRandIdStadium @StadiumFk OUTPUT;

	IF((@id - 1)%6 = 0)
	INSERT INTO Matches(Schedule, CommandFk1, CommandFk2, JudgeFk, StadiumFk)
	VALUES (@schedule, @commandFk1, @commandFk2, @judgeFk, @stadiumFk)

	IF((@id - 2)%6 = 0)
	INSERT INTO Matches(Schedule, CommandFk1, CommandFk2, JudgeFk, StadiumFk)
	VALUES (@schedule, @commandFk1, @commandFk3, @judgeFk, @stadiumFk)

	IF((@id - 3)%6 = 0)
	INSERT INTO Matches(Schedule, CommandFk1, CommandFk2, JudgeFk, StadiumFk)
	VALUES (@schedule, @commandFk1, @commandFk4, @judgeFk, @stadiumFk)

	IF((@id - 4)%6 = 0)
	INSERT INTO Matches(Schedule, CommandFk1, CommandFk2, JudgeFk, StadiumFk)
	VALUES (@schedule, @commandFk2, @commandFk3, @judgeFk, @stadiumFk)

	IF((@id - 5)%6 = 0)
	INSERT INTO Matches(Schedule, CommandFk1, CommandFk2, JudgeFk, StadiumFk)
	VALUES (@schedule, @commandFk2, @commandFk4, @judgeFk, @stadiumFk)

	IF(@id%6=0)
	INSERT INTO Matches(Schedule, CommandFk1, CommandFk2, JudgeFk, StadiumFk)
	VALUES (@schedule, @commandFk3, @commandFk4, @judgeFk, @stadiumFk)

		
	SET @id+=1;	

    IF((@id - 1)%6 = 0)
    SET @groupId +=1;

	END
END
GO

EXECUTE FillMatches;
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE PROCEDURE TopScorersFill(@matchId INT, @commandFk INT, @goals INT)
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
	
	INSERT INTO TopScorers(TimeOfGoal, PlayerFk, MatchFk)
	VALUES (@timeString, @player, @matchId)

	SET @index -=1;
	END
END
GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
CREATE PROCEDURE Play
AS
BEGIN
	DECLARE @matchId INT;
	SET @matchId = (SELECT TOP 1 Matches.Id FROM Matches)
	WHILE (@matchId < ((SELECT MAX(Matches.Id) FROM Matches)+1) )
	BEGIN

	DECLARE @command1Goals INT;
	DECLARE @command2Goals INT;
	
	DECLARE @commandFk1 INT;
	DECLARE @commandFk2 INT;

    DECLARE @result NVARCHAR(5);
	SET @result = '';

	SET @command1Goals = (SELECT FLOOR(RAND()*5));
	SET @command2Goals = (SELECT FLOOR(RAND()*5));
	
	SET @result += CAST(@command1Goals AS NVARCHAR(2)) + ':' + CAST(@command2Goals AS NVARCHAR(2));

	SET @commandFk1 = (SELECT Matches.CommandFk1 FROM Matches WHERE Matches.Id = @matchId)
	SET @commandFk2 = (SELECT Matches.CommandFk2 FROM Matches WHERE Matches.Id = @matchId);

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

	EXECUTE TopScorersFill @matchId, @commandFk1, @command1Goals;
	EXECUTE TopScorersFill @matchId, @commandFk2, @command2Goals;

	SET @matchId += 1;

	END
END
GO

EXECUTE Play;
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
CREATE PROCEDURE CheckSimilarPoints
AS
BEGIN

DECLARE @pointsSum1 INT;
DECLARE @pointsSum2 INT;
DECLARE @pointsSum3 INT;
DECLARE @pointsSum4 INT;

DECLARE @index INT;
SET @index = (SELECT TOP 1 Groups.Id FROM GROUPS)

	WHILE (@index < (SELECT MAX(Groups.Id) FROM Groups))
	BEGIN

	SET @pointsSum1 =   (SELECT TOP 1 PointsSum
						FROM Points
						WHERE GroupFk = @index
						ORDER BY GroupFk ASC, PointsSum DESC);

	SET @pointsSum2 =   (SELECT TOP 1 S.PS
						FROM  
						(SELECT TOP 2 PointsSum AS PS
						FROM Points
						WHERE GroupFk = @index
						ORDER BY GroupFk ASC, PointsSum DESC) S
						ORDER BY PS ASC);

	SET @pointsSum3 =  (SELECT TOP 1 S.PS
						FROM  
						(SELECT TOP 2 PointsSum AS PS
						FROM Points
						WHERE GroupFk = @index
						ORDER BY GroupFk ASC, PointsSum ASC) S
						ORDER BY PS DESC);

	SET @pointsSum4 =   (SELECT TOP 1 PointsSum
						FROM Points
						WHERE GroupFk = @index
						ORDER BY GroupFk ASC, PointsSum ASC);

		IF(@pointsSum1 = @pointsSum4)
	BEGIN 

		DECLARE @commandFk1 INT;
		DECLARE @commandFk2 INT;
		DECLARE @commandFk3 INT;
		DECLARE @commandFk4 INT;
		DECLARE @schedule DATETIME;

	    SET @commandFk1 = (SELECT Groups.CommandFk1
						   FROM Groups
						   WHERE Groups.Id = @index);

	    SET @commandFk2 = (SELECT Groups.CommandFk2
						   FROM Groups
						   WHERE Groups.Id = @index);

		SET @commandFk3 = (SELECT Groups.CommandFk3
						   FROM Groups
						   WHERE Groups.Id = @index);

		SET @commandFk4 = (SELECT Groups.CommandFk4
						   FROM Groups
						   WHERE Groups.Id = @index);
		

		SET @schedule =   (SELECT Schedule
						   FROM Matches
						   WHERE Matches.Id = (SELECT MAX (Matches.Id) FROM Matches));

		
		DECLARE @days INT;
		SET @days = (SELECT FLOOR(RAND()*((10-1)+1)));

		SELECT DATEADD(day, @days, @schedule);

		DECLARE @judgeFk INT;
		DECLARE @stadiumFk INT;

		EXECUTE GetRandIdJudge @judgeFk OUTPUT;
		EXECUTE GetRandIdStadium @stadiumFk OUTPUT;

		INSERT INTO Matches(Schedule, CommandFk1, CommandFk2, JudgeFk, StadiumFk)
		VALUES (@schedule, @commandFk1, @commandFk2, @judgeFk, @stadiumFk)
		EXECUTE PlayConcreteCommands @commandFk1, @commandFk2

		EXECUTE GetRandIdJudge @judgeFk OUTPUT;
		EXECUTE GetRandIdStadium @stadiumFk OUTPUT;

		INSERT INTO Matches(Schedule, CommandFk1, CommandFk2, JudgeFk, StadiumFk)
		VALUES  (@schedule, @commandFk1, @commandFk3, @judgeFk, @stadiumFk)
		EXECUTE PlayConcreteCommands @commandFk1, @commandFk3

		EXECUTE GetRandIdJudge @judgeFk OUTPUT;
		EXECUTE GetRandIdStadium @stadiumFk OUTPUT;

		INSERT INTO Matches(Schedule, CommandFk1, CommandFk2, JudgeFk, StadiumFk)
		VALUES  (@schedule, @commandFk1, @commandFk4, @judgeFk, @stadiumFk)
		EXECUTE PlayConcreteCommands @commandFk1, @commandFk4

		EXECUTE GetRandIdJudge @judgeFk OUTPUT;
		EXECUTE GetRandIdStadium @stadiumFk OUTPUT;

		INSERT INTO Matches(Schedule, CommandFk1, CommandFk2, JudgeFk, StadiumFk)
		VALUES  (@schedule, @commandFk2, @commandFk3, @judgeFk, @stadiumFk)
		EXECUTE PlayConcreteCommands @commandFk2, @commandFk3

		EXECUTE GetRandIdJudge @judgeFk OUTPUT;
		EXECUTE GetRandIdStadium @stadiumFk OUTPUT;

		INSERT INTO Matches(Schedule, CommandFk1, CommandFk2, JudgeFk, StadiumFk)
		VALUES  (@schedule, @commandFk2, @commandFk4, @judgeFk, @stadiumFk)
		EXECUTE PlayConcreteCommands @commandFk2, @commandFk4

		EXECUTE GetRandIdJudge @judgeFk OUTPUT;
		EXECUTE GetRandIdStadium @stadiumFk OUTPUT;

		INSERT INTO Matches(Schedule, CommandFk1, CommandFk2, JudgeFk, StadiumFk)
		VALUES  (@schedule, @commandFk3, @commandFk4, @judgeFk, @stadiumFk)
		EXECUTE PlayConcreteCommands @commandFk3, @commandFk4

	END

		IF(@pointsSum2 = @pointsSum3)
		BEGIN
		END

		IF(@pointsSum1 = @pointsSum3)
		BEGIN
		END

		IF(@pointsSum2 = @pointsSum4)
		BEGIN
		END

		@index += 1;
	END
END
GO
------------------------------------------------------------------------------------------

 
 



------------------------------------------------------------------------------------------
CREATE PROCEDURE PlayConcreteCommands(@commandFk1 INT, @commandFk2 INT)
AS
BEGIN

    DECLARE @command1Goals INT;
	DECLARE @command2Goals INT;
	DECLARE @result INT;
	DECLARE @matchId INT;

	SET @command1Goals = (SELECT FLOOR(RAND()*5));
	SET @command2Goals = (SELECT FLOOR(RAND()*5));
	
	SET @result += CAST(@command1Goals AS NVARCHAR(2)) + ':' + CAST(@command2Goals AS NVARCHAR(2));

	SET @matchId = (SELECT MAX(Matches.Id) FROM Matches)

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

	EXECUTE TopScorersFill @matchId, @commandFk1, @command1Goals;
	EXECUTE TopScorersFill @matchId, @commandFk2, @command2Goals;

END
GO
------------------------------------------------------------------------------------------

 
 



------------------------------------------------------------------------------------------
CREATE PROCEDURE CountConcereteMatchPoints
AS
BEGIN
END

	--IF((SELECT MatchResults.LooserFk FROM MatchResults WHERE MatchResults.Id = @index) IS NOT NULL)
	--BEGIN
	--	SET @commandFk = (SELECT MatchResults.LooserFk FROM MatchResults WHERE MatchResults.Id = @index)

	--	UPDATE Points 
	--	SET PointsSum += 0
	--	WHERE CommandFk = @commandFk 

	--	SET @commandFk = (SELECT MatchResults.WinnerFk FROM MatchResults WHERE MatchResults.Id = @index)

	--	UPDATE Points 
	--	SET PointsSum += 3
	--	WHERE CommandFk = @commandFk 
	--END
	--ELSE
	--BEGIN
	--	SET @commandFk = (SELECT Matches.CommandFk1 FROM Matches WHERE Matches.Id = @index)

	--	UPDATE Points 
	--	SET PointsSum += 1
	--	WHERE CommandFk = @commandFk 

	--	SET @commandFk = (SELECT Matches.CommandFk2 FROM Matches WHERE Matches.Id = @index)

	--	UPDATE Points 
	--	SET PointsSum += 1
	--	WHERE CommandFk = @commandFk 

	--END

















--CREATE PROCEDURE MatchesOneEightProc
--AS
--BEGIN

--DECLARE @commandFk1 INT;
--DECLARE @commandFk2 INT;

--	 CREATE TABLE MatchesOneEight
--	 (
--		 Id INT PRIMARY KEY IDENTITY,
--		 CommandFk1 int,
--		 CommandFk2 int

--		 FOREIGN KEY (CommandFk1) REFERENCES Commands(Id),
--		 FOREIGN KEY (CommandFk2) REFERENCES Commands(Id)
--	 )

--	 SET @commandFk1 = 

--	 --INSERT INTO MatchesOneEight(CommandFk1, CommandFk2)
--	 --VALUES
--END
--GO
------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------
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

		--DECLARE @JudgeFk INT;
		--EXECUTE GetRandIdJudge @JudgeFk OUTPUT;

		--DECLARE @StadiumFk INT;
		--EXECUTE GetRandIdStadium @StadiumFk OUTPUT;

--		INSERT INTO Matches (Schedule, CommandFk1, CommandFk2, JudgeFk, StadiumFk)
--		VALUES ('2020-04-15', @CommandFk1, @CommandFk2, @JudgeFk, @StadiumFk);

--		SET @id += 1;
--	END
--END
--DROP PROCEDURE Replay

--EXECUTE Replay;


