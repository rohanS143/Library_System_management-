USE library_project_2;


-- BASIC SQL FUNCTIONS TEST
-- Q1) Cange the status of the book 
UPDATE books
SET status = 'Yes'
WHERE isbn = '978-0-307-58837-1'; 

-- Q2) Add a new return record
INSERT INTO return_status(return_id, issued_id, return_date)
	VALUES(
		'RS200', 
        'IS140', 
        CURRENT_DATE
        ); 
        
-- Q3) Shoe all books where status is 'No'
SELECT * FROM books
WHERE status = 'No'; 

-- Q4) Delete a return record with return_id = RS200
DELETE FROM return_status
WHERE return_id = 'RS200';

-- Q5) Create a table called students with: 
CREATE TABLE students_data(
	student_id VARCHAR(10) PRIMARY KEY, 
    student_name VARCHAR(50),
    age INT,
    major VARCHAR(30)
    
); 

-- Q6) Add a new column to studnets: 
ALTER TABLE students_data
ADD email VARCHAR(100); 

-- Q7) Update multiple columns 
UPDATE students_date
SET student_name = 'John', major = 'Science'
WHERE student_id = 'S101'; 

-- Q8) Count how many books are currently available (status = 'Yes')
SELECT COUNT(*) AS count_status
FROM books
WHERE status = 'Yes';

-- Q9) Show all unique book categories from books
SELECT * FROM books; 
SELECT DISTINCT category
FROM books; 

SELECT * FROM books;
SELECT * FROM issued_status; 

-- JOIN PROBLEMS INNER JOIN 
-- 1) Show book_title, issued_date from books and issued_status. 
SELECT b.book_title, ist.issued_date FROM books AS b
JOIN issued_status AS ist
ON ist.issued_book_isbn = b.isbn; 

-- 2) Show member_name, book_title, issued_date from tables members, issued_status, and books.
SELECT * FROM members; 
SELECT * FROM issued_status; 

SELECT m.member_name, b.book_title, ist.issued_date
FROM issued_status AS ist
JOIN books AS b
ON ist.issued_book_isbn = b.isbn
JOIN members AS m
ON ist.issued_member_id = m.member_id; 

-- 3) Show member_name, book_title, issued_date, emp_name from tables issued_status, members, books, employees
SELECT * FROM books;
SELECT * FROM employees; 

SELECT m.member_name, b.book_title, ist.issued_date, e.emp_name
FROM books AS b
JOIN issued_status AS ist
ON ist.issued_book_isbn = b.isbn
JOIN members AS m
ON ist.issued_member_id = m.member_id
JOIN employees AS e
ON ist.issued_emp_id = e.emp_id; 

-- 4) Show emp_name, total number of books each employee issued. 
SELECT e.emp_name, 
COUNT(ist.issued_book_isbn) AS total
FROM issued_status AS ist
JOIN employees AS e
ON ist.issued_emp_id = e.emp_id
GROUP BY 1
ORDER BY total DESC; 

SELECT e.emp_name, 
COUNT(*) AS total
FROM issued_status AS ist
JOIN employees AS e
ON ist.issued_emp_id = e.emp_id
GROUP BY 1
ORDER BY total DESC; 

-- 5) Show category, total number of times books from that category were issued from tables books and issued_status
SELECT b.category, 
COUNT(*) AS total
FROM books AS b
JOIN issued_status AS ist
ON b.isbn = ist.issued_book_isbn
GROUP BY 1; 

-- 6) Show category, total rental income from issued books in each category from tables books and issued_status
SELECT * FROM issued_status; 
SELECT * FROM books; 

SELECT b.category, 
SUM(b.rental_price) AS total_sum
FROM books AS b
JOIN issued_status AS ist
ON b.isbn = ist.issued_book_isbn
GROUP BY 1; 

-- 7) Show all books, even books that were never issued. 
SELECT b.book_title, ist.issued_id, ist.issued_date
FROM books AS b
LEFT JOIN issued_status AS ist
ON b.isbn = ist.issued_book_isbn
GROUP BY 1,2,3; 

-- 8) Show only books that were never issued. DISPLAY book_title, isbn. 
SELECT * FROM books; 
SELECT * FROM issued_status; 

SELECT b.book_title, b.isbn 
FROM books AS b
LEFT JOIN issued_status AS ist
ON b.isbn = ist.issued_book_isbn
WHERE ist.issued_book_isbn IS NULL; 

-- 9) Show each member and how many books they issued. 
SELECT * FROM issued_status; 
SELECT * FROM members; 

SELECT m.member_name, 
COUNT(ist.issued_member_id) AS total_books_issued
FROM members AS m
LEFT JOIN issued_status AS ist
ON m.member_id = ist.issued_member_id
GROUP BY 1; 

-- 10) Show only members who issued more than 2 books. Display member_name, total_books_issued
SELECT m.member_name, 
COUNT(ist.issued_member_id) AS total_books_issued
FROM members AS m
LEFT JOIN issued_status AS ist
ON m.member_id = ist.issued_member_id
GROUP BY 1
HAVING COUNT(ist.issued_member_id) > 2; 

-- 11) Show each employee and total rental income they generated 
SELECT * FROM employees; 
SELECT * FROM books; 
SELECT * FROM issued_status; 

SELECT e.emp_name, 
SUM(b.rental_price) AS total_income
FROM employees AS e
JOIN issued_status AS ist
ON e.emp_id = ist.issued_emp_id
JOIN books AS b
ON ist.issued_book_isbn = b.isbn
GROUP BY 1; 

-- 12) Show each employee's total rental income, but only employees who generated more than 50 income. 
SELECT e.emp_name, 
SUM(b.rental_price) AS total_income
FROM employees AS e
JOIN issued_status AS ist
ON e.emp_id = ist.issued_emp_id
JOIN books AS b
ON ist.issued_book_isbn = b.isbn
GROUP BY 1
HAVING SUM(b.rental_price) > 50; 



-- ADVANCED SQL Operations 
-- Task 13: Identify Members with Overdue Books
-- Write a query to identify members who have overdue books (assume a 30-day return period). 
-- Display the member's_id, member's name, book title, issue date, and days overdue.

SELECT * FROM members; 
SELECT * FROM books; 
SELECT * FROM issued_status;
SELECT * FROM return_status; 

SELECT 
	ist.issued_member_id,
    m.member_name,
    b.book_title,
    ist.issued_date,
    rs.return_date, 
    
   DATEDIFF(CURRENT_DATE, ist.issued_date) - 30 AS days_overdue
    

FROM issued_status AS ist
JOIN 
members AS m
ON m.member_id = ist.issued_member_id
JOIN 
books AS b
ON b.isbn = ist.issued_book_isbn
LEFT JOIN 
return_status AS rs
ON rs.issued_id = ist.issued_id
WHERE return_date IS NULL
AND 
DATEDIFF(CURRENT_DATE, ist.issued_date) > 30
ORDER BY 1
; 

-- Task 14: Update Book Status on Return
-- Write a query to update the status of books in the books table to "Yes" 
-- when they are returned (based on entries in the return_status table).


SELECT * FROM books; 
SELECT * FROM issued_status; 
SELECT * FROM return_status; 

SELECT * FROM issued_status
WHERE issued_book_isbn = '978-0-451-52994-2'; 

SELECT * FROM books
WHERE isbn = '978-0-451-52994-2'; 

UPDATE books
SET status = 'No'
WHERE isbn = '978-0-451-52994-2'; 

SELECT * FROM return_status
WHERE issued_id = 'IS130' ; 

INSERT INTO return_status(return_id, issued_id, return_date)
    VALUES
    ('RS124', 'IS130', CURRENT_DATE); 

UPDATE books
SET status = 'Yes'
WHERE isbn = (
	SELECT issued_book_isbn
    FROM issued_status
    WHERE issued_id = 'IS130'
); 


-- STORE procedures
DROP PROCEDURE IF EXISTS add_return_records;

DELIMITER $$

CREATE PROCEDURE add_return_records(
    IN p_return_id VARCHAR(10),
    IN p_issued_id VARCHAR(10)
)
BEGIN
    DECLARE v_isbn VARCHAR(50);

    SELECT issued_book_isbn
    INTO v_isbn
    FROM issued_status
    WHERE issued_id = p_issued_id;

    INSERT INTO return_status(return_id, issued_id, return_date)
    VALUES (p_return_id, p_issued_id, CURRENT_DATE);

    UPDATE books
    SET status = 'Yes'
    WHERE isbn = v_isbn;
END $$

DELIMITER ;

CALL add_return_records('RS139', 'IS135');

SELECT * FROM books; 
SELECT * FROM issued_status;
SELECT * FROM return_status;  
-- '978-0-307-58837-1', 'Sapiens: A Brief History of Humankind', 'History', '8', 'No', 'Yuval Noah Harari', 'Harper Perennial'

-- 'IS135', 'C107', 'Sapiens: A Brief History of Humankind', '2024-04-08', '978-0-307-58837-1', 'E108'








































    
    
    
    
    
	
