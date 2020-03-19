USE Library
GO

--Хранимые процедуры:
--1. Написать хранимую процедуру, выводящую на экран список студентов,
--   не сдавших книги.


CREATE PROC StudentsNotGivenBooks
AS
BEGIN
SELECT Students.FirstName, Students.LastName
FROM Students
WHERE Students.Id IN 
(
	SELECT StudentCards.StudentFk
	FROM StudentCards
	WHERE StudentCards.DateIn IS NULL
)
END
GO

EXEC StudentsNotGivenBooks
GO

--2. Написать хранимую процедуру, возвращающую имя и фамилию библиотекаря,
--   выдавшего наибольшее кол-во книг.

CREATE PROC LibMaxBooks
AS
BEGIN
SELECT Libs.FirstName, Libs.LastName
FROM Libs
WHERE Libs.Id IN
(
	SELECT StudentCards.LibFk
	FROM (SELECT TeacherCards.LibFk,
	COUNT(TeacherCards.LibFk) [countLibs]
	FROM TeacherCards
	GROUP BY TeacherCards.LibFk)T,
	StudentCards
	WHERE StudentCards.LibFk = T.LibFk 
	GROUP BY StudentCards.LibFk, T.LibFk, T.countLibs
	HAVING COUNT(StudentCards.LibFk) + T.countLibs IN
	(
		SELECT MAX(FindMax.Summary) [Max]
		FROM (SELECT StudentCards.LibFk, COUNT(StudentCards.LibFk) AS cnt,
		T.countLibs, COUNT(StudentCards.LibFk) + T.countLibs [Summary]
		FROM (SELECT TeacherCards.LibFk,
		COUNT(TeacherCards.LibFk) [countLibs]
		FROM TeacherCards
		GROUP BY TeacherCards.LibFk)T,
		StudentCards
		WHERE StudentCards.LibFk = T.LibFk
		GROUP BY StudentCards.LibFk, T.LibFk, T.countLibs)FindMax
	)
)
END
GO

EXEC LibMaxBooks
GO

--3. Написать хранимую процедуру, подсчитывающую факториал числа.
CREATE PROC Factorial @number INT
AS
BEGIN 

DECLARE @factorial INT
SET @factorial = 1;
WHILE @number > 0
    BEGIN
        SET @factorial = @factorial * @number
        SET @number = @number - 1
    END;
 
PRINT @factorial
END
GO

EXEC Factorial 5
GO

--Функции:
--1. Функцию, возвращающую кол-во студентов, которые не брали книги.

CREATE FUNCTION dbo.StudentsNotTakenBooks()
RETURNS INT
AS 
BEGIN 
DECLARE @cntStudents INT;

SELECT @cntStudents = COUNT(Students.Id)
FROM Students
WHERE Students.Id NOT IN
(
	SELECT StudentCards.StudentFk
	FROM StudentCards
)

RETURN @cntStudents;
END
GO

SELECT dbo.StudentsNotTakenBooks() AS 'Number of students who didn`t take books'
GO

--2. Функцию, возвращающую минимальное из трех переданных параметров.

CREATE FUNCTION dbo.MinParam(@param1 FLOAT, @param2 FLOAT, @param3 FLOAT)
RETURNS FLOAT
AS 
BEGIN
    DECLARE @Params TABLE (numbers FLOAT)
    DECLARE @MinValue FLOAT
    
    INSERT INTO @Params     (numbers)
    VALUES(@param1), (@param2), (@param3) 
    
    SELECT @MinValue = MIN(p.numbers) FROM @Params p
    RETURN @MinValue
END
GO

SELECT dbo.MinParam(2, 10.5, 5.1) AS 'The smallest of the numbers'
GO

--3. Функцию, которая принимает в качестве параметра двухразрядное число
--   и определяет какой из разрядов больше, либо они равны.
--   (Используйте % - остаток о деления. Например: 57 % 10 = 7.)

CREATE FUNCTION dbo.TensOrUnits(@number INT)
RETURNS VARCHAR(51)
AS 
BEGIN
    IF(@number/10 > @number%10)
		RETURN 'Десятки больше единиц.'
	IF(@number/10 < @number%10)
		RETURN 'Единицы больше десятков.'
	IF(@number/10 = @number%10)
		RETURN 'Единицы равны десяткам.'
	RETURN 'Неверное входное значение.'
