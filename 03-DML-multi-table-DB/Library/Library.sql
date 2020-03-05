-- Создаем базу данных

IF DB_ID('Library') IS NOT NULL
BEGIN
	USE master
    ALTER DATABASE Library SET single_user with rollback immediate;
    DROP DATABASE Library;
END
GO

CREATE DATABASE Library;
GO


-- Делаем созданную базу данных текущей

USE Library
GO


-- Создаем таблицы

-- 
-- Book Staff
-- 

CREATE TABLE Authors
(
	Id int NOT NULL PRIMARY KEY,
	FirstName varchar(25),
	LastName varchar(50)
)
GO

CREATE TABLE Themes
(
	Id int NOT NULL PRIMARY KEY,
	Name varchar(30)
)
GO

CREATE TABLE Presses
(
	Id int NOT NULL PRIMARY KEY,
	Name varchar(30)
)
GO

CREATE TABLE Categories
(
	Id int NOT NULL PRIMARY KEY,
	Name varchar(30)
)
GO

CREATE TABLE Books
(
	Id int NOT NULL PRIMARY KEY,
	Name varchar(100),
	Pages int,
	YearPress int,
	ThemeFk int,
	CategoryFk int,
	AuthorFk int,
	PressFk int,
	Comment varchar(50),
	Quantity int,

	FOREIGN KEY (ThemeFk) REFERENCES Themes(Id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	FOREIGN KEY (CategoryFk) REFERENCES Categories(Id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	FOREIGN KEY (AuthorFk) REFERENCES Authors(Id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	FOREIGN KEY (PressFk) REFERENCES Presses(Id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
)
GO


-- 
-- Teacher Stuff
-- 

CREATE TABLE Departments
(
	Id int NOT NULL PRIMARY KEY,
	Name varchar(40)
)
GO

CREATE TABLE Teachers
(
	Id int NOT NULL PRIMARY KEY,
	FirstName varchar(25),
	LastName varchar(35),
	DepartmentFk int,

	FOREIGN KEY (DepartmentFk) REFERENCES Departments(Id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
)
GO



-- 
-- Student Staff
-- 

CREATE TABLE Faculties
(
	Id int NOT NULL PRIMARY KEY,
	Name varchar(20)
)
GO

CREATE TABLE Groups
(
	Id int NOT NULL PRIMARY KEY,
	Name varchar(10),
	FacultyFk int,

	FOREIGN KEY (FacultyFk) REFERENCES Faculties(Id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
)
GO

CREATE TABLE Students
(
	Id int NOT NULL PRIMARY KEY,
	FirstName varchar(25),
	LastName varchar(35),
	GroupFk int,
	Term int,

	FOREIGN KEY (GroupFk) REFERENCES Groups(Id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
)
GO


-- 
-- Library Stuff
-- 

CREATE TABLE Libs
(
	Id int NOT NULL PRIMARY KEY,
	FirstName varchar(25),
	LastName varchar(35)
)
GO

CREATE TABLE StudentCards
(
	Id int NOT NULL PRIMARY KEY,
	StudentFk int NOT NULL,
	BookFk int NOT NULL,
	DateOut date,
	DateIn date,
	LibFk int NOT NULL,

	FOREIGN KEY (StudentFk) REFERENCES Students(Id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	FOREIGN KEY (BookFk) REFERENCES Books(Id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	FOREIGN KEY (LibFk) REFERENCES Libs(Id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
)
GO

CREATE TABLE TeacherCards
(
	Id int NOT NULL PRIMARY KEY,
	TeacherFk int NOT NULL,
	BookFk int NOT NULL,
	DateOut date,
	DateIn date,
	LibFk int NOT NULL,

	FOREIGN KEY (TeacherFk) REFERENCES Teachers(Id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	FOREIGN KEY (BookFk) REFERENCES Books(Id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
	FOREIGN KEY (LibFk) REFERENCES Libs(Id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
)
GO


-- Заполняем таблицы

INSERT Authors (Id, FirstName, LastName) VALUES (1, N'Джеймс Р.', N'Грофф')
INSERT Authors (Id, FirstName, LastName) VALUES (2, N'Сергей', N'Никольский')
INSERT Authors (Id, FirstName, LastName) VALUES (3, N'Михаил', N'Маров')
INSERT Authors (Id, FirstName, LastName) VALUES (4, N'Борис', N'Карпов')
INSERT Authors (Id, FirstName, LastName) VALUES (5, N'Алексей', N'Архангельский')
INSERT Authors (Id, FirstName, LastName) VALUES (6, N'Владимир', N'Король')
INSERT Authors (Id, FirstName, LastName) VALUES (7, N'Евангелос', N'Петрусос')
INSERT Authors (Id, FirstName, LastName) VALUES (8, N'Маркус', N'Херхагер')
INSERT Authors (Id, FirstName, LastName) VALUES (9, N'Павел', N'Гарбар')
INSERT Authors (Id, FirstName, LastName) VALUES (10, N'Александр', N'Матросов')
INSERT Authors (Id, FirstName, LastName) VALUES (11, N'Людмила', N'Омельченко')
INSERT Authors (Id, FirstName, LastName) VALUES (12, N'Кевин', N'Рейчард')
INSERT Authors (Id, FirstName, LastName) VALUES (13, N'Ольга', N'Кокорева')
INSERT Authors (Id, FirstName, LastName) VALUES (14, N'Марк', N'Браун')
GO

INSERT Themes (Id, Name) VALUES (1, N'Базы данных')
INSERT Themes (Id, Name) VALUES (2, N'Программирование')
INSERT Themes (Id, Name) VALUES (3, N'Графические пакеты')
INSERT Themes (Id, Name) VALUES (4, N'Высшая математика')
INSERT Themes (Id, Name) VALUES (5, N'Математические пакеты')
INSERT Themes (Id, Name) VALUES (6, N'Сети')
INSERT Themes (Id, Name) VALUES (7, N'Web-дизайн')
INSERT Themes (Id, Name) VALUES (8, N'Windows 2000')
INSERT Themes (Id, Name) VALUES (9, N'Операционные системы')
GO

INSERT Presses (Id, Name) VALUES (1, N'DiaSoft')
INSERT Presses (Id, Name) VALUES (2, N'BHV')
INSERT Presses (Id, Name) VALUES (3, N'Питер')
INSERT Presses (Id, Name) VALUES (4, N'Бином')
INSERT Presses (Id, Name) VALUES (5, N'Наука')
INSERT Presses (Id, Name) VALUES (6, N'Кудиц-Образ')
INSERT Presses (Id, Name) VALUES (7, N'Диалектика')
GO

INSERT Categories (Id, Name) VALUES (1, N'Язык SQL')
INSERT Categories (Id, Name) VALUES (2, N'Математический анализ')
INSERT Categories (Id, Name) VALUES (3, N'C++ Builder')
INSERT Categories (Id, Name) VALUES (4, N'Delphi')
INSERT Categories (Id, Name) VALUES (5, N'Visual Basic')
INSERT Categories (Id, Name) VALUES (6, N'3D Studio Max')
INSERT Categories (Id, Name) VALUES (7, N'Mathcad')
INSERT Categories (Id, Name) VALUES (8, N'Novell')
INSERT Categories (Id, Name) VALUES (9, N'Perl')
INSERT Categories (Id, Name) VALUES (10, N'FrontPage')
INSERT Categories (Id, Name) VALUES (11, N'Visual FoxPro')
INSERT Categories (Id, Name) VALUES (12, N'Windows 2000')
INSERT Categories (Id, Name) VALUES (13, N'Unix')
INSERT Categories (Id, Name) VALUES (14, N'HTML')
GO

INSERT Books (Id, Name, Pages, YearPress, ThemeFk, CategoryFk, AuthorFk, PressFk, Comment, Quantity) VALUES (1, N'SQL', 816, 2001, 1, 1, 1, 2, N'2-е издание', 2)
INSERT Books (Id, Name, Pages, YearPress, ThemeFk, CategoryFk, AuthorFk, PressFk, Comment, Quantity) VALUES (2, N'3D Studio Max 3', 640, 2000, 3, 6, 3, 3, N'Учебный курс', 3)
INSERT Books (Id, Name, Pages, YearPress, ThemeFk, CategoryFk, AuthorFk, PressFk, Comment, Quantity) VALUES (3, N'100 компонентов общего назначения библиотеки Delphi 5', 272, 1999, 2, 4, 5, 4, N'Компоненты', 1)
INSERT Books (Id, Name, Pages, YearPress, ThemeFk, CategoryFk, AuthorFk, PressFk, Comment, Quantity) VALUES (4, N'Visual Basic 6', 416, 2000, 2, 5, 4, 3, N'Специальный справочник', 1)
INSERT Books (Id, Name, Pages, YearPress, ThemeFk, CategoryFk, AuthorFk, PressFk, Comment, Quantity) VALUES (5, N'Курс математического анализа', 328, 1990, 4, 2, 2, 5, N'1-й том', 1)
INSERT Books (Id, Name, Pages, YearPress, ThemeFk, CategoryFk, AuthorFk, PressFk, Comment, Quantity) VALUES (6, N'Библиотека C++ Builder 5: 70 компонентов ввода/вывода информации', 288, 2000, 2, 3, 5, 4, N'Компоненты', 1)
INSERT Books (Id, Name, Pages, YearPress, ThemeFk, CategoryFk, AuthorFk, PressFk, Comment, Quantity) VALUES (7, N'Интегрированная среда разработки', 272, 2000, 2, 3, 5, 4, N'Среда разработки', 2)
INSERT Books (Id, Name, Pages, YearPress, ThemeFk, CategoryFk, AuthorFk, PressFk, Comment, Quantity) VALUES (8, N'Русская справка (Help) по Delphi 5 и  Object Pascal', 32, 2000, 2, 4, 5, 4, N'Справочник', 1)
INSERT Books (Id, Name, Pages, YearPress, ThemeFk, CategoryFk, AuthorFk, PressFk, Comment, Quantity) VALUES (9, N'Visual Basic 6.0 for Application', 488, 2000, 2, 5, 6, 6, N'Справочник с примерами', 3)
INSERT Books (Id, Name, Pages, YearPress, ThemeFk, CategoryFk, AuthorFk, PressFk, Comment, Quantity) VALUES (10, N'Visual Basic 6', 576, 2000, 2, 5, 7, 2, N'Руководство разработчика 1-й том', 1)
INSERT Books (Id, Name, Pages, YearPress, ThemeFk, CategoryFk, AuthorFk, PressFk, Comment, Quantity) VALUES (11, N'Mathcad 2000', 416, 2000, 5, 7, 8, 2, N'Полное руководство', 1)
INSERT Books (Id, Name, Pages, YearPress, ThemeFk, CategoryFk, AuthorFk, PressFk, Comment, Quantity) VALUES (12, N'Novell GroupWise 5.5 система электронной почты и коллективной работы', 480, 2000, 6, 8, 9, 2, N'Сетевые пакеты', 2)
INSERT Books (Id, Name, Pages, YearPress, ThemeFk, CategoryFk, AuthorFk, PressFk, Comment, Quantity) VALUES (13, N'Реестр Windows 2000', 352, 2000, 9, 12, 13, 2, N'Руководство для профессионалов', 4)
INSERT Books (Id, Name, Pages, YearPress, ThemeFk, CategoryFk, AuthorFk, PressFk, Comment, Quantity) VALUES (14, N'Unix справочник', 384, 1999, 9, 13, 12, 3, N'Справочное руководство', 1)
INSERT Books (Id, Name, Pages, YearPress, ThemeFk, CategoryFk, AuthorFk, PressFk, Comment, Quantity) VALUES (15, N'Самоучитель Visual FoxPro 6.0', 512, 1999, 1, 11, 11, 2, N'Самоучитель', 1)
INSERT Books (Id, Name, Pages, YearPress, ThemeFk, CategoryFk, AuthorFk, PressFk, Comment, Quantity) VALUES (16, N'Самоучитель FrontPage 2000', 512, 1999, 7, 10, 11, 2, N'Самоучитель', 1)
INSERT Books (Id, Name, Pages, YearPress, ThemeFk, CategoryFk, AuthorFk, PressFk, Comment, Quantity) VALUES (17, N'Самоучитель Perl', 432, 2000, 2, 9, 10, 2, N'Самоучитель', 2)
INSERT Books (Id, Name, Pages, YearPress, ThemeFk, CategoryFk, AuthorFk, PressFk, Comment, Quantity) VALUES (18, N'HTML 3.2', 1040, 2000, 7, 14, 14, 2, N'Руководство', 5)
GO

INSERT Departments (Id, Name) VALUES (1, N'Программерства')
INSERT Departments (Id, Name) VALUES (2, N'Графики и Дизайна')
INSERT Departments (Id, Name) VALUES (3, N'Железа и Администрирования')
GO

INSERT Teachers (Id, FirstName, LastName, DepartmentFk) VALUES (1, N'Григорий', N'Ящук', 1)
INSERT Teachers (Id, FirstName, LastName, DepartmentFk) VALUES (2, N'Алекс', N'Туманов', 1)
INSERT Teachers (Id, FirstName, LastName, DepartmentFk) VALUES (3, N'Сергей', N'Максименко', 2)
INSERT Teachers (Id, FirstName, LastName, DepartmentFk) VALUES (4, N'Дмитрий', N'Боровский', 2)
INSERT Teachers (Id, FirstName, LastName, DepartmentFk) VALUES (5, N'Виктор', N'Бровар', 2)
INSERT Teachers (Id, FirstName, LastName, DepartmentFk) VALUES (6, N'Вадим', N'Ткаченко', 3)
INSERT Teachers (Id, FirstName, LastName, DepartmentFk) VALUES (7, N'Вячеслав', N'Калашников', 3)
INSERT Teachers (Id, FirstName, LastName, DepartmentFk) VALUES (8, N'Руслан', N'Кучеренко', 1)
INSERT Teachers (Id, FirstName, LastName, DepartmentFk) VALUES (9, N'Андрей', N'Тендюк', 1)
INSERT Teachers (Id, FirstName, LastName, DepartmentFk) VALUES (10, N'Анатолий', N'Выклюк', 2)
INSERT Teachers (Id, FirstName, LastName, DepartmentFk) VALUES (11, N'Олег', N'Резниченко', 3)
INSERT Teachers (Id, FirstName, LastName, DepartmentFk) VALUES (12, N'Александр', N'Артемов', 1)
GO

INSERT Faculties (Id, Name) VALUES (1, N'Программирования')
INSERT Faculties (Id, Name) VALUES (2, N'Веб-дизайна')
INSERT Faculties (Id, Name) VALUES (3, N'Администрирования')
GO

INSERT Groups (Id, Name, FacultyFk) VALUES (2, N'9П1', 1)
INSERT Groups (Id, Name, FacultyFk) VALUES (3, N'9П2', 1)
INSERT Groups (Id, Name, FacultyFk) VALUES (4, N'9А', 3)
INSERT Groups (Id, Name, FacultyFk) VALUES (5, N'9Д', 2)
INSERT Groups (Id, Name, FacultyFk) VALUES (6, N'14А', 3)
INSERT Groups (Id, Name, FacultyFk) VALUES (7, N'19П1', 1)
INSERT Groups (Id, Name, FacultyFk) VALUES (8, N'18П2', 1)
INSERT Groups (Id, Name, FacultyFk) VALUES (9, N'18А', 3)
INSERT Groups (Id, Name, FacultyFk) VALUES (10, N'19Д', 2)
GO

INSERT Students (Id, FirstName, LastName, GroupFk, Term) VALUES (2, N'Вячеслав', N'Зезик', 8, 2)
INSERT Students (Id, FirstName, LastName, GroupFk, Term) VALUES (3, N'Ольга', N'Мантуляк', 8, 2)
INSERT Students (Id, FirstName, LastName, GroupFk, Term) VALUES (4, N'Ольга', N'Хренова', 8, 2)
INSERT Students (Id, FirstName, LastName, GroupFk, Term) VALUES (5, N'Ольга', N'Медведева', 8, 2)
INSERT Students (Id, FirstName, LastName, GroupFk, Term) VALUES (6, N'Галина', N'Инащенко', 8, 2)
INSERT Students (Id, FirstName, LastName, GroupFk, Term) VALUES (7, N'Юрий', N'Минаев', 8, 2)
INSERT Students (Id, FirstName, LastName, GroupFk, Term) VALUES (8, N'Юрий', N'Домовесов', 8, 2)
INSERT Students (Id, FirstName, LastName, GroupFk, Term) VALUES (9, N'Руслан', N'Ярмолович', 8, 2)
INSERT Students (Id, FirstName, LastName, GroupFk, Term) VALUES (10, N'Игорь', N'Удовик', 8, 2)
INSERT Students (Id, FirstName, LastName, GroupFk, Term) VALUES (11, N'Петр', N'Кацевич', 8, 2)
INSERT Students (Id, FirstName, LastName, GroupFk, Term) VALUES (12, N'Евгений', N'Бурцев', 3, 2)
INSERT Students (Id, FirstName, LastName, GroupFk, Term) VALUES (13, N'Флора', N'Побирская', 3, 2)
INSERT Students (Id, FirstName, LastName, GroupFk, Term) VALUES (14, N'Наталья', N'Гридина', 3, 2)
INSERT Students (Id, FirstName, LastName, GroupFk, Term) VALUES (15, N'Елена', N'Акусова', 3, 2)
INSERT Students (Id, FirstName, LastName, GroupFk, Term) VALUES (16, N'Светлана', N'Горшкова', 9, 2)
INSERT Students (Id, FirstName, LastName, GroupFk, Term) VALUES (17, N'Александр', N'Любенко', 10, 2)
INSERT Students (Id, FirstName, LastName, GroupFk, Term) VALUES (18, N'Евгения', N'Цимбалюк', 10, 2)
INSERT Students (Id, FirstName, LastName, GroupFk, Term) VALUES (19, N'Ольга', N'Болячевская', 5, 2)
INSERT Students (Id, FirstName, LastName, GroupFk, Term) VALUES (20, N'Станислав', N'Плешаков', 7, 2)
INSERT Students (Id, FirstName, LastName, GroupFk, Term) VALUES (21, N'Елена', N'Таран', 4, 2)
INSERT Students (Id, FirstName, LastName, GroupFk, Term) VALUES (22, N'Денис', N'Рогачевский', 6, 2)
INSERT Students (Id, FirstName, LastName, GroupFk, Term) VALUES (23, N'Оксана', N'Тихонова', 6, 2)
INSERT Students (Id, FirstName, LastName, GroupFk, Term) VALUES (24, N'Петр', N'Максимов', 3, 2)
INSERT Students (Id, FirstName, LastName, GroupFk, Term) VALUES (25, N'Ирина', N'Стогнеева', 5, 2)
GO

INSERT Libs (Id, FirstName, LastName) VALUES (1, N'Сергей', N'Максименко')
INSERT Libs (Id, FirstName, LastName) VALUES (2, N'Дмитрий', N'Чеботарев')
GO

INSERT StudentCards (Id, StudentFk, BookFk, DateOut, DateIn, LibFk) VALUES (1, 2, 1, CAST(N'2001-05-17' AS date), CAST(N'2001-06-12' AS date), 1)
INSERT StudentCards (Id, StudentFk, BookFk, DateOut, DateIn, LibFk) VALUES (2, 17, 18, CAST(N'2000-05-18' AS date), NULL, 1)
INSERT StudentCards (Id, StudentFk, BookFk, DateOut, DateIn, LibFk) VALUES (3, 6, 3, CAST(N'2001-04-21' AS date), NULL, 2)
INSERT StudentCards (Id, StudentFk, BookFk, DateOut, DateIn, LibFk) VALUES (4, 21, 4, CAST(N'2001-03-26' AS date), NULL, 2)
INSERT StudentCards (Id, StudentFk, BookFk, DateOut, DateIn, LibFk) VALUES (5, 3, 1, CAST(N'2000-05-07' AS date), CAST(N'2001-04-12' AS date), 1)
INSERT StudentCards (Id, StudentFk, BookFk, DateOut, DateIn, LibFk) VALUES (6, 7, 11, CAST(N'2001-06-02' AS date), NULL, 2)
INSERT StudentCards (Id, StudentFk, BookFk, DateOut, DateIn, LibFk) VALUES (7, 16, 14, CAST(N'2001-04-05' AS date), NULL, 1)
INSERT StudentCards (Id, StudentFk, BookFk, DateOut, DateIn, LibFk) VALUES (8, 11, 6, CAST(N'2001-05-05' AS date), NULL, 2)
INSERT StudentCards (Id, StudentFk, BookFk, DateOut, DateIn, LibFk) VALUES (9, 17, 2, CAST(N'2001-10-01' AS date), NULL, 2)
INSERT StudentCards (Id, StudentFk, BookFk, DateOut, DateIn, LibFk) VALUES (10, 10, 13, CAST(N'2001-05-05' AS date), NULL, 1)
GO

INSERT TeacherCards (Id, TeacherFk, BookFk, DateOut, DateIn, LibFk) VALUES (1, 2, 13, CAST(N'2000-01-01' AS date), CAST(N'2001-07-04' AS date), 1)
INSERT TeacherCards (Id, TeacherFk, BookFk, DateOut, DateIn, LibFk) VALUES (2, 10, 2, CAST(N'2000-03-03' AS date), NULL, 1)
INSERT TeacherCards (Id, TeacherFk, BookFk, DateOut, DateIn, LibFk) VALUES (3, 6, 12, CAST(N'2000-06-04' AS date), NULL, 2)
INSERT TeacherCards (Id, TeacherFk, BookFk, DateOut, DateIn, LibFk) VALUES (4, 3, 1, CAST(N'2000-09-05' AS date), NULL, 1)
INSERT TeacherCards (Id, TeacherFk, BookFk, DateOut, DateIn, LibFk) VALUES (5, 8, 8, CAST(N'2000-05-05' AS date), NULL, 2)
INSERT TeacherCards (Id, TeacherFk, BookFk, DateOut, DateIn, LibFk) VALUES (6, 5, 18, CAST(N'2001-02-02' AS date), NULL, 2)
INSERT TeacherCards (Id, TeacherFk, BookFk, DateOut, DateIn, LibFk) VALUES (7, 12, 17, CAST(N'2001-03-04' AS date), NULL, 1)
INSERT TeacherCards (Id, TeacherFk, BookFk, DateOut, DateIn, LibFk) VALUES (8, 4, 18, CAST(N'2000-07-02' AS date), NULL, 1)
GO

 --1. Вывести информацию о книге с наибольшим количеством страниц.

SELECT Books.[Name], Books.Pages
FROM Books
	WHERE Pages =
	(
		SELECT MAX(Pages)
		FROM Books
	)

 --2. Вывести информацию о книге по программированию с наибольшим количеством страниц.

SELECT Books.[Name], Books.Pages
FROM Books
WHERE Pages =
(
	SELECT MAX(Pages)
	FROM Books
		WHERE ThemeFk =
		(
			  SELECT Id
			  FROM Themes
			  WHERE Name = 'Программирование'
		)
)

 --3. Вывести статистику посещений библиотеки по каждой группе студентов.

SELECT Groups.[Name], COUNT(StudentCards.DateOut) AS 'Visits'
FROM Students, Groups, StudentCards
WHERE Students.GroupFk = Groups.Id 
AND Students.Id = StudentCards.StudentFk
GROUP BY Groups.[Name]

 --4. Вывести количество книг, взятых в библиотеке программистами по тематикам
 --   «Программирование» и «Базы данных», и сумму страниц в этих книгах.

SELECT COUNT(Books.Id) AS 'Amount of books', SUM(Books.Pages) AS 'Amount of pages'
FROM StudentCards, Students, Groups, Books
WHERE StudentCards.StudentFk = Students.Id 
AND StudentCards.BookFk = Books.Id 
AND Students.GroupFk = Groups.Id 
AND Groups.FacultyFk = 
(
	SELECT Faculties.Id
	FROM Faculties
	WHERE Faculties.[Name] = 'Программирования'
)
AND StudentCards.BookFk IN
(
	SELECT Books.Id
	FROM Books
	WHERE  Books.ThemeFk IN
	(
		SELECT Themes.Id
		FROM Themes
		WHERE Themes.[Name] = 'Программирование' OR Themes.[Name] = 'Базы Данных' 
	)
)

 --5. Допустим, что студент имеет право держать книгу у себя дома только 1 месяц,
 --   а за каждую неделю сверх того он обязан «выставить» уважаемому библиотекарю Сергею Максименко
 --   полбутылки (емкость бутылки 0.5 л) светлого пива. Необходимо вывести сколько литров
 --   должен каждый студент, а также суммарное количество литров пива. Итоговая сумма должна
 --   округляться в большую сторону, то есть суммарное число литров должно быть целым.
 --   Используйте функции DATEDIFF и CAST.

SELECT Students.FirstName, StudentCards.DateOut, StudentCards.DateIn,
((DATEDIFF(week, StudentCards.DateOut, StudentCards.DateIn)-4)*0.25) AS 'Beer', t.[Summary Beer]
FROM 
(SELECT CAST(SUM(((DATEDIFF(week, StudentCards.DateOut, StudentCards.DateIn)-4)*0.25)) AS NUMERIC) AS 'Summary Beer'
FROM Students, StudentCards
WHERE StudentCards.StudentFk = Students.Id 
AND DATEDIFF(month, StudentCards.DateOut, StudentCards.DateIn) > 1)t,
Students,
StudentCards
WHERE StudentCards.StudentFk = Students.Id 
AND DATEDIFF(month, StudentCards.DateOut, StudentCards.DateIn) > 1
GROUP BY Students.FirstName, StudentCards.DateOut, StudentCards.DateIn, t.[Summary Beer]

SELECT CAST(SUM(((DATEDIFF(week, StudentCards.DateOut, StudentCards.DateIn)-4)*0.25)) AS NUMERIC) AS 'Summary Beer'
FROM Students, StudentCards
WHERE StudentCards.StudentFk = Students.Id 
AND DATEDIFF(month, StudentCards.DateOut, StudentCards.DateIn) > 1

  --6. Если считать общее количество книг в библиотеке за 100%, то необходимо подсчитать
  --  сколько книг (в процентном отношении) брал каждый факультет.

SELECT [TableTaken].[Facult], [TableTaken].[Count]*100.0/[TableAll].[count] AS 'Percent of taken books' FROM
(SELECT COUNT(Books.Id) 'Count'
FROM Books) [TableAll],
(SELECT COUNT(StudentCards.BookFk) 'Count', Faculties.[Name] AS 'Facult'
FROM Faculties, Groups, Books, Students, StudentCards
WHERE Faculties.Id = Groups.FacultyFk 
AND Students.GroupFk = Groups.Id 
AND StudentCards.StudentFk = Students.Id 
AND StudentCards.BookFk = Books.Id
GROUP BY Faculties.[Name]) [TableTaken]
GROUP BY [TableAll].[Count], [TableTaken].[Count], [TableTaken].[Facult]

SELECT Faculties.Name, COUNT(StudentCards.BookFk)*100.0/(SELECT COUNT(Books.Id) FROM Books) AS 'Percent of taken books'
FROM Faculties, Groups, Students, StudentCards
WHERE StudentCards.StudentFk = Students.Id
AND Students.GroupFk = Groups.Id
AND Groups.FacultyFk = Faculties.Id
GROUP BY Faculties.[Name]

 --7. Вывести самого популярного автора(ов) среди студентов.

SELECT Authors.FirstName, Authors.LastName
FROM Authors, Books, StudentCards
WHERE Authors.Id = Books.AuthorFk 
AND StudentCards.BookFk = Books.Id 
GROUP BY Authors.FirstName, Authors.LastName
HAVING COUNT(Books.[Name]) =
(SELECT MAX([CountTakenBooks].[Count]) AS 'Times taken' 
FROM 
(
    SELECT COUNT(Books.[Name]) [Count]
	FROM Authors, Books, StudentCards
	WHERE Authors.Id = Books.AuthorFk 
	AND StudentCards.BookFk = Books.Id 
	GROUP BY Authors.FirstName, Authors.LastName
)[CountTakenBooks])

-- 8. Вывести самого популярного автора(ов) среди преподавателей и количество книг
--    этого автора, взятых в библиотеке.
SELECT COUNT(TeacherCards.BookFk) AS 'Times Taken from library', Authors.FirstName, Authors.LastName, Books.[Name]
FROM TeacherCards, Authors, Books
WHERE TeacherCards.BookFk=Books.Id 
AND Books.AuthorFk=Authors.Id 
AND TeacherCards.BookFk IN
(SELECT Books.Id
 FROM Books
	WHERE Books.AuthorFk IN
		(SELECT Authors.Id 
		FROM Authors, Books, TeacherCards
		WHERE Authors.Id = Books.AuthorFk 
		AND TeacherCards.BookFk = Books.Id 
		GROUP BY  Authors.Id, Authors.FirstName, Authors.LastName
		HAVING COUNT(Books.[Name]) =	
			(SELECT MAX([CountTakenBooks].[Count]) AS 'Times taken' FROM 
				(SELECT COUNT(Books.[Name]) [Count]
			FROM Authors, Books, TeacherCards
			WHERE Authors.Id = Books.AuthorFk 
			AND TeacherCards.BookFk = Books.Id 
			GROUP BY Authors.FirstName, Authors.LastName)[CountTakenBooks])))
GROUP BY Authors.FirstName, Authors.LastName, Books.[Name]

-- 9. Вывести самого популярную(ые) тематику(и) среди студентов и преподавателей.
SELECT [CountTakenBooksS].[Theme], [CountTakenBooksS].[Count1] + [CountTakenBooksT].[Count2] [SumOfTakenBooks]
	FROM (SELECT COUNT(Themes.[Name]) [Count1], Themes.[Name] [Theme], Themes.Id [Id1]
		  FROM  Books, StudentCards, Themes
		  WHERE StudentCards.BookFk = Books.Id
		  AND Themes.Id = Books.ThemeFk
		  GROUP BY Themes.[Name], Themes.[Id]) [CountTakenBooksS],
		  (SELECT COUNT(Themes.[Name]) [Count2], Themes.[Name] [Theme], Themes.Id [Id2]
		  FROM  Books, TeacherCards, Themes
		  WHERE TeacherCards.BookFk = Books.Id
		  AND Themes.Id = Books.ThemeFk
		  GROUP BY Themes.[Name], Themes.Id)[CountTakenBooksT]
	WHERE [CountTakenBooksS].[Id1] = [CountTakenBooksT].[Id2] AND [CountTakenBooksS].[Count1] + [CountTakenBooksT].[Count2] = 
(SELECT MAX([SumBooks].[SumOfTakenBooks]) AS 'MaxThemes'
FROM (SELECT [CountTakenBooksS].[Theme], [CountTakenBooksS].[Count1] + [CountTakenBooksT].[Count2] [SumOfTakenBooks],
	[CountTakenBooksS].[Count1],  [CountTakenBooksT].[Count2], CountTakenBooksS.Id1, CountTakenBooksT.Id2
	FROM (SELECT COUNT(Themes.[Name]) [Count1], Themes.[Name] [Theme], Themes.Id [Id1]
		  FROM  Books, StudentCards, Themes
		  WHERE StudentCards.BookFk = Books.Id
		  AND Themes.Id = Books.ThemeFk
		  GROUP BY Themes.[Name], Themes.[Id]) [CountTakenBooksS],
		  (SELECT COUNT(Themes.[Name]) [Count2], Themes.[Name] [Theme], Themes.Id [Id2]
		  FROM  Books, TeacherCards, Themes
		  WHERE TeacherCards.BookFk = Books.Id
		  AND Themes.Id = Books.ThemeFk
		  GROUP BY Themes.[Name], Themes.Id)[CountTakenBooksT]
	WHERE [CountTakenBooksS].[Id1] = [CountTakenBooksT].[Id2]
	GROUP BY [CountTakenBooksS].[Theme],
	[CountTakenBooksS].[Count1],
	[CountTakenBooksT].[Theme],
	[CountTakenBooksT].[Count2],
	[CountTakenBooksS].[Id1],
	[CountTakenBooksT].[Id2]) [SumBooks]
WHERE SumBooks.Id1 = SumBooks.Id2 ) 

--10. «Заставить» сдать книги тех студентов, которые не сдавали книги более года,
--    т.е. в таблице «Карточка студентов» (StudentCards) заполнить поле «Дата возврата»
--    (DateIn) текущей датой.

UPDATE StudentCards 
SET StudentCards.DateIn = GETDATE()  
WHERE DATEDIFF(YEAR, StudentCards.DateOut, StudentCards.DateIn) > 0

--Проверка
--SELECT StudentCards.DateOut, StudentCards.DateIn
--FROM StudentCards
--WHERE DATEDIFF(YEAR, StudentCards.DateOut, StudentCards.DateIn) > 0
--GROUP BY StudentCards.DateIn, StudentCards.DateOut

--11.	Удалить из таблицы «Карточка студентов» студентов, которые уже вернули книги.
DELETE FROM StudentCards
WHERE StudentCards.DateIn IS NOT NULL
--Почему не работало != ?