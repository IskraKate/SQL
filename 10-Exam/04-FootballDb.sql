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
Go

CREATE TABLE Positions
(
	Id int PRIMARY KEY NOT NULL,
	[Name] varchar NOT NULL
)
GO

CREATE TABLE Equipment
(
	Id int PRIMARY KEY NOT NULL,
	[Name] varchar NOT NULL
)
GO

CREATE TABLE Trainers
(
	Id int PRIMARY KEY NOT NULL,
	[Name] varchar NOT NULL
)
GO

CREATE TABLE Countries
(
	Id int PRIMARY KEY NOT NULL,
	[Name] varchar NOT NULL
)
GO

CREATE TABLE Cities
(
	Id int PRIMARY KEY NOT NULL,
	[Name] varchar NOT NULL,
	CountryFk int

	FOREIGN KEY (CountryFk) REFERENCES Countries(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
GO

CREATE TABLE Stadiums
(
	Id int PRIMARY KEY NOT NULL,
	[Name] varchar NOT NULL,

	FOREIGN KEY (Id) REFERENCES Cities(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
GO

CREATE TABLE Commands
(	
	Id int PRIMARY KEY NOT NULL,
	[Name] varchar NOT NULL,
	CountryFk int NOT NULL,
	TrainerFk int NOT NULL,
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
	Id int PRIMARY KEY NOT NULL,
	[Name] varchar NOT NULL,
	CommandFk int NOT NULL

	FOREIGN KEY (CommandFk) REFERENCES Commands(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (Id) REFERENCES Positions(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
GO

CREATE TABLE Associations
(
	Id int PRIMARY KEY NOT NULL,
	[Name] varchar NOT NULL
)
Go

CREATE TABLE Judges
(
	Id int PRIMARY KEY NOT NULL,
	[Name] varchar NOT NULL,
	AssociationFk int NOT NULL

	FOREIGN KEY (AssociationFk) REFERENCES Associations(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
Go

CREATE TABLE Matches
(
	Id int PRIMARY KEY NOT NULL,
	Schedule datetime NOT NULL,
	CommandFk1 int NOT NULL,
	CommandFk2 int NOT NULL,
	JudgeFk int NOT NULL

	FOREIGN KEY (CommandFk1) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (CommandFk2) REFERENCES Commands(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (JudgeFk) REFERENCES Judges(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
Go

CREATE TABLE MatchResults
(
	Id int PRIMARY KEY NOT NULL,
	Winner int NULL,
	Looser int NULL,
	Result varchar NOT NULL
	--'�������� ���� �� ������/�����'
	FOREIGN KEY (Id) REFERENCES Matches(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)

CREATE TABLE TopScorers
(
	Id int PRIMARY KEY NOT NULL,
	TimeIfGoal Time NOT NULL,
	PlayerFk int NOT NULL,
	MatchFk int NOT NULL

	FOREIGN KEY (PlayerFk) REFERENCES Players(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY(MatchFk) REFERENCES Matches(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
Go