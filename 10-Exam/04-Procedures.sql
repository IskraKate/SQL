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
	WHILE (@matchId < ((SELECT COUNT(Matches.Id) FROM Matches)+1) )
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
	INSERT INTO MatchResults(Id, WinnerFk, LooserFk, Result)
	VALUES(@matchId, @commandFk1, @commandFk2, @result)

	IF(@command2Goals > @command1Goals)
	INSERT INTO MatchResults(Id, WinnerFk, LooserFk, Result)
	VALUES(@matchId, @commandFk2, @commandFk1, @result)

	If(@command1Goals = @command2Goals)
	INSERT INTO MatchResults(Id, Result)
	VALUES(@matchId, @result)

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
DECLARE @pointSum INT;
DECLARE @commandFk INT;
SET @index = (SELECT TOP 1 MatchResults.Id FROM MatchResults);
WHILE @index < (SELECT COUNT(MatchResults.Id) FROM MatchResults)
	BEGIN
	SET @pointSum = 0;
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