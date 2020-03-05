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
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (BuyerFk) REFERENCES Buyers(Id)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION,
	FOREIGN KEY (SellerFk) REFERENCES Sellers(Id)
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

--����������� � ���������.�����������
INSERT INTO Authors VALUES(1, N'���� ����')
INSERT INTO Authors VALUES(2, N'���� ����')
--������� � ��������
INSERT INTO Authors VALUES(3, N'������ ������')
--������������ �����
INSERT INTO Authors VALUES(4, N'��� �������')
INSERT INTO Authors VALUES(5, N'������ ��������')
--���������� �����
INSERT INTO Authors VALUES(6, N'����� �������')
--�������
INSERT INTO Authors VALUES(7, N'������ ����')
--������ ������� ����
INSERT INTO Authors VALUES(8, N'�������� ������')
INSERT INTO Authors VALUES(9, N'����� �������')
--����� ��� �����
INSERT INTO Authors VALUES(10, N'��������� ��������� ������')
INSERT INTO Authors VALUES(11, N'������ ���������')
--����������
INSERT INTO Authors VALUES(12, N'������ ���')
INSERT INTO Authors VALUES(13, N'����� ������')
--�������
INSERT INTO Authors VALUES(14, N'������ ����������')

INSERT INTO Cities VALUES(1, N'������')
INSERT INTO Cities VALUES(2, N'���������')
INSERT INTO Cities VALUES(3, N'������')
INSERT INTO Cities VALUES(4, N'����')
INSERT INTO Cities VALUES(5, N'��������')
INSERT INTO Cities VALUES(6, N'�������')
INSERT INTO Cities VALUES(7, N'�����')

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

INSERT INTO Books VALUES(1, N'�������', 3, 14, 24)
INSERT INTO Books VALUES(2, N'������� "������"' , 4, 6, 19)
INSERT INTO Books VALUES(3, N'����������� ���� ������', 5, 2, 2)
INSERT INTO Books VALUES(4, N'����', 1, 7, 20)
INSERT INTO Books VALUES(5, N'������ � ���������', 2, 5, 18)

INSERT INTO BooksSales VALUES(1, 1, 3, 1, 2)
INSERT INTO BooksSales VALUES(2, 2, 1, 3, 4)
INSERT INTO BooksSales VALUES(3, 5, 4, 2, 1)
INSERT INTO BooksSales VALUES(4, 3, 2, 1, 3)
INSERT INTO BooksSales VALUES(5, 4, 5, 4, 5)
GO

SELECT Title, Authors.FullName AS 'Authors Full Name', PublishHouses.[Name] AS 'Publish House',
Sections.[Name] AS 'Section', Genres.[Name] AS 'Genre',  BooksSales.SoldBooks AS 'Sold Books',
Sellers.FullNAme AS 'Seller`s Name', Buyers.FullName AS 'Buyer`s Name', Cities.Name AS 'City', PhoneNumbers.Number
FROM Books, Authors, PublishHouses, Sections, Genres, BooksSales, SectionsAndGenres, Buyers, Sellers, Cities, PhoneNumbers
WHERE BooksSales.BookFk = Books.Id AND
Books.AuthorFk = Authors.Id AND 
Books.PublishHouseFk = PublishHouses.Id AND
Books.SectionAndGenreFk = SectionsAndGenres.Id AND
SectionsAndGenres.SectionFk = Sections.Id AND
SectionsAndGenres.GenreFk = Genres.Id AND
BooksSales.BuyerFk = Buyers.Id AND 
BooksSales.SellerFk = Sellers.Id AND
Buyers.CityFk = Cities.Id AND
Buyers.PhoneNumberFk = PhoneNumbers.Id