END
GO

SELECT dbo.TensOrUnits(57) AS 'Единицы или десятки?'
SELECT dbo.TensOrUnits(75) AS 'Единицы или десятки?'
SELECT dbo.TensOrUnits(55) AS 'Единицы или десятки?'
GO

--4. Функцию, возвращающую кол-во взятых книг по каждой из групп и
--по каждой из кафедр (departments).

 CREATE FUNCTION dbo.BooksGroupsAndDep()
 RETURNS @resTable TABLE
 (
 countBooks INT NOT NULL,
 authorsName NVARCHAR(100) NOT NULL
 )
 AS
 BEGIN
	 WITH temp (BookId, GroupName)
	 AS
	 (
	 SELECT Books.Id, Groups.[Name]
	 FROM Books, StudentCards, Groups, Students
	 WHERE StudentCards.BookFk = Books.Id AND Students.Id = StudentCards.StudentFk AND Groups.Id = Students.GroupFk	 
	 UNION ALL
	 SELECT Books.Id, Departments.[Name]
	 FROM Books, TeacherCards, Teachers, Departments
	 WHERE TeacherCards.BookFk = Books.Id AND Teachers.Id = TeacherCards.TeacherFk AND Departments.Id = Teachers.DepartmentFk	 
	  )
  INSERT @resTable
  SELECT COUNT(BookId), GroupName
  FROM temp
  GROUP BY GroupName
  RETURN 
  END
  GO

 SELECT * FROM dbo.BooksGroupsAndDep() 
 GO

--5. Функцию, возвращающую список книг, отвечающих набору критериев
--   (например, имя автора, фамилия автора, тематика, категория),
--   и отсортированный по номеру поля, указанному в 5-м параметре,
--   в направлении, указанном в 6-м параметре.

CREATE FUNCTION dbo.ListOfBooks(@FirstName NVARCHAR(100), @LastName NVARCHAR(100),
@Theme NVARCHAR(100), @Category NVARCHAR(100), @Field INT, @SortDir INT)
RETURNS TABLE
AS
RETURN
(
	SELECT TOP 100 Books.[Name] [BookName], Authors.FirstName, Authors.LastName,
	Themes.[Name] [ThemeName], Categories.[Name] [CategoryName]
	FROM Books, Authors, Categories, Themes
	WHERE Authors.FirstName = @FirstName
	AND Authors.LastName = @LastName
	AND Themes.[Name] = @Theme
	AND Categories.[Name] = @Category
	AND Books.AuthorFk  = Authors.Id 
	AND Books.ThemeFk = Themes.Id
	AND Books.CategoryFk = Categories.Id
	ORDER BY CASE @Field WHEN 1 then Books.[Name] END DESC,
				 CASE @Field WHEN 2 then Authors.FirstName END DESC,
				 CASE @Field WHEN 3 then Themes.[Name] END DESC,
				 CASE @Field WHEN 4 then Categories.[Name] END DESC
);

GO

SELECT * FROM dbo.ListOfBooks('Алексей','Архангельский','Программирование','C++ Builder', 1, 1)
GO

--6. Функцию, которая возвращает список библиотекарей и кол-во выданных
--   каждым из них книг.

CREATE FUNCTION dbo.LibsListFunc()
RETURNS @LibsListFunc TABLE
(
  FirstName NVARCHAR(100),
  LastName NVARCHAR(100),
  CountOfBooks INT
)
AS
BEGIN
INSERT @LibsListFunc
	SELECT Libs.FirstName, Libs.LastName, stud.cnt +COUNT(TeacherCards.LibFk)
	FROM Libs, TeacherCards,
	(SELECT COUNT(StudentCards.LibFk)cnt 
	FROM Libs, StudentCards 
	WHERE StudentCards.LibFk = Libs.Id 
	GROUP BY Libs.FirstName, Libs.LastName)stud
	WHERE TeacherCards.LibFk = Libs.Id
	GROUP BY Libs.FirstName, Libs.LastName, stud.cnt
RETURN 
END
GO

SELECT * FROM dbo.LibsListFunc()
GO