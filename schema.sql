


```sql
-- =============================================
-- DATABASE: library_db
-- CREATED BY: yashfa waseem
-- DATE: 2026-08-12
-- DESCRIPTION: Complete schema for Library Management System
-- =============================================

-- =============================================
-- STEP 1: CREATE DATABASE 
-- =============================================
CREATE DATABASE IF NOT EXISTS library_db;
USE library_db;

-- =============================================
-- STEP 2: DROP EXISTING TABLES (Clean slate)
-- =============================================
DROP TABLE IF EXISTS borrowings;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS members;

-- =============================================
-- STEP 3: CREATE MEMBERS TABLE
-- =============================================
CREATE TABLE members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    address TEXT,
    membership_date DATE DEFAULT (CURRENT_DATE),
    status ENUM('active', 'inactive', 'suspended') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- =============================================
-- STEP 4: CREATE BOOKS TABLE
-- =============================================
CREATE TABLE books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(100) NOT NULL,
    isbn VARCHAR(20) UNIQUE,
    genre VARCHAR(50),
    publication_year YEAR,
    total_copies INT DEFAULT 1,
    available_copies INT DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Business rule: available_copies should never exceed total_copies
    CHECK (available_copies <= total_copies)
);

-- =============================================
-- STEP 5: CREATE BORROWINGS TABLE (Transaction table)
-- =============================================
CREATE TABLE borrowings (
    borrow_id INT PRIMARY KEY AUTO_INCREMENT,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    borrow_date DATE DEFAULT (CURRENT_DATE),
    due_date DATE,
    return_date DATE,
    status ENUM('borrowed', 'returned', 'overdue') DEFAULT 'borrowed',
    fine_amount DECIMAL(10,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign Key Constraints
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    
    -- Business rule: return_date should be after borrow_date
    CHECK (return_date >= borrow_date OR return_date IS NULL)
);

-- =============================================
-- STEP 6: CREATE INDEXES FOR PERFORMANCE
-- =============================================
-- Books table indexes
CREATE INDEX idx_books_title ON books(title);
CREATE INDEX idx_books_author ON books(author);
CREATE INDEX idx_books_genre ON books(genre);

-- Borrowings table indexes
CREATE INDEX idx_borrowings_member ON borrowings(member_id);
CREATE INDEX idx_borrowings_book ON borrowings(book_id);
CREATE INDEX idx_borrowings_status ON borrowings(status);
CREATE INDEX idx_borrowings_due_date ON borrowings(due_date);

-- Members table indexes
CREATE INDEX idx_members_email ON members(email);
CREATE INDEX idx_members_name ON members(full_name);

-- =============================================
-- STEP 7: CREATE VIEWS
-- =============================================

-- View 1: Currently borrowed books
CREATE OR REPLACE VIEW vw_current_borrowings AS
SELECT 
    b.title AS book_title,
    b.author,
    m.full_name AS member_name,
    m.email AS member_email,
    br.borrow_date,
    br.due_date,
    DATEDIFF(CURDATE(), br.due_date) AS days_overdue
FROM borrowings br
JOIN books b ON br.book_id = b.book_id
JOIN members m ON br.member_id = m.member_id
WHERE br.status = 'borrowed' OR br.status = 'overdue'
ORDER BY br.due_date ASC;

-- View 2: Member borrowing history
CREATE OR REPLACE VIEW vw_member_history AS
SELECT 
    m.member_id,
    m.full_name,
    COUNT(br.borrow_id) AS total_books_borrowed,
    SUM(CASE WHEN br.status = 'returned' THEN 1 ELSE 0 END) AS books_returned,
    SUM(CASE WHEN br.status = 'overdue' THEN 1 ELSE 0 END) AS books_overdue,
    SUM(br.fine_amount) AS total_fines
FROM members m
LEFT JOIN borrowings br ON m.member_id = br.member_id
GROUP BY m.member_id, m.full_name;

-- View 3: Popular books
CREATE OR REPLACE VIEW vw_popular_books AS
SELECT 
    b.book_id,
    b.title,
    b.author,
    b.genre,
    COUNT(br.borrow_id) AS times_borrowed,
    b.total_copies,
    b.available_copies
FROM books b
LEFT JOIN borrowings br ON b.book_id = br.book_id
GROUP BY b.book_id
ORDER BY times_borrowed DESC;

-- =============================================
-- STEP 8: CREATE STORED PROCEDURES
-- =============================================

-- Procedure 1: Borrow a book
DELIMITER //
CREATE PROCEDURE sp_borrow_book(
    IN p_member_id INT,
    IN p_book_id INT,
    IN p_days_to_borrow INT
)
BEGIN
    DECLARE v_available_copies INT;
    DECLARE v_due_date DATE;
    
    -- Check if book is available
    SELECT available_copies INTO v_available_copies 
    FROM books WHERE book_id = p_book_id;
    
    IF v_available_copies > 0 THEN
        -- Calculate due date (default 14 days if not specified)
        SET v_due_date = DATE_ADD(CURDATE(), INTERVAL COALESCE(p_days_to_borrow, 14) DAY);
        
        -- Insert borrowing record
        INSERT INTO borrowings (book_id, member_id, borrow_date, due_date, status)
        VALUES (p_book_id, p_member_id, CURDATE(), v_due_date, 'borrowed');
        
        -- Decrease available copies
        UPDATE books SET available_copies = available_copies - 1 
        WHERE book_id = p_book_id;
        
        SELECT 'Book borrowed successfully!' AS message;
    ELSE
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Book is currently not available!';
    END IF;
END //
DELIMITER ;

-- Procedure 2: Return a book
DELIMITER //
CREATE PROCEDURE sp_return_book(
    IN p_borrow_id INT
)
BEGIN
    DECLARE v_book_id INT;
    DECLARE v_due_date DATE;
    DECLARE v_fine DECIMAL(10,2);
    
    -- Get book_id and due_date
    SELECT book_id, due_date INTO v_book_id, v_due_date
    FROM borrowings WHERE borrow_id = p_borrow_id;
    
    -- Calculate fine (Rs. 10 per day late)
    IF CURDATE() > v_due_date THEN
        SET v_fine = DATEDIFF(CURDATE(), v_due_date) * 10;
    ELSE
        SET v_fine = 0;
    END IF;
    
    -- Update borrowing record
    UPDATE borrowings 
    SET return_date = CURDATE(), 
        status = 'returned',
        fine_amount = v_fine
    WHERE borrow_id = p_borrow_id;
    
    -- Increase available copies
    UPDATE books SET available_copies = available_copies + 1 
    WHERE book_id = v_book_id;
    
    SELECT CONCAT('Book returned! Fine amount: Rs. ', v_fine) AS message;
END //
DELIMITER ;

-- =============================================
-- STEP 9: CREATE TRIGGERS (Automated actions)
-- =============================================

-- Trigger 1: Automatically update book status to 'overdue' after due date
DELIMITER //
CREATE TRIGGER trg_update_overdue_status
BEFORE UPDATE ON borrowings
FOR EACH ROW
BEGIN
    IF NEW.status = 'borrowed' AND CURDATE() > NEW.due_date THEN
        SET NEW.status = 'overdue';
    END IF;
END //
DELIMITER ;

-- =============================================
-- STEP 10: DISPLAY ALL TABLES (Verification)
-- =============================================
SHOW TABLES;

-- Check table structures
DESCRIBE members;
DESCRIBE books;
DESCRIBE borrowings;

-- Success message
SELECT '✅ Database setup complete!' AS status;
