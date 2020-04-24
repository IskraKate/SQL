IF DB_ID('FootballChampionship') IS NOT NULL
BEGIN
	USE master
		 ALTER DATABASE FootballChampionship SET single_user with rollback immediate
    DROP DATABASE FootballChampionship
END
GO 

CREATE DATABASE FootballChampionship
GO

USE FootballChampionship
GO

CREATE TABLE Positions
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100) NOT NULL
)
GO

CREATE TABLE Equipment
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100) NOT NULL
)
GO


CREATE TABLE Countries
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100) NOT NULL
)
GO

CREATE TABLE Trainers
(
	Id int PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100) NOT NULL,
	CountryFk INT,
	CountryChampFk INT,

	FOREIGN KEY (CountryFk) REFERENCES Countries(Id),
	FOREIGN KEY (CountryChampFk) REFERENCES Countries(Id)
)
GO

CREATE TABLE Cities
(
	Id int PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100) NOT NULL,
	CountryFk INT

	FOREIGN KEY (CountryFk) REFERENCES Countries(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
GO

CREATE TABLE Stadiums
(
	Id INT PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100) NOT NULL,
	Capacity INT,
	CityFk INT

	FOREIGN KEY (CityFk) REFERENCES Cities(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
GO

CREATE TABLE Commands
(	
	Id int PRIMARY KEY IDENTITY,
	CountryFk INT NOT NULL,
	TrainerFk INT NOT NULL,
	EquipmentFk int NOT NULL

	FOREIGN KEY (CountryFk) REFERENCES Countries(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (TrainerFk) REFERENCES Trainers(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (EquipmentFk) REFERENCES Equipment(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
Go


CREATE TABLE Players
(
	Id int PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100) NOT NULL,
	PositionFk INT NOT NULL,
	CommandFk INT NOT NULL

	FOREIGN KEY (CommandFk) REFERENCES Commands(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (PositionFk) REFERENCES Positions(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
GO

CREATE TABLE Associations
(
	Id int PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100) NOT NULL
)
Go

CREATE TABLE Dates
(
	Id int PRIMARY KEY IDENTITY,
	schedule DATETIME
)

CREATE TABLE Judges
(
	Id int PRIMARY KEY IDENTITY,
	[Name] NVARCHAR(100) NOT NULL,
	AssociationFk INT NOT NULL, 
	CountryFk INT NOT NULL

	FOREIGN KEY (AssociationFk) REFERENCES Associations(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
Go

CREATE TABLE Groups
(
    Id INT PRIMARY KEY IDENTITY,
	CommandFk1 INT NOT NULL,
	CommandFk2 INT NOT NULL,
	CommandFk3 INT NOT NULL,
	CommandFk4 INT NOT NULL

	FOREIGN KEY (CommandFk1) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (CommandFk2) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,	
	FOREIGN KEY (CommandFk3) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (CommandFk4) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
)
GO

CREATE TABLE Points
(
	CommandFk INT PRIMARY KEY NOT NULL,
	GroupFk INT NULL,
	PointsSum INT 

	FOREIGN KEY (CommandFk) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (GroupFk) REFERENCES Groups(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
)
GO

CREATE TABLE Matches
(
	Id INT PRIMARY KEY IDENTITY,
	Schedule DATETIME NOT NULL,
	CommandFk1 INT NOT NULL,
	CommandFk2 INT NOT NULL,
	JudgeFk INT NOT NULL,
	StadiumFk INT NOT NULL,

	FOREIGN KEY (JudgeFk) REFERENCES Judges(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (StadiumFk) REFERENCES Stadiums(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (CommandFk1) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (CommandFk2) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
)
GO

CREATE TABLE Matches1s8 
(
	Id INT PRIMARY KEY IDENTITY,
	Schedule DATETIME NOT NULL,
	CommandFk1 INT NOT NULL,
	CommandFk2 INT NOT NULL,
	JudgeFk INT NOT NULL,
	StadiumFk INT NOT NULL,

	FOREIGN KEY (JudgeFk) REFERENCES Judges(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (StadiumFk) REFERENCES Stadiums(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (CommandFk1) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (CommandFk2) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
)
GO

CREATE TABLE MatchResults
(
	Id INT PRIMARY KEY NOT NULL,
	WinnerFk INT NULL,
	LooserFk INT NULL,
	Result NVARCHAR(10) NULL,
	FOREIGN KEY (Id) REFERENCES Matches(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)

CREATE TABLE TopScorers
(
	Id INT PRIMARY KEY IDENTITY,
	TimeOfGoal NVARCHAR(10) NOT NULL,
	PlayerFk INT NOT NULL,
	MatchFk INT NOT NULL

	FOREIGN KEY (PlayerFk) REFERENCES Players(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY(MatchFk) REFERENCES Matches(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
GO
