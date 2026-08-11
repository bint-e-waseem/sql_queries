-- =============================================
-- LIBRARY MANAGEMENT SYSTEM - QUERIES
-- =============================================
USE library_db;

-- =============================================
-- 1. BASIC CRUD OPERATIONS
-- =============================================

-- 1.1 SELECT - View all available books
SELECT * FROM books WHERE available_copies > 0;

-- 1.2 INSERT - Add a new member
INSERT INTO members (full_name, email, phone, address) 
VALUES ('New Member', 'newmember@email.com', '9876543230', 'New Address');

-- 1.3 UPDATE - Update member details
UPDATE members 
SET phone = '9999999999', address = 'Updated Address' 
WHERE member_id = 21;

-- 1.4 DELETE - Remove a member (only if no borrowings)
DELETE FROM members WHERE member_id = 21 AND member_id NOT IN (SELECT DISTINCT member_id FROM borrowings);

-- =============================================
-- 2. SIMPLE QUERIES (WHERE, ORDER BY, LIMIT)
-- =============================================

-- 2.1 Find books by specific author
SELECT * FROM books WHERE author LIKE '%Harari%';

-- 2.2 Books in specific genre
SELECT title, author, available_copies 
FROM books 
WHERE genre = 'Self-Help' 
ORDER BY title;

-- 2.3 Top 5 most borrowed books
SELECT 
    b.title,
    b.author,
    COUNT(br.borrow_id) AS borrow_count
FROM books b
JOIN borrowings br ON b.book_id = br.book_id
GROUP BY b.book_id
ORDER BY borrow_count DESC
LIMIT 5;

-- 2.4 Active members who joined in last 6 months
SELECT full_name, email, membership_date 
FROM members 
WHERE membership_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
AND status = 'active';

-- =============================================
-- 3. JOINS (Combining multiple tables)
-- =============================================

-- 3.1 INNER JOIN - Borrowing details with member and book info
SELECT 
    br.borrow_id,
    m.full_name AS member_name,
    b.title AS book_title,
    br.borrow_date,
    br.due_date,
    br.status
FROM borrowings br
INNER JOIN members m ON br.member_id = m.member_id
INNER JOIN books b ON br.book_id = b.book_id
WHERE br.status = 'borrowed';

-- 3.2 LEFT JOIN - All books with their borrowing count
SELECT 
    b.title,
    b.author,
    COUNT(br.borrow_id) AS times_borrowed
FROM books b
LEFT JOIN borrowings br ON b.book_id = br.book_id
GROUP BY b.book_id
HAVING times_borrowed = 0; -- Books never borrowed

-- 3.3 Self Join - Members with same address (example)
SELECT 
    m1.full_name AS member1,
    m2.full_name AS member2,
    m1.address
FROM members m1
INNER JOIN members m2 ON m1.address = m2.address AND m1.member_id < m2.member_id;

-- =============================================
-- 4. AGGREGATE FUNCTIONS (GROUP BY, HAVING)
-- =============================================

-- 4.1 Total books borrowed per member
SELECT 
    m.full_name,
    COUNT(br.borrow_id) AS total_borrowings,
    SUM(CASE WHEN br.status = 'returned' THEN 1 ELSE 0 END) AS returned_count,
    SUM(CASE WHEN br.status = 'overdue' THEN 1 ELSE 0 END) AS overdue_count
FROM members m
LEFT JOIN borrowings br ON m.member_id = br.member_id
GROUP BY m.member_id
ORDER BY total_borrowings DESC;

-- 4.2 Genre popularity
SELECT 
    genre,
    COUNT(*) AS total_books,
    SUM(total_copies) AS total_copies
FROM books
GROUP BY genre
ORDER BY total_books DESC;

-- 4.3 Monthly borrowing trend
SELECT 
    DATE_FORMAT(borrow_date, '%Y-%m') AS month,
    COUNT(*) AS total_borrowings,
    COUNT(DISTINCT member_id) AS unique_members
FROM borrowings
GROUP BY DATE_FORMAT(borrow_date, '%Y-%m')
ORDER BY month DESC;

-- =============================================
-- 5. SUBQUERIES
-- =============================================

-- 5.1 Members who have borrowed more than average
SELECT 
    m.full_name,
    COUNT(br.borrow_id) AS borrow_count
FROM members m
JOIN borrowings br ON m.member_id = br.member_id
GROUP BY m.member_id
HAVING COUNT(br.borrow_id) > (
    SELECT AVG(borrow_count) 
    FROM (
        SELECT COUNT(*) AS borrow_count 
        FROM borrowings 
        GROUP BY member_id
    ) AS avg_borrow
);

-- 5.2 Books that are currently all borrowed (0 available)
SELECT title, author, total_copies, available_copies
FROM books
WHERE available_copies = 0;

-- 5.3 Members with maximum fines
SELECT 
    m.full_name,
    SUM(br.fine_amount) AS total_fine
FROM members m
JOIN borrowings br ON m.member_id = br.member_id
GROUP BY m.member_id
HAVING SUM(br.fine_amount) > 0
ORDER BY total_fine DESC;

-- =============================================
-- 6. DATE FUNCTIONS
-- =============================================

-- 6.1 Currently overdue books
SELECT 
    b.title,
    m.full_name,
    br.due_date,
    DATEDIFF(CURDATE(), br.due_date) AS days_overdue
FROM borrowings br
JOIN books b ON br.book_id = b.book_id
JOIN members m ON br.member_id = m.member_id
WHERE br.status = 'overdue';

-- 6.2 Borrowings in last 7 days
SELECT * FROM borrowings 
WHERE borrow_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY);

-- 6.3 Members whose membership expires soon (assuming 1 year)
SELECT 
    full_name,
    membership_date,
    DATE_ADD(membership_date, INTERVAL 1 YEAR) AS expiry_date
FROM members
WHERE DATE_ADD(membership_date, INTERVAL 1 YEAR) BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY);

-- =============================================
-- 7. WINDOW FUNCTIONS (Advanced)
-- =============================================

-- 7.1 Rank members by borrowing count
SELECT 
    full_name,
    COUNT(br.borrow_id) AS total_borrowed,
    RANK() OVER (ORDER BY COUNT(br.borrow_id) DESC) AS rank_position
FROM members m
LEFT JOIN borrowings br ON m.member_id = br.member_id
GROUP BY m.member_id;

-- 7.2 Cumulative borrowings over time
SELECT 
    borrow_date,
    COUNT(*) AS daily_borrowings,
    SUM(COUNT(*)) OVER (ORDER BY borrow_date) AS cumulative_total
FROM borrowings
GROUP BY borrow_date
ORDER BY borrow_date;

-- =============================================
-- 8. CASE STATEMENTS
-- =============================================

-- 8.1 Categorize books by availability
SELECT 
    title,
    available_copies,
    CASE 
        WHEN available_copies = 0 THEN 'Out of Stock'
        WHEN available_copies <= 2 THEN 'Limited Stock'
        WHEN available_copies <= 5 THEN 'In Stock'
        ELSE 'Plenty Available'
    END AS availability_status
FROM books;

-- 8.2 Member activity levels
SELECT 
    full_name,
    COUNT(br.borrow_id) AS total_borrowings,
    CASE 
        WHEN COUNT(br.borrow_id) > 5 THEN 'Active'
        WHEN COUNT(br.borrow_id) BETWEEN 1 AND 5 THEN 'Regular'
        ELSE 'Inactive'
    END AS member_category
FROM members m
LEFT JOIN borrowings br ON m.member_id = br.member_id
GROUP BY m.member_id;

-- =============================================
-- 9. USING VIEWS
-- =============================================

-- 9.1 View current borrowings
SELECT * FROM vw_current_borrowings;

-- 9.2 View member history
SELECT * FROM vw_member_history WHERE total_books_borrowed > 0;

-- 9.3 View popular books
SELECT * FROM vw_popular_books LIMIT 10;

-- =============================================
-- 10. STORED PROCEDURES (Call them)
-- =============================================

-- 10.1 Borrow a book (member_id=1, book_id=1, borrow for 14 days)
CALL sp_borrow_book(1, 1, 14);

-- 10.2 Return a book (borrow_id=36)
CALL sp_return_book(36);

-- =============================================
-- 11. PERFORMANCE ANALYSIS
-- =============================================

-- Check query execution plan
