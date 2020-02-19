 -- 1. �������� �������� ���������, ������� ���������� �� ������������� 'BHV',
 --   � ����� ������� >= 3000 �����������.

 SELECT Books.Name AS '��������', Books.Izd AS '������������', Books.Pressrun AS '�����'  
 FROM Books
 WHERE Books.Izd NOT LIKE 'BHV%' AND Books.Pressrun >= 3000;

 --2. �������� �����, �� ��� ������� ������� ������ �� ����� ����.
--    ������ ���������� ���� ����� � ������� ������� DATEFROMPARTS().

SELECT Books.Name AS '��������', Books.Date AS '���� �������'
FROM Books
WHERE DATEDIFF(MM, Books.Date, GETDATE()) <= 12;

-- 3. �������� �����, � ���� ������� ������� ������ �� ��������.

SELECT Books.Name AS '��������'
FROM Books
WHERE  Books.Date IS NULL

-- 4. �������� ��� �����-�������, ���� ������� ���� 30 ���.

SELECT Books.Name AS '��������', Books.Date AS '���� �������', Books.Price AS '����'
FROM Books
WHERE DATEDIFF(DD, Books.Date, GETDATE()) <= 120 AND Books.Price <= 30;

-- 5. �������� �����, � ��������� ������� ���� ����� Microsoft, �� ��� ����� Windows.

SELECT Books.Name AS '��������'
FROM Books 
WHERE Books.Name LIKE '%Microsoft%' AND Books.Name NOT LIKE '%Windows%'

-- 6. �������� �����, � ������� ���� ����� �������� < 10 ������.

SELECT Books.Name AS '��������', Books.Price/Books.Pages AS '���� ����� ��������'
FROM Books 
WHERE Books.Pages != 0 AND Books.Price/Books.Pages < 0.10;

-- 7. �������� �����, � ��������� ������� ������������ ��� ������� ���� �����.

SELECT Books.Name AS '��������'
FROM Books
WHERE Books.Name LIKE '%[0-9]%';

-- 8. �������� �����, � ��������� ������� ������������ �� ����� ���� ����.

SELECT Books.Name AS '��������'
FROM Books
WHERE Books.Name LIKE '%[0-9]%[0-9]%[0-9]%';

-- 9. �������� �����, � ��������� ������� ������������ ����� ���� ����.

SELECT Books.Name AS '��������'
FROM Books
WHERE Books.Name LIKE '%[0-9]%[0-9]%[0-9]%[0-9]%[0-9]%' AND Books.Name NOT LIKE '%[0-9]%[0-9]%[0-9]%[0-9]%[0-9]%[0-9]%';

--10. ������� �����, � ���� ������� ������������ ����� 6 ��� 7.

DELETE
FROM Books
WHERE Books.Code LIKE '%[6,7]%';

--11. ���������� ������� ���� ��� ��� ����, � ������� ���� ������� �����������.
--    T������ ���� ����� �������� � ������� ������� GETDATE().

UPDATE Books
SET Books.Date = GETDATE()
WHERE Books.Date IS NULL;