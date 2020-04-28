USE FootballChampionship
GO

CREATE PROCEDURE Replay1s8
AS
BEGIN

DELETE FROM TopScorers
WHERE (TopScorers.Match1s8Fk IS NOT NULL) OR
(TopScorers.Match1s4Fk IS NOT NULL) OR
(TopScorers.Match1s2Fk IS NOT NULL) OR
(TopScorers.MatchFinalFk IS NOT NULL)

DELETE FROM Matches1s8;

DELETE FROM Matches1s4;

DELETE FROM Matches1s2;

DELETE FROM MatchesFinal;

DELETE FROM Winners;

EXECUTE Fill1s8Matches;

EXECUTE Play1s8Matches;

EXECUTE Fill1s4Matches;

EXECUTE Play1s4Matches;

EXECUTE Fill1s2Matches;

EXECUTE Play1s2Matches;

EXECUTE FillFinalMatches;

EXECUTE PlayFinalMatches;

EXEC FillWinners;

END 
GO

EXECUTE Replay1s8;
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