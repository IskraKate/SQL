USE FootballChampionship
GO

------------------------------------------------------------------------------------------
CREATE PROCEDURE CommandsReplay(@commandFk1 INT, @commandFk2 INT, @matchType NVARCHAR(10))
AS
BEGIN

    DECLARE @command1Goals INT;
	DECLARE @command2Goals INT;
	DECLARE @result NVARCHAR(10);
	DECLARE @matchId INT;

	SET @command1Goals = (SELECT FLOOR(RAND()*5));
	SET @command2Goals = (SELECT FLOOR(RAND()*5));

	SET @result = '';
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

	EXECUTE TopScorersFill @matchId, @commandFk1, @command1Goals, @matchType;
	EXECUTE TopScorersFill @matchId, @commandFk2, @command2Goals, @matchType;

END
GO
------------------------------------------------------------------------------------------

 
 



------------------------------------------------------------------------------------------
CREATE PROCEDURE CountMatchPointsReplay
AS

DECLARE @commandFk INT;

SET @commandFk = (SELECT MatchResults.LooserFk 
				  FROM MatchResults
				  WHERE MatchResults.Id = (SELECT MAX(Matches.Id) FROM Matches))	

	IF(@commandFk IS NOT NULL)
	BEGIN

	UPDATE Points 
	SET PointsSum += 0
	WHERE CommandFk = @commandFk 
	

SET @commandFk = (SELECT MatchResults.WinnerFk 
				  FROM MatchResults
				  WHERE MatchResults.Id = (SELECT MAX(Matches.Id) FROM Matches))

	UPDATE Points 
	SET PointsSum += 3
	WHERE CommandFk = @commandFk 
	END
	ELSE 
	BEGIN
	SET @commandFk = (SELECT Matches.CommandFk1 FROM Matches WHERE Matches.Id = (SELECT MAX(Matches.Id) FROM Matches))

	UPDATE Points 
	SET PointsSum += 1
	WHERE CommandFk = @commandFk 

	SET @commandFk = (SELECT Matches.CommandFk2 FROM Matches WHERE Matches.Id = (SELECT MAX(Matches.Id) FROM Matches))

	UPDATE Points 
	SET PointsSum += 1
	WHERE CommandFk = @commandFk 

END
GO
------------------------------------------------------------------------------------------

 
 



------------------------------------------------------------------------------------------
CREATE PROCEDURE InsertIntoMatchesAndPlay(@commandFk1 INT, @commandFk2 INT)
AS
BEGIN 
	DECLARE @schedule DATETIME;
	SET @schedule =   (SELECT Schedule
						FROM Matches
						WHERE Matches.Id = (SELECT MAX (Matches.Id) FROM Matches));

	DECLARE @days INT;
	SET @days = (SELECT FLOOR(RAND()*((10-1)+1)));

	SELECT DATEADD(day, @days, @schedule);

	DECLARE @judgeFk INT;
	DECLARE @stadiumFk INT;
	DECLARE @matchType NVARCHAR(10);

	SET @matchType = 'Group';

	EXECUTE GetRandIdJudge @judgeFk OUTPUT;
	EXECUTE GetRandIdStadium @stadiumFk OUTPUT;

	INSERT INTO Matches(Schedule, CommandFk1, CommandFk2, JudgeFk, StadiumFk, MatchType)
	VALUES (@schedule, @commandFk1, @commandFk2, @judgeFk, @stadiumFk, @matchType)

	EXECUTE CommandsReplay @commandFk1, @commandFk2, @matchType
	EXECUTE CountMatchPointsReplay
END
GO
------------------------------------------------------------------------------------------

 
 



------------------------------------------------------------------------------------------
CREATE PROCEDURE NullPoints(@commandFk INT)
AS
BEGIN

	UPDATE Points 
	SET PointsSum = 0
	WHERE CommandFk = @commandFk 

END
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

	DECLARE @commandFk1 INT;
	DECLARE @commandFk2 INT;
	DECLARE @commandFk3 INT;
	DECLARE @commandFk4 INT;

	DECLARE @index INT;
	SET @index = (SELECT TOP 1 Groups.Id FROM Groups)

	WHILE (@index <= (SELECT MAX(Groups.Id) FROM Groups))
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
		
		SET @commandFk1 =  (SELECT TOP 1 CommandFk
							FROM Points
							WHERE GroupFk = @index
							ORDER BY GroupFk ASC, PointsSum DESC);

		SET @commandFk2 =  (SELECT TOP 1 S.CFk
							FROM  
							(SELECT TOP 2 PointsSum AS PS, CommandFk AS CFk
							FROM Points
							WHERE GroupFk = @index
							ORDER BY PointsSum DESC) S
							ORDER BY PS ASC);

		SET @commandFk3 =   (SELECT P.CommandFk
							 FROM (SELECT TOP 3 Points.PointsSum, Points.CommandFk
							 	   FROM Points
							 	   WHERE GroupFk = @index
							 	   ORDER BY Points.PointsSum DESC) P
							 ORDER BY P.PointsSum DESC OFFSET 2 ROW)
							
		SET @commandFk4 =  (SELECT TOP 1 Points.CommandFk 
						 	FROM Points
						    WHERE Points.PointsSum = 
								(SELECT TOP 1 PointsSum
								FROM Points
								WHERE GroupFk = @index
								ORDER BY GroupFk ASC, PointsSum ASC));


		IF(@pointsSum1 = @pointsSum2)
		BEGIN 

			EXECUTE InsertIntoMatchesAndPlay @commandFk1, @commandFk2

			EXECUTE CheckSimilarPoints
		END

		IF(@pointsSum1 = @pointsSum4)
		BEGIN 
		
			EXECUTE NullPoints @commandFk1

			EXECUTE NullPoints @commandFk2

			EXECUTE NullPoints @commandFk3

			EXECUTE NullPoints @commandFk4

			EXECUTE InsertIntoMatchesAndPlay @commandFk1, @commandFk2

			EXECUTE InsertIntoMatchesAndPlay @commandFk1, @commandFk3

			EXECUTE InsertIntoMatchesAndPlay @commandFk1, @commandFk4

			EXECUTE InsertIntoMatchesAndPlay @commandFk2, @commandFk3

			EXECUTE InsertIntoMatchesAndPlay @commandFk2, @commandFk4

			EXECUTE InsertIntoMatchesAndPlay @commandFk3, @commandFk4

			EXECUTE CheckSimilarPoints
		END

		IF(@pointsSum2 = @pointsSum3)
		BEGIN

			EXECUTE InsertIntoMatchesAndPlay @commandFk2, @commandFk3
  
			UPDATE Points 
			SET PointsSum += 3
			WHERE CommandFk = @commandFk1 
				                

			EXECUTE CheckSimilarPoints

		END

		IF(@pointsSum2 = @pointsSum4 AND @pointsSum2 != @pointsSum4)
		BEGIN

			EXECUTE NullPoints @commandFk2

			EXECUTE NullPoints @commandFk3
		
			EXECUTE NullPoints @commandFk4

			EXECUTE InsertIntoMatchesAndPlay @commandFk2, @commandFk3

			EXECUTE InsertIntoMatchesAndPlay @commandFk2, @commandFk4

			EXECUTE InsertIntoMatchesAndPlay @commandFk3, @commandFk4

			UPDATE Points 
			SET PointsSum += 6
			WHERE CommandFk = @commandFk1 

			EXECUTE CheckSimilarPoints
		END

		SET @index += 1;
	END

END
GO
------------------------------------------------------------------------------------------

