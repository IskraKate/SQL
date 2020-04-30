USE FootballChampionship
GO

CREATE PROCEDURE ReplayFinal
AS
BEGIN

DELETE FROM MatchesFinal;

DELETE FROM Winners;

EXECUTE FillFinalMatches;

EXECUTE PlayFinalMatches;

EXEC FillWinners;

END
GO

CREATE PROCEDURE Replay1s2
AS
BEGIN

DELETE FROM Matches1s2;

EXECUTE Fill1s2Matches;

EXECUTE Play1s2Matches;

EXECUTE ReplayFinal;

END
GO

CREATE PROCEDURE Replay1s4
AS
BEGIN

DELETE FROM Matches1s4;

EXECUTE Fill1s4Matches;

EXECUTE Play1s4Matches;

EXECUTE Replay1s2;

END
GO

CREATE PROCEDURE Replay1s8
AS
BEGIN

DELETE FROM Matches1s8;

EXECUTE Fill1s8Matches;

EXECUTE Play1s8Matches;

EXECUTE Replay1s4;

END 
GO
----------------------------------------------------------------------------------------------------






----------------------------------------------------------------------------------------------------
CREATE PROCEDURE ReplayGroup
AS 
BEGIN

DELETE FROM Points;

DELETE FROM Goals;

DELETE FROM GoalsScored;

DELETE FROM Groups;

DELETE FROM TopScorers;

DELETE FROM MatchesGroup;

EXECUTE FillPointsNulls;

EXECUTE FillGoalsNulls;

EXECUTE FillGoalsScoredNulls;

EXECUTE FillGroups; 

EXECUTE FillGroupMatches;

EXECUTE PlayGroupMatches;

EXECUTE CountPoints;

EXECUTE CheckSimilarPoints;

EXECUTE Replay1s8;

END
GO

EXECUTE ReplayGroup;
GO
----------------------------------------------------------------------------------------------------






----------------------------------------------------------------------------------------------------
CREATE PROCEDURE ReplayChamp
AS
BEGIN

EXECUTE ReplayGroup;

END
GO

EXEC ReplayChamp;
GO
----------------------------------------------------------------------------------------------------