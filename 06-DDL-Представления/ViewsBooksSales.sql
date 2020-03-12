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

CREATE TABLE Cities
(
	Id bigint PRIMARY KEY NOT NULL,
	Name nvarchar(50) NOT NULL
)
GO

CREATE TABLE Countries
(
	Id bigint PRIMARY KEY NOT NULL,
	Name nvarchar(50) NOT NULL, 
	CityFk bigint

	FOREIGN KEY (CityFk) REFERENCES Cities(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
GO

CREATE TABLE PhoneNumbers
(
	Id bigint PRIMARY KEY NOT NULL,
	Number bigint NOT NULL
)
GO

CREATE TABLE Genres
(
	Id bigint PRIMARY KEY NOT NULL,
	[Name] nvarchar(50) NOT NULL
)
GO

CREATE TABLE Sections
(
	Id bigint PRIMARY KEY NOT NULL,
	[Name] nvarchar(50) NOT NULL
)
GO

CREATE TABLE Authors
(
	Id bigint PRIMARY KEY NOT NULL,
	FullName nvarchar(50) NOT NULL,
	CountryFk bigint

	FOREIGN KEY (CountryFk) REFERENCES Countries(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
GO

CREATE TABLE SectionsAndGenres
(
	Id bigint PRIMARY KEY NOT NULL,
	SectionFk bigint,
	GenreFk bigint, 

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
	[Name] nvarchar(50),
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

CREATE TABLE Buyers
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
	Price int

	FOREIGN KEY (PublishHouseFk) REFERENCES PublishHouses(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (AuthorFk) REFERENCES Authors(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (SectionAndGenreFk) REFERENCES SectionsAndGenres(Id)
	ON DELETE CASCADE
	ON UPDATE CASCADE
)
GO

CREATE TABLE BookShops
(
	Id bigint PRIMARY KEY NOT NULL,
	[Name] nvarchar(50),
	CountryFk bigint

	FOREIGN KEY (CountryFk) REFERENCES Countries(Id)
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
	BookShopsFk bigint

	FOREIGN KEY (BookFk) REFERENCES Books(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (BuyerFk) REFERENCES Buyers(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (SellerFk) REFERENCES Sellers(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (BookShopsFk) REFERENCES BookShops(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
)
GO

INSERT INTO Genres VALUES(1, N'Путешествия и география')
INSERT INTO Genres VALUES(2, N'Приключения')
INSERT INTO Genres VALUES(3, N'Природа и животные')
INSERT INTO Genres VALUES(4, N'Классическая проза')
INSERT INTO Genres VALUES(5, N'Готический роман')
INSERT INTO Genres VALUES(6, N'Повесть')
INSERT INTO Genres VALUES(7, N'Сказки народов мира')
INSERT INTO Genres VALUES(8, N'Стихи для детей')
INSERT INTO Genres VALUES(9, N'Фантастика')
INSERT INTO Genres VALUES(10, N'Фэнтези')

INSERT INTO Sections VALUES(1, N'Взрослая литература')
INSERT INTO Sections VALUES(2, N'Приключения')
INSERT INTO Sections VALUES(3, N'Детская литература')
INSERT INTO Sections VALUES(4, N'Проза')
INSERT INTO Sections VALUES(5, N'Фантастика')
INSERT INTO Sections VALUES(6, N'Фольклор')

INSERT INTO Cities VALUES(1, N'Москва')
INSERT INTO Cities VALUES(2, N'Петербург')
INSERT INTO Cities VALUES(3, N'Одесса')
INSERT INTO Cities VALUES(4, N'Киев')
INSERT INTO Cities VALUES(5, N'Николаев')
INSERT INTO Cities VALUES(6, N'Винница')
INSERT INTO Cities VALUES(7, N'Львов')
INSERT INTO Cities VALUES(8, N'Кишинёв')

INSERT INTO Countries VALUES(1, N'Россия', 1)
INSERT INTO Countries VALUES(2, N'Россия', 2)
INSERT INTO Countries VALUES(3, N'Украина', 3)
INSERT INTO Countries VALUES(4, N'Украина', 4)
INSERT INTO Countries VALUES(5, N'Украина', 5)
INSERT INTO Countries VALUES(6, N'Украина', 6)
INSERT INTO Countries VALUES(7, N'Украина', 7)
INSERT INTO Countries VALUES(8, N'Молдова', 8)
INSERT INTO Countries VALUES(9, N'Франция', NULL)
INSERT INTO Countries VALUES(10, N'США', NULL)
INSERT INTO Countries VALUES(11, N'Великобритания', NULL)
INSERT INTO Countries VALUES(12, N'Швеция', NULL)
INSERT INTO Countries VALUES(13, N'Польша', NULL)
INSERT INTO Countries VALUES(14, N'Маленькая страна', NULL)

--Путешествия и география.Приключения
INSERT INTO Authors VALUES(1, N'Жюль Верн', 9)
INSERT INTO Authors VALUES(2, N'Марк Твен', 10)
--Природа и животные
INSERT INTO Authors VALUES(3, N'Уильям Хорвуд', 11)
--Классическая проза
INSERT INTO Authors VALUES(4, N'Лев Толстой', 1)
INSERT INTO Authors VALUES(5, N'Михаил Булгаков', 2)
--Готический роман
INSERT INTO Authors VALUES(6, N'Дафна Дюморье', 9)
--Повесть
INSERT INTO Authors VALUES(7, N'Стивен Кинг', 10)
--Сказки народов мира
INSERT INTO Authors VALUES(8, N'Линдгрен Астрид', 12)
INSERT INTO Authors VALUES(9, N'Льюис Кэрролл', 11)
--Стихи для детей
INSERT INTO Authors VALUES(10, N'Александр Сергеевич Пушкин', 2)
INSERT INTO Authors VALUES(11, N'Корней Чуковский', 1)
--Фантастика
INSERT INTO Authors VALUES(12, N'Дэниел Киз', 10)
INSERT INTO Authors VALUES(13, N'Айзек Азимов', 1)
--Фэнтези
INSERT INTO Authors VALUES(14, N'Анджей Сапковский', 13)
INSERT INTO Authors VALUES(15, N'Сам себе автор', 14)

INSERT INTO PhoneNumbers VALUES(1, 0975632212)
INSERT INTO PhoneNumbers VALUES(2, 0634335884)
INSERT INTO PhoneNumbers VALUES(3, 0565434211)
INSERT INTO PhoneNumbers VALUES(4, 0633421567)
INSERT INTO PhoneNumbers VALUES(5, 0639875234)
INSERT INTO PhoneNumbers VALUES(6, 0564656675)
INSERT INTO PhoneNumbers VALUES(7, 0972445565)

INSERT INTO SectionsAndGenres VALUES(1, 2, 1)
INSERT INTO SectionsAndGenres VALUES(2, 2, 2)
INSERT INTO SectionsAndGenres VALUES(3, 1, 4)
INSERT INTO SectionsAndGenres VALUES(4, 1, 5)
INSERT INTO SectionsAndGenres VALUES(5, 1, 6)
INSERT INTO SectionsAndGenres VALUES(6, 1, 9)
INSERT INTO SectionsAndGenres VALUES(7, 1, 10)
INSERT INTO SectionsAndGenres VALUES(8, 3, 1)
INSERT INTO SectionsAndGenres VALUES(9, 3, 2)
INSERT INTO SectionsAndGenres VALUES(10, 3, 3)
INSERT INTO SectionsAndGenres VALUES(11, 3, 7)
INSERT INTO SectionsAndGenres VALUES(12, 3, 8)
INSERT INTO SectionsAndGenres VALUES(13, 3, 9)
INSERT INTO SectionsAndGenres VALUES(14, 3, 10)
INSERT INTO SectionsAndGenres VALUES(15, 4, 1)
INSERT INTO SectionsAndGenres VALUES(16, 4, 2)
INSERT INTO SectionsAndGenres VALUES(17, 4, 3)
INSERT INTO SectionsAndGenres VALUES(18, 4, 4)
INSERT INTO SectionsAndGenres VALUES(19, 4, 5)
INSERT INTO SectionsAndGenres VALUES(20, 4, 6)
INSERT INTO SectionsAndGenres VALUES(21, 4, 7)
INSERT INTO SectionsAndGenres VALUES(22, 4, 9)
INSERT INTO SectionsAndGenres VALUES(23, 4, 10)
INSERT INTO SectionsAndGenres VALUES(24, 5, 10)
INSERT INTO SectionsAndGenres VALUES(25, 6, 7)

INSERT INTO PublishHouses VALUES(1, N'IPIO', 4)
INSERT INTO PublishHouses VALUES(2, N'Белая Ворона', 3)
INSERT INTO PublishHouses VALUES(3, N'ЭКСМО', 2)
INSERT INTO PublishHouses VALUES(4, N'Pabulum', 1)
INSERT INTO PublishHouses VALUES(5, N'АСТ', 6)
INSERT INTO PublishHouses VALUES(6, N'Мой издательский дом', 6)

INSERT INTO Sellers VALUES(1, N'Аня Сегодняшняя', 3, 4)
INSERT INTO Sellers VALUES(2, N'Алиса Завтрашняя', 3, 1)
INSERT INTO Sellers VALUES(3, N'Ира Вчерашняя', 3, 5)
INSERT INTO Sellers VALUES(4, N'Рита Позавчерашняя', 3, 7)
INSERT INTO Sellers VALUES(5, N'Зина Прошлогодняя', 3, 6)

INSERT INTO Buyers VALUES(1, N'Олег Ежечасный', 1, 5)
INSERT INTO Buyers VALUES(2, N'Миша Ежедневный', 3, 7)
INSERT INTO Buyers VALUES(3, N'Игорь Еженедельный', 4, 4)
INSERT INTO Buyers VALUES(4, N'Петя Ежемесячный', 5, 1)
INSERT INTO Buyers VALUES(5, N'Толик Ежегодный', 7, 2)

INSERT INTO Books VALUES(1, N'Ведьмак', 3, 14, 24, 200)
INSERT INTO Books VALUES(2, N'Трактир "Ямайка"' , 4, 6, 19, 300)
INSERT INTO Books VALUES(3, N'Приключения Тома Сойера', 5, 2, 2, 400)
INSERT INTO Books VALUES(4, N'Тело', 1, 7, 20, 500)
INSERT INTO Books VALUES(5, N'Мастер и Маргарита', 2, 5, 18, 600)
INSERT INTO Books VALUES(6, N'Собачье сердце', 2, 5, 18, 700)
INSERT INTO Books VALUES(7, N'Моя книга',6, 15, 3, 800)

INSERT INTO  BookShops(Id, [Name], CountryFk) VALUES (1, 'BookShop1', 2)
INSERT INTO  BookShops(Id, [Name], CountryFk) VALUES (2, 'BookShop2', 1)
INSERT INTO  BookShops(Id, [Name], CountryFk) VALUES (3, 'BookShop3', 9)
INSERT INTO  BookShops(Id, [Name], CountryFk) VALUES (4, 'BookShop4', 6)
INSERT INTO  BookShops(Id, [Name], CountryFk) VALUES (5, 'BookShop5', 5)

INSERT INTO BooksSales VALUES(1, 1, 3, 1, 2, 1)
INSERT INTO BooksSales VALUES(2, 2, 1, 3, 4, 2)
INSERT INTO BooksSales VALUES(3, 5, 4, 2, 1, 3)
INSERT INTO BooksSales VALUES(4, 3, 2, 1, 3, 4)
INSERT INTO BooksSales VALUES(5, 4, 5, 4, 5, 5)
INSERT INTO BooksSales VALUES(6, 7, 6, 4, 5, 5)
GO

--1. Найти авторов, которые живут в тех странах, где еcть хотя бы один из магазинов по распространению книг, занесённых в БД

CREATE VIEW CountryAuthorBookShop
AS
SELECT Authors.FullName, Countries.[Name]
FROM Authors, Countries
WHERE Authors.CountryFk = Countries.Id AND Authors.CountryFk IN
(
	SELECT BookShops.CountryFk
	FROM BookShops
)
GO

--2. Написать представление, которое содержит самую дорогую книгу тематики
CREATE VIEW MaxPriceOfGenre
AS
SELECT Books.Title
FROM Books
WHERE Books.Price =
(
	SELECT MAX(Books.Price)
	FROM Books
	WHERE SectionAndGenreFk IN
	(
		SELECT SectionsAndGenres.Id
		FROM SectionsAndGenres
		WHERE SectionsAndGenres.GenreFk IN
		(
			SELECT Genres.Id
			FROM Genres
			WHERE Genres.[Name] = 'Классическая проза'
		)
	)
)
GO

--3. Написать преставление, которое позволяет вывести всю информацию про работу магазинов.
--Отсортировать выборку по странам в возрастающем порядке и по названиям магазинов в убывающем.

CREATE VIEW InfoAndSort
AS
SELECT Books.Title , BooksSales.SoldBooks AS 'Sold Books', Buyers.FullName AS 'Buyer',
Sellers.FullName 'Seller', BookShops.[Name] 'Shop', Countries.[Name] AS 'Shop`s Country'
FROM BooksSales, BookShops, Books, Sellers, Buyers, Countries
WHERE BooksSales.BookShopsFk = BookShops.Id
AND BooksSales.BookFk = Books.Id
AND BooksSales.SellerFk = Sellers.Id 
AND BooksSales.BuyerFk = Buyers.Id
AND BookShops.CountryFk = Countries.Id
GO

--SELECT InfoAndSort.Title, InfoAndSort.[Sold Books], InfoAndSort.Buyer,
--InfoAndSort.Seller, InfoAndSort.Shop, InfoAndSort.[Shop`s Country]
--FROM InfoAndSort
--ORDER BY InfoAndSort.[Shop`s Country] ASC, InfoAndSort.Shop DESC 

--4. Написать зашифрованное представление, которое показывает самую популярную книгу

CREATE VIEW TheMostPopularBook WITH ENCRYPTION
AS
SELECT Books.Title
FROM Books
WHERE Books.Id IN
(
	SELECT BooksSales.BookFk
	FROM BooksSales
	WHERE BooksSales.SoldBooks = 
	(
		SELECT MAX(BooksSales.SoldBooks)
		FROM BooksSales
	)
)
GO

--5. Написать модифицированное представление, в котором предоставляется информация про авторов имена которых начинаются с А или с В

CREATE VIEW AuthorsAbInfo
AS
SELECT Authors.Id, Authors.FullName, Countries.[Name]
FROM Authors, Countries
WHERE Authors.CountryFk = Countries.Id AND Authors.FullName LIKE 'А%' OR Authors.FullName LIKE 'В%'
GO

--6. Написать представление, которое с помощью подзапросов выводит названия магазинов, которые ещё не продают книги вашего издательства

CREATE VIEW NotMyPublishHouse
AS
SELECT BookShops.[Name]
FROM BookShops
WHERE BookShops.Id NOT IN
(
	SELECT BookShopsFk
	FROM BooksSales
	WHERE BooksSales.BookFk IN
	(	
		SELECT Books.Id
		FROM Books
		WHERE Books.PublishHouseFk IN
		(
			SELECT PublishHouses.Id
			FROM PublishHouses
			WHERE PublishHouses.[Name] = 'Мой издательский дом' 
		)
	)
)
GO