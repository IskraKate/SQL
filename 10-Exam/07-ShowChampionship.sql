USE FootballChampionship
GO

--Groups
-------------------------------------------------------------------------------------------
EXECUTE CreateTempTables;
GO

EXECUTE ShowAllMatchesOfGroup;
GO
--Results----------------------------------------------------------------------------------
EXECUTE DropTempTables;
GO

EXECUTE CreateTempTables;
GO

EXECUTE ShowResultsOfGroup;
GO
-------------------------------------------------------------------------------------------



--1/8
-------------------------------------------------------------------------------------------
EXECUTE DropTempTables;
GO

EXECUTE CreateTempTables;
GO

EXECUTE ShowAllMatchesOf1s8;
GO
--Results----------------------------------------------------------------------------------
EXECUTE DropTempTables;
GO

EXECUTE CreateTempTables;
GO

EXECUTE ShowResultsOf1s8;
GO
-------------------------------------------------------------------------------------------



--1/4
-------------------------------------------------------------------------------------------
EXECUTE DropTempTables;
GO

EXECUTE CreateTempTables;
GO

EXECUTE ShowAllMatchesOf1s4;
GO
--Results----------------------------------------------------------------------------------
EXECUTE DropTempTables;
GO

EXECUTE CreateTempTables;
GO

EXECUTE ShowResultsOf1s4;
GO
-------------------------------------------------------------------------------------------



--1/2
-------------------------------------------------------------------------------------------
EXECUTE DropTempTables;
GO

EXECUTE CreateTempTables;
GO

EXECUTE ShowAllMatchesOf1s2;
GO
--Results----------------------------------------------------------------------------------
EXECUTE DropTempTables;
GO

EXECUTE CreateTempTables;
GO

EXECUTE ShowResultsOf1s2;
GO
-------------------------------------------------------------------------------------------



--Final
-------------------------------------------------------------------------------------------
EXECUTE DropTempTables;
GO

EXECUTE CreateTempTables;
GO

EXECUTE ShowAllMatchesOfFinal;
GO
--Results----------------------------------------------------------------------------------
EXECUTE ShowWinners;
GO
-------------------------------------------------------------------------------------------