 -- 1. Вытащить название учебников, которые издавались не издательством 'BHV',
 --   и тираж которых >= 3000 экземпляров.

 SELECT Books.Name AS 'Название', Books.Izd AS 'Издательство', Books.Pressrun AS 'Тираж'  
 FROM Books
 WHERE Books.Izd NOT LIKE 'BHV%' AND Books.Pressrun >= 3000;

 --2. Вытащить книги, со дня издания которых прошло не более года.
--    Задать конкретную дату можно с помощью функции DATEFROMPARTS().

SELECT Books.Name AS 'Название', Books.Date AS 'День издания'
FROM Books
WHERE DATEDIFF(MM, Books.Date, GETDATE()) <= 12;

-- 3. Вытащить книги, о дате издания которых ничего не известно.

SELECT Books.Name AS 'Название'
FROM Books
WHERE  Books.Date IS NULL

-- 4. Вытащить все книги-новинки, цена которых ниже 30 грн.

SELECT Books.Name AS 'Название', Books.Date AS 'День издания', Books.Price AS 'Цена'
FROM Books
WHERE DATEDIFF(DD, Books.Date, GETDATE()) <= 120 AND Books.Price <= 30;

-- 5. Вытащить книги, в названиях которых есть слово Microsoft, но нет слова Windows.

SELECT Books.Name AS 'Название'
FROM Books 
WHERE Books.Name LIKE '%Microsoft%' AND Books.Name NOT LIKE '%Windows%'

-- 6. Вытащить книги, у которых цена одной страницы < 10 копеек.

SELECT Books.Name AS 'Название', Books.Price/Books.Pages AS 'Цена одной страницы'
FROM Books 
WHERE Books.Pages != 0 AND Books.Price/Books.Pages < 0.10;

-- 7. Вытащить книги, в названиях которых присутствует как минимум одна цифра.

SELECT Books.Name AS 'Название'
FROM Books
WHERE Books.Name LIKE '%[0-9]%';

-- 8. Вытащить книги, в названиях которых присутствует не менее трех цифр.

SELECT Books.Name AS 'Название'
FROM Books
WHERE Books.Name LIKE '%[0-9]%[0-9]%[0-9]%';

-- 9. Вытащить книги, в названиях которых присутствует ровно пять цифр.

SELECT Books.Name AS 'Название'
FROM Books
WHERE Books.Name LIKE '%[0-9]%[0-9]%[0-9]%[0-9]%[0-9]%' AND Books.Name NOT LIKE '%[0-9]%[0-9]%[0-9]%[0-9]%[0-9]%[0-9]%';

--10. Удалить книги, в коде которых присутствует цифры 6 или 7.

DELETE
FROM Books
WHERE Books.Code LIKE '%[6,7]%';

--11. Проставить текущую дату для тех книг, у которых дата издания отсутствует.
--    Tекущую дату можно получить с помощью функции GETDATE().

UPDATE Books
SET Books.Date = GETDATE()
WHERE Books.Date IS NULL;