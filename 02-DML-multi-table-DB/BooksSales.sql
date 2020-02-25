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

INSERT INTO Genres VALUES(1, '����������� � ���������')
INSERT INTO Genres VALUES(2, '�����������')
INSERT INTO Genres VALUES(3, '������� � ��������')
INSERT INTO Genres VALUES(4, '������������ �����')
INSERT INTO Genres VALUES(5, '���������� �����')
INSERT INTO Genres VALUES(6, '�������')
INSERT INTO Genres VALUES(7, '������ ������� ����')
INSERT INTO Genres VALUES(8, '����� ��� �����')
INSERT INTO Genres VALUES(9, '����������')
INSERT INTO Genres VALUES(10, '�������')

INSERT INTO Sections VALUES(1, '�������� ����������')
INSERT INTO Sections VALUES(2, '�����������')
INSERT INTO Sections VALUES(3, '������� ����������')
INSERT INTO Sections VALUES(4, '�����')
INSERT INTO Sections VALUES(5, '����������')
INSERT INTO Sections VALUES(6, '��������')

--����������� � ���������.�����������
INSERT INTO Authors VALUES(1, '���� ����')
INSERT INTO Authors VALUES(2, '���� ����')
--������� � ��������
INSERT INTO Authors VALUES(3, '������ ������')
--������������ �����
INSERT INTO Authors VALUES(4, '��� �������')
INSERT INTO Authors VALUES(5, '������ ��������')
--���������� �����
INSERT INTO Authors VALUES(6, '����� �������')
--�������
INSERT INTO Authors VALUES(7, '������ ����')
--������ ������� ����
INSERT INTO Authors VALUES(8, '�������� ������')
INSERT INTO Authors VALUES(9, '����� �������')
--����� ��� �����
INSERT INTO Authors VALUES(10, '��������� ��������� ������')
INSERT INTO Authors VALUES(11, '������ ���������')
--����������
INSERT INTO Authors VALUES(12, '������ ���')
INSERT INTO Authors VALUES(13, '����� ������')
--�������
INSERT INTO Authors VALUES(14, '������ ����������')

INSERT INTO Cities VALUES(1, '������')
INSERT INTO Cities VALUES(2, '���������')
INSERT INTO Cities VALUES(3, '������')
INSERT INTO Cities VALUES(4, '����')
INSERT INTO Cities VALUES(5, '��������')
INSERT INTO Cities VALUES(6, '�������')
INSERT INTO Cities VALUES(7, '�����')

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