IF DB_ID('BooksSales') IS NOT NULL
BEGIN
	USE master
	 ALTER DATABASE BooksSales SET single_user with rollback immediate
    DROP DATABASE BooksSales
END
GO 

CREATE DATABASE BooksSales
GO

USE BooksSales
GO

CREATE TABLE Genres
(
	Id bigint PRIMARY KEY NOT NULL,
	Name nvarchar(50) NOT NULL
)
GO

CREATE TABLE Sections
(
	Id bigint PRIMARY KEY NOT NULL,
	Name nvarchar(50) NOT NULL
)
GO

CREATE TABLE Authors
(
	Id bigint PRIMARY KEY NOT NULL,
	FullName nvarchar(50) NOT NULL
)
GO

CREATE TABLE Cities
(
	Id bigint PRIMARY KEY NOT NULL,
	Name nvarchar(50) NOT NULL
)
GO

CREATE TABLE PhoneNumbers
(
	Id bigint PRIMARY KEY NOT NULL,
	Number bigint NOT NULL
)
GO

CREATE TABLE SectionsAndGenres
(
	Id bigint PRIMARY KEY NOT NULL,
	GenreFk bigint, 
	SectionFk bigint,

	FOREIGN KEY (GenreFk) REFERENCES Genres(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (SectionFk) REFERENCES Sections(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
GO

CREATE TABLE PublishHouses
(
	Id bigint PRIMARY KEY NOT NULL,
	Name nvarchar(50),
	CityFk bigint,

	FOREIGN KEY (CityFk) REFERENCES Cities(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
GO

CREATE TABLE Sellers
(
	Id bigint PRIMARY KEY NOT NULL,
	FullName nvarchar(50),
	CityFk bigint,
	PhoneNumberFk  bigint,

	FOREIGN KEY (CityFk) REFERENCES Cities(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (PhoneNumberFk) REFERENCES PhoneNumbers(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
GO

CREATE TABLE Buyer
(
	Id bigint PRIMARY KEY NOT NULL,
	FullName nvarchar(50),
	CityFk bigint,
	PhoneNumberFk  bigint,

	FOREIGN KEY (CityFk) REFERENCES Cities(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (PhoneNumberFk) REFERENCES PhoneNumbers(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
GO

CREATE TABLE Books
(
	Id bigint PRIMARY KEY NOT NULL,
	Title nvarchar(50),
	PublishHouseFk bigint,
	AuthorFk  bigint,
	SectionAndGenreFk bigint,

	FOREIGN KEY (PublishHouseFk) REFERENCES PublishHouses(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (AuthorFk) REFERENCES Authors(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (SectionAndGenreFk) REFERENCES SectionsAndGenres(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
GO

CREATE TABLE BooksSales
(
	Id bigint PRIMARY KEY NOT NULL,
	BookFk bigint,
	SoldBooks int, 
	BuyerFk bigint,
	SellerFk bigint,

	FOREIGN KEY (BookFk) REFERENCES Books(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (BuyerFk) REFERENCES SectionsAndGenres(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (SellerFk) REFERENCES Sellers(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
GO

INSERT INTO Genres VALUES(1, 'Путешествия и география')
INSERT INTO Genres VALUES(2, 'Приключения')
INSERT INTO Genres VALUES(3, 'Природа и животные')
INSERT INTO Genres VALUES(4, 'Классическая проза')
INSERT INTO Genres VALUES(5, 'Готический роман')
INSERT INTO Genres VALUES(6, 'Повесть')
INSERT INTO Genres VALUES(7, 'Сказки народов мира')
INSERT INTO Genres VALUES(8, 'Стихи для детей')
INSERT INTO Genres VALUES(9, 'Фантастика')
INSERT INTO Genres VALUES(10, 'Фэнтези')

INSERT INTO Sections VALUES(1, 'Взрослая литература')
INSERT INTO Sections VALUES(2, 'Приключения')
INSERT INTO Sections VALUES(3, 'Детская литература')
INSERT INTO Sections VALUES(4, 'Проза')
INSERT INTO Sections VALUES(5, 'Фантастика')
INSERT INTO Sections VALUES(6, 'Фольклор')

--Путешествия и география.Приключения
INSERT INTO Authors VALUES(1, 'Жюль Верн')
INSERT INTO Authors VALUES(2, 'Марк Твен')
--Природа и животные
INSERT INTO Authors VALUES(3, 'Уильям Хорвуд')
--Классическая проза
INSERT INTO Authors VALUES(4, 'Лев Толстой')
INSERT INTO Authors VALUES(5, 'Михаил Булгаков')
--Готический роман
INSERT INTO Authors VALUES(6, 'Дафна Дюморье')
--Повесть
INSERT INTO Authors VALUES(7, 'Стивен Кинг')
--Сказки народов мира
INSERT INTO Authors VALUES(8, 'Линдгрен Астрид')
INSERT INTO Authors VALUES(9, 'Льюис Кэрролл')
--Стихи для детей
INSERT INTO Authors VALUES(10, 'Александр Сергеевич Пушкин')
INSERT INTO Authors VALUES(11, 'Корней Чуковский')
--Фантастика
INSERT INTO Authors VALUES(12, 'Дэниел Киз')
INSERT INTO Authors VALUES(13, 'Айзек Азимов')
--Фэнтези
INSERT INTO Authors VALUES(14, 'Анджей Сапковский')

INSERT INTO Cities VALUES(1, 'Москва')
INSERT INTO Cities VALUES(2, 'Петербург')
INSERT INTO Cities VALUES(3, 'Одесса')
INSERT INTO Cities VALUES(4, 'Киев')
INSERT INTO Cities VALUES(5, 'Николаев')
INSERT INTO Cities VALUES(6, 'Винница')
INSERT INTO Cities VALUES(7, 'Львов')

INSERT INTO PhoneNumbers VALUES(1, 0975632212)
INSERT INTO PhoneNumbers VALUES(2, 0634335884)
INSERT INTO PhoneNumbers VALUES(3, 0565434211)
INSERT INTO PhoneNumbers VALUES(4, 0633421567)
INSERT INTO PhoneNumbers VALUES(5, 0639875234)
INSERT INTO PhoneNumbers VALUES(6, 0564656675)
INSERT INTO PhoneNumbers VALUES(7, 0972445565)

INSERT INTO SectionsAndGenres VALUES(1, '')
INSERT INTO SectionsAndGenres VALUES(2, '')
INSERT INTO SectionsAndGenres VALUES(3, '')
INSERT INTO SectionsAndGenres VALUES(4, '')
INSERT INTO SectionsAndGenres VALUES(5, '')
INSERT INTO SectionsAndGenres VALUES(6, '')
INSERT INTO SectionsAndGenres VALUES(7, '')
INSERT INTO SectionsAndGenres VALUES(8, '')
INSERT INTO SectionsAndGenres VALUES(9, '')
INSERT INTO SectionsAndGenres VALUES(10, '')
INSERT INTO SectionsAndGenres VALUES(11, '')
INSERT INTO SectionsAndGenres VALUES(12, '')
INSERT INTO SectionsAndGenres VALUES(13, '')
INSERT INTO SectionsAndGenres VALUES(14, '')