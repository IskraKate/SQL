 -- 1. Âûòàùèòü íàçâàíèå ó÷åáíèêîâ, êîòîðûå èçäàâàëèñü íå èçäàòåëüñòâîì 'BHV',
 --   è òèðàæ êîòîðûõ >= 3000 ýêçåìïëÿðîâ.

 SELECT Books.Name AS 'Íàçâàíèå', Books.Izd AS 'Èçäàòåëüñòâî', Books.Pressrun AS 'Òèðàæ'  
 FROM Books
 WHERE Books.Izd NOT LIKE 'BHV%' AND Books.Pressrun >= 3000;

 --2. Âûòàùèòü êíèãè, ñî äíÿ èçäàíèÿ êîòîðûõ ïðîøëî íå áîëåå ãîäà.
--    Çàäàòü êîíêðåòíóþ äàòó ìîæíî ñ ïîìîùüþ ôóíêöèè DATEFROMPARTS().

SELECT Books.Name AS 'Íàçâàíèå', Books.Date AS 'Äåíü èçäàíèÿ'
FROM Books
WHERE DATEDIFF(MM, Books.Date, GETDATE()) <= 12;

-- 3. Âûòàùèòü êíèãè, î äàòå èçäàíèÿ êîòîðûõ íè÷åãî íå èçâåñòíî.

SELECT Books.Name AS 'Íàçâàíèå'
FROM Books
WHERE  Books.Date IS NULL

-- 4. Âûòàùèòü âñå êíèãè-íîâèíêè, öåíà êîòîðûõ íèæå 30 ãðí.

SELECT Books.Name AS 'Íàçâàíèå', Books.Date AS 'Äåíü èçäàíèÿ', Books.Price AS 'Öåíà'
FROM Books
WHERE DATEDIFF(DD, Books.Date, GETDATE()) <= 120 AND Books.Price <= 30;

-- 5. Âûòàùèòü êíèãè, â íàçâàíèÿõ êîòîðûõ åñòü ñëîâî Microsoft, íî íåò ñëîâà Windows.

SELECT Books.Name AS 'Íàçâàíèå'
FROM Books 
WHERE Books.Name LIKE '%Microsoft%' AND Books.Name NOT LIKE '%Windows%'

-- 6. Âûòàùèòü êíèãè, ó êîòîðûõ öåíà îäíîé ñòðàíèöû < 10 êîïååê.

SELECT Books.Name AS 'Íàçâàíèå', Books.Price/Books.Pages AS 'Öåíà îäíîé ñòðàíèöû'
FROM Books 
WHERE Books.Pages <> 0 AND Books.Price/Books.Pages < 0.10;

-- 7. Âûòàùèòü êíèãè, â íàçâàíèÿõ êîòîðûõ ïðèñóòñòâóåò êàê ìèíèìóì îäíà öèôðà.

SELECT Books.Name AS 'Íàçâàíèå'
FROM Books
WHERE Books.Name LIKE '%[0-9]%';

-- 8. Âûòàùèòü êíèãè, â íàçâàíèÿõ êîòîðûõ ïðèñóòñòâóåò íå ìåíåå òðåõ öèôð.

SELECT Books.Name AS 'Íàçâàíèå'
FROM Books
WHERE Books.Name LIKE '%[0-9]%[0-9]%[0-9]%';

-- 9. Âûòàùèòü êíèãè, â íàçâàíèÿõ êîòîðûõ ïðèñóòñòâóåò ðîâíî ïÿòü öèôð.

SELECT Books.Name AS 'Íàçâàíèå'
FROM Books
WHERE Books.Name LIKE '%[0-9]%[0-9]%[0-9]%[0-9]%[0-9]%' AND Books.Name NOT LIKE '%[0-9]%[0-9]%[0-9]%[0-9]%[0-9]%[0-9]%';

--10. Óäàëèòü êíèãè, â êîäå êîòîðûõ ïðèñóòñòâóåò öèôðû 6 èëè 7.

DELETE
FROM Books
WHERE Books.Code LIKE '%[67]%';

--11. Ïðîñòàâèòü òåêóùóþ äàòó äëÿ òåõ êíèã, ó êîòîðûõ äàòà èçäàíèÿ îòñóòñòâóåò.
--    Tåêóùóþ äàòó ìîæíî ïîëó÷èòü ñ ïîìîùüþ ôóíêöèè GETDATE().

UPDATE Books
SET Books.Date = GETDATE()
WHERE Books.Date IS NULL;