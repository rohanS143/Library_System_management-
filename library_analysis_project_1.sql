USE library_project_2; 

-- 1) Create a new table called expensive_books containing books with rental price above 7
CREATE TABLE expensive_books AS 
SELECT rental_price
FROM books
WHERE rental_price > 7; 

SELECT * FROM expensive_books; 

DROP TABLE expensive_books; 
CREATE TABLE expensive_books AS 
SELECT * 
FROM books
WHERE rental_price > 7; 

-- 2) Create a new table called classic_books. It should contain only these columns: 
-- book_title, author, rental_price. Only include books where category = 'Classic'

CREATE TABLE classic_books AS 
SELECT book_title, author, rental_price
FROM books
WHERE category = 'Classic'; 

SELECT * FROM classic_books; 

-- 3) Create a table called book_issue_count. It should show isbn, book_title, issue_count.
SELECT * FROM issued_status; 

CREATE TABLE book_issued_count AS 
SELECT b.isbn, b.book_title, 
COUNT(ist.issued_book_isbn) AS issue_count
FROM books AS b
JOIN issued_status AS ist
ON b.isbn = ist.issued_book_isbn
GROUP BY 1,2; 

SELECT * FROM book_issued_count;

-- 4) Find books that were issued but not returned: 
SELECT * 
FROM issued_status AS ist
LEFT JOIN return_status AS rs
ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL; 

-- 5) Show all issued books that have been returned. 

SELECT * 
FROM issued_status AS ist
JOIN return_status AS rs
ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NOT NULL; 

-- 5) Show books that were returned with: book_title, return_date. 
select * from return_status; 

SELECT b.book_title, rs.return_date
FROM books AS b
JOIN issued_status AS ist
ON b.isbn = ist.issued_book_isbn
JOIN return_status AS rs
ON ist.issued_id = rs.issued_id
GROUP BY 1,2; 


-- 6) SHOW members who never issued any book. Display member_name, member_id
SELECT m.member_name, m.member_id
FROM members AS m
LEFT JOIN issued_status AS ist
ON m.member_id = ist.issued_member_id
WHERE ist.issued_member_id IS NULL; 


-- DATE ARITHMETIC
SELECT CURRENT_DATE; 

-- Go back to 30 days
SELECT CURRENT_DATE - INTERVAL 30 DAY; 

-- Find members registered in last 180 days
SELECT * 
FROM members 
WHERE reg_date >= CURRENT_DATE - INTERVAL 180 day; 

-- days between dates
-- suppose: issued_date = 2026-04-01, today = 2026-05-21

-- 1) show memebrs who registered in the last 90 days. 
select * from members; 
select *
from members 
where reg_date >= current_date - interval 90 day; 

-- 2) show issued books that were issued more than 30 days ago

select * from issued_status; 

select issued_id, issued_book_name, issued_date
FROM issued_status
where issued_date < current_date - interval 30 day; 

-- 3) show issued books and calculate how many days ago they were issued. 
-- Display: issued_id, issued_book_name, issued_date, days_since_issued
select issued_id,
issued_book_name,
 issued_date,
datediff(current_date, issued_date) AS days_since_issued
from issued_status; 

-- 4) show books that are not returned yet, issued more than 30 days ago. Display: 
	-- issued_id, issued_book_name, issued_date, days_overdue
    select ist.issued_id, 
		ist.issued_book_name, 
		ist.issued_date, 
		datediff(current_date, ist.issued_date) as overdue_book
    from issued_status as ist
    left join return_status as rs
    on ist.issued_id = rs.issued_id
    where rs.return_id is null
		and datediff(current_date, ist.issued_date) > 30; 
        
-- 5) show members with overdue books. Display member_id, memmber_name, issued_book_name, issud_date, days_overdue
-- Rules: not returned yet, issued more than 30 days ago
select m.member_id, m.member_name, ist.issued_book_name, ist.issued_date, 
datediff(current_date, issued_date) as days_overdue
from issued_status as ist
join members as m
on m.member_id = ist.issued_member_id
left join return_status as rs
on ist.issued_id = rs.issued_id
where rs.return_id is null 
and datediff(current_date, ist.issued_date) > 30; 

-- show books that are currently available. Table books, conditions status = 'yes'
select * from books
where status = 'Yes'; 


-- Create a table of members who issued at least one book in the last 2 months. 

select * from members;
select * from books;
select * from issued_status;  

create table book_issued_last_2_months as 
select distinct 
	m.member_id, 
    m.member_name, 
    m.member_address, 
    m.reg_date
from members as m
join issued_status as ist
on m.member_id = ist.issued_member_id
where ist.issued_date >= current_date - interval 2 month; 

select * from book_issued_last_2_months; 

select * from issued_status 
where issued_member_id = 'C109'; 


-- top 3 employees who processed most book issues
select * from branch; 
select * from employees; 
select * from issued_status; 

select 
	e.emp_name,
    e.branch_id,
    count(ist.issued_emp_id) as no_issue
    from employees as e
    join issued_status as ist
    on e.emp_id = ist.issued_emp_id
    group by 1,2
    order by no_issue desc
    limit 3; 

-- find each member who has returned a damaged book
select * from books; 
select * from members; 
select * from issued_status; 
select * from return_status; 


select
	m.member_id, 
    m.member_name, 
    ist.issued_id, 
    b.book_title, 
    rs.book_quality,
    rs.return_date
from members as m
join issued_status as ist
on m.member_id = ist.issued_member_id
join books as b
on b.isbn = ist.issued_book_isbn
join return_status as rs
on rs.issued_id = ist.issued_id
where rs.book_quality = 'Damage'; 





































































































    
    
    
    
    
    
    
    
    
    
    






































































