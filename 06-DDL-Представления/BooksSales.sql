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

INSERT INTO Genres VALUES(1, N'����������� � ���������')
INSERT INTO Genres VALUES(2, N'�����������')
INSERT INTO Genres VALUES(3, N'������� � ��������')
INSERT INTO Genres VALUES(4, N'������������ �����')
INSERT INTO Genres VALUES(5, N'���������� �����')
INSERT INTO Genres VALUES(6, N'�������')
INSERT INTO Genres VALUES(7, N'������ ������� ����')
INSERT INTO Genres VALUES(8, N'����� ��� �����')
INSERT INTO Genres VALUES(9, N'����������')
INSERT INTO Genres VALUES(10, N'�������')

INSERT INTO Sections VALUES(1, N'�������� ����������')
INSERT INTO Sections VALUES(2, N'�����������')
INSERT INTO Sections VALUES(3, N'������� ����������')
INSERT INTO Sections VALUES(4, N'�����')
INSERT INTO Sections VALUES(5, N'����������')
INSERT INTO Sections VALUES(6, N'��������')

INSERT INTO Cities VALUES(1, N'������')
INSERT INTO Cities VALUES(2, N'���������')
INSERT INTO Cities VALUES(3, N'������')
INSERT INTO Cities VALUES(4, N'����')
INSERT INTO Cities VALUES(5, N'��������')
INSERT INTO Cities VALUES(6, N'�������')
INSERT INTO Cities VALUES(7, N'�����')
INSERT INTO Cities VALUES(8, N'������')

INSERT INTO Countries VALUES(1, N'������', 1)
INSERT INTO Countries VALUES(2, N'������', 2)
INSERT INTO Countries VALUES(3, N'�������', 3)
INSERT INTO Countries VALUES(4, N'�������', 4)
INSERT INTO Countries VALUES(5, N'�������', 5)
INSERT INTO Countries VALUES(6, N'�������', 6)
INSERT INTO Countries VALUES(7, N'�������', 7)
INSERT INTO Countries VALUES(8, N'�������', 8)
INSERT INTO Countries VALUES(9, N'�������', NULL)
INSERT INTO Countries VALUES(10, N'���', NULL)
INSERT INTO Countries VALUES(11, N'��������������', NULL)
INSERT INTO Countries VALUES(12, N'������', NULL)
INSERT INTO Countries VALUES(13, N'������', NULL)
INSERT INTO Countries VALUES(14, N'��������� ������', NULL)

--����������� � ���������.�����������
INSERT INTO Authors VALUES(1, N'���� ����', 9)
INSERT INTO Authors VALUES(2, N'���� ����', 10)
--������� � ��������
INSERT INTO Authors VALUES(3, N'������ ������', 11)
--������������ �����
INSERT INTO Authors VALUES(4, N'��� �������', 1)
INSERT INTO Authors VALUES(5, N'������ ��������', 2)
--���������� �����
INSERT INTO Authors VALUES(6, N'����� �������', 9)
--�������
INSERT INTO Authors VALUES(7, N'������ ����', 10)
--������ ������� ����
INSERT INTO Authors VALUES(8, N'�������� ������', 12)
INSERT INTO Authors VALUES(9, N'����� �������', 11)
--����� ��� �����
INSERT INTO Authors VALUES(10, N'��������� ��������� ������', 2)
INSERT INTO Authors VALUES(11, N'������ ���������', 1)
--����������
INSERT INTO Authors VALUES(12, N'������ ���', 10)
INSERT INTO Authors VALUES(13, N'����� ������', 1)
--�������
INSERT INTO Authors VALUES(14, N'������ ����������', 13)
INSERT INTO Authors VALUES(15, N'��� ���� �����', 14)

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
INSERT INTO PublishHouses VALUES(2, N'����� ������', 3)
INSERT INTO PublishHouses VALUES(3, N'�����', 2)
INSERT INTO PublishHouses VALUES(4, N'Pabulum', 1)
INSERT INTO PublishHouses VALUES(5, N'���', 6)
INSERT INTO PublishHouses VALUES(6, N'��� ������������ ���', 6)

INSERT INTO Sellers VALUES(1, N'��� �����������', 3, 4)
INSERT INTO Sellers VALUES(2, N'����� ����������', 3, 1)
INSERT INTO Sellers VALUES(3, N'��� ���������', 3, 5)
INSERT INTO Sellers VALUES(4, N'���� �������������', 3, 7)
INSERT INTO Sellers VALUES(5, N'���� ������������', 3, 6)

INSERT INTO Buyers VALUES(1, N'���� ���������', 1, 5)
INSERT INTO Buyers VALUES(2, N'���� ����������', 3, 7)
INSERT INTO Buyers VALUES(3, N'����� ������������', 4, 4)
INSERT INTO Buyers VALUES(4, N'���� �����������', 5, 1)
INSERT INTO Buyers VALUES(5, N'����� ���������', 7, 2)

INSERT INTO Books VALUES(1, N'�������', 3, 14, 24, 200)
INSERT INTO Books VALUES(2, N'������� "������"' , 4, 6, 19, 300)
INSERT INTO Books VALUES(3, N'����������� ���� ������', 5, 2, 2, 400)
INSERT INTO Books VALUES(4, N'����', 1, 7, 20, 500)
INSERT INTO Books VALUES(5, N'������ � ���������', 2, 5, 18, 600)
INSERT INTO Books VALUES(6, N'������� ������', 2, 5, 18, 700)
INSERT INTO Books VALUES(7, N'��� �����',6, 15, 3, 800)

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

--1. ����� �������, ������� ����� � ��� �������, ��� �c�� ���� �� ���� �� ��������� �� ��������������� ����, ��������� � ��

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

--2. �������� �������������, ������� �������� ����� ������� ����� ��������
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
			WHERE Genres.[Name] = '������������ �����'
		)
	)
)
GO

--3. �������� ������������, ������� ��������� ������� ��� ���������� ��� ������ ���������.
--������������� ������� �� ������� � ������������ ������� � �� ��������� ��������� � ���������.

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

--4. �������� ������������� �������������, ������� ���������� ����� ���������� �����

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

--5. �������� ���������������� �������������, � ������� ��������������� ���������� ��� ������� ����� ������� ���������� � � ��� � �

CREATE VIEW AuthorsAbInfo
AS
SELECT Authors.Id, Authors.FullName, Countries.[Name]
FROM Authors, Countries
WHERE Authors.CountryFk = Countries.Id AND Authors.FullName LIKE '�%' OR Authors.FullName LIKE '�%'
GO

--6. �������� �������������, ������� � ������� ����������� ������� �������� ���������, ������� ��� �� ������� ����� ������ ������������

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
			WHERE PublishHouses.[Name] = '��� ������������ ���' 
		)
	)
)
GO