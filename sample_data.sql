-- =============================================
-- SAMPLE DATA FOR LIBRARY MANAGEMENT SYSTEM
-- =============================================
USE library_db;

-- =============================================
-- INSERT MEMBERS (20 members)
-- =============================================
INSERT INTO members (full_name, email, phone, address, membership_date, status) VALUES
('Aarav Sharma', 'aarav.sharma@email.com', '9876543210', '123, MG Road, Mumbai', '2024-01-15', 'active'),
('Priya Patel', 'priya.patel@email.com', '9876543211', '45, Lake View, Ahmedabad', '2024-02-20', 'active'),
('Rahul Singh', 'rahul.singh@email.com', '9876543212', '78, Sector 15, Noida', '2024-03-10', 'active'),
('Sneha Reddy', 'sneha.reddy@email.com', '9876543213', '234, Banjara Hills, Hyderabad', '2024-04-05', 'active'),
('Vikram Malhotra', 'vikram.m@email.com', '9876543214', '567, Civil Lines, Delhi', '2024-05-12', 'active'),
('Ananya Iyer', 'ananya.iyer@email.com', '9876543215', '89, Indira Nagar, Chennai', '2024-06-18', 'suspended'),
('Rajesh Kumar', 'rajesh.k@email.com', '9876543216', '12, BTM Layout, Bangalore', '2024-07-22', 'active'),
('Kavya Nair', 'kavya.nair@email.com', '9876543217', '345, Marine Drive, Kochi', '2024-08-30', 'active'),
('Deepak Joshi', 'deepak.j@email.com', '9876543218', '678, Hill Road, Pune', '2024-09-14', 'active'),
('Meera Krishnan', 'meera.k@email.com', '9876543219', '901, Anna Nagar, Chennai', '2024-10-01', 'active'),
('Arjun Verma', 'arjun.v@email.com', '9876543220', '234, Gomti Nagar, Lucknow', '2024-11-05', 'inactive'),
('Divya Menon', 'divya.m@email.com', '9876543221', '567, Juhu, Mumbai', '2024-12-10', 'active'),
('Karan Singhania', 'karan.s@email.com', '9876543222', '89, Malviya Nagar, Jaipur', '2025-01-15', 'active'),
('Neha Gupta', 'neha.g@email.com', '9876543223', '12, Shastri Nagar, Nagpur', '2025-02-20', 'active'),
('Suresh Babu', 'suresh.b@email.com', '9876543224', '345, T Nagar, Chennai', '2025-03-25', 'active'),
('Pooja Desai', 'pooja.d@email.com', '9876543225', '678, Navrangpura, Ahmedabad', '2025-04-01', 'active'),
('Gaurav Jain', 'gaurav.j@email.com', '9876543226', '901, Raj Nagar, Ghaziabad', '2025-05-10', 'active'),
('Swati Pandey', 'swati.p@email.com', '9876543227', '234, Indraprastha, Delhi', '2025-06-15', 'suspended'),
('Nitin Chopra', 'nitin.c@email.com', '9876543228', '567, Punjabi Bagh, Delhi', '2025-07-20', 'active'),
('Ritu Agarwal', 'ritu.a@email.com', '9876543229', '89, Kothrud, Pune', '2025-08-25', 'active');

-- =============================================
-- INSERT BOOKS (30 books with different genres)
-- =============================================
INSERT INTO books (title, author, isbn, genre, publication_year, total_copies, available_copies) VALUES
('The Silent Patient', 'Alex Michaelides', '9781250301697', 'Thriller', 2019, 5, 3),
('Where the Crawdads Sing', 'Delia Owens', '9780735219090', 'Fiction', 2018, 4, 2),
('Atomic Habits', 'James Clear', '9780735211292', 'Self-Help', 2018, 6, 4),
('The Alchemist', 'Paulo Coelho', '9780062502174', 'Fiction', 1988, 8, 5),
('Rich Dad Poor Dad', 'Robert Kiyosaki', '9781612680194', 'Finance', 1997, 5, 3),
('To Kill a Mockingbird', 'Harper Lee', '9780061120084', 'Classic', 1960, 7, 4),
('1984', 'George Orwell', '9780451524935', 'Dystopian', 1949, 6, 3),
('The Great Gatsby', 'F. Scott Fitzgerald', '9780743273565', 'Classic', 1925, 5, 2),
('The Psychology of Money', 'Morgan Housel', '9780857197689', 'Finance', 2020, 4, 2),
('Sapiens', 'Yuval Noah Harari', '9780062316097', 'History', 2011, 5, 3),
('The Subtle Art of Not Giving a F*ck', 'Mark Manson', '9780062457714', 'Self-Help', 2016, 4, 2),
('The Hobbit', 'J.R.R. Tolkien', '9780547928227', 'Fantasy', 1937, 6, 4),
('The Catcher in the Rye', 'J.D. Salinger', '9780316769488', 'Classic', 1951, 5, 3),
('Thinking, Fast and Slow', 'Daniel Kahneman', '9780374533557', 'Psychology', 2011, 4, 2),
('The 5 AM Club', 'Robin Sharma', '9781443456623', 'Self-Help', 2018, 3, 1),
('Dune', 'Frank Herbert', '9780441172719', 'Sci-Fi', 1965, 5, 3),
('The Art of War', 'Sun Tzu', '9781590302259', 'Philosophy', 1962, 4, 2),
('The Power of Habit', 'Charles Duhigg', '9780812981605', 'Self-Help', 2012, 5, 3),
('Hamlet', 'William Shakespeare', '9780743477123', 'Classic', 1603, 4, 2),
('The Da Vinci Code', 'Dan Brown', '9780385504201', 'Mystery', 2003, 5, 3),
('The Secret', 'Rhonda Byrne', '9781582701707', 'Self-Help', 2006, 4, 2),
('Pride and Prejudice', 'Jane Austen', '9780141439518', 'Classic', 1813, 6, 4),
('The Kite Runner', 'Khaled Hosseini', '9781594631931', 'Fiction', 2003, 5, 3),
('The Hunger Games', 'Suzanne Collins', '9780439023481', 'Young Adult', 2008, 6, 4),
('The Fault in Our Stars', 'John Green', '9780525478812', 'Young Adult', 2012, 4, 2),
('Gone Girl', 'Gillian Flynn', '9780307588364', 'Thriller', 2012, 5, 3),
('The Road', 'Cormac McCarthy', '9780307387899', 'Post-Apocalyptic', 2006, 4, 2),
('The Book Thief', 'Markus Zusak', '9780375842207', 'Historical Fiction', 2005, 5, 3),
('The Night Circus', 'Erin Morgenstern', '9780307744432', 'Fantasy', 2011, 4, 2),
('The Help', 'Kathryn Stockett', '9780425232200', 'Historical Fiction', 2009, 5, 3);

-- =============================================
-- INSERT BORROWINGS (35 transactions)
-- =============================================
INSERT INTO borrowings (book_id, member_id, borrow_date, due_date, return_date, status, fine_amount) VALUES
-- Current borrowings (not returned yet)
(1, 1, '2026-07-15', '2026-07-29', NULL, 'borrowed', 0),
(3, 2, '2026-07-20', '2026-08-03', NULL, 'borrowed', 0),
(5, 3, '2026-08-01', '2026-08-15', NULL, 'borrowed', 0),
(7, 4, '2026-07-25', '2026-08-08', NULL, 'borrowed', 0),
(9, 5, '2026-08-05', '2026-08-19', NULL, 'borrowed', 0),
(11, 6, '2026-07-10', '2026-07-24', NULL, 'overdue', 50),
(13, 7, '2026-07-28', '2026-08-11', NULL, 'borrowed', 0),
(15, 8, '2026-08-02', '2026-08-16', NULL, 'borrowed', 0),

-- Returned borrowings (history)
(2, 2, '2026-06-01', '2026-06-15', '2026-06-14', 'returned', 0),
(4, 3, '2026-06-05', '2026-06-19', '2026-06-18', 'returned', 0),
(6, 4, '2026-06-10', '2026-06-24', '2026-06-23', 'returned', 0),
(8, 5, '2026-06-15', '2026-06-29', '2026-06-28', 'returned', 0),
(10, 6, '2026-06-20', '2026-07-04', '2026-07-03', 'returned', 0),
(12, 7, '2026-06-25', '2026-07-09', '2026-07-08', 'returned', 0),
(14, 8, '2026-07-01', '2026-07-15', '2026-07-14', 'returned', 0),
(16, 9, '2026-07-05', '2026-07-19', '2026-07-18', 'returned', 0),
(18, 10, '2026-07-08', '2026-07-22', '2026-07-21', 'returned', 0),
(20, 11, '2026-07-12', '2026-07-26', '2026-07-25', 'returned', 0),
(22, 12, '2026-07-15', '2026-07-29', '2026-07-28', 'returned', 0),
(24, 13, '2026-07-18', '2026-08-01', '2026-07-31', 'returned', 0),
(26, 14, '2026-07-22', '2026-08-05', '2026-08-04', 'returned', 0),
(28, 15, '2026-07-25', '2026-08-08', '2026-08-07', 'returned', 0),
(30, 16, '2026-07-28', '2026-08-11', '2026-08-10', 'returned', 0),

-- Some overdue returned (with fines)
(1, 17, '2026-06-01', '2026-06-15', '2026-06-20', 'returned', 50),
(3, 18, '2026-06-10', '2026-06-24', '2026-07-01', 'returned', 70),
(5, 19, '2026-06-15', '2026-06-29', '2026-07-05', 'returned', 60),
(7, 20, '2026-07-01', '2026-07-15', '2026-07-20', 'returned', 50),
(9, 1, '2026-07-05', '2026-07-19', '2026-07-25', 'returned', 60),
(11, 2, '2026-07-10', '2026-07-24', '2026-08-01', 'returned', 80),
(13, 3, '2026-07-15', '2026-07-29', '2026-08-05', 'returned', 70),
(15, 4, '2026-07-20', '2026-08-03', '2026-08-10', 'returned', 70);

-- =============================================
-- VERIFICATION QUERIES
-- =============================================
SELECT '✅ Sample data inserted successfully!' AS status;

-- Check counts
SELECT COUNT(*) AS total_members FROM members;
SELECT COUNT(*) AS total_books FROM books;
SELECT COUNT(*) AS total_borrowings FROM borrowings;

-- Show sample data
SELECT * FROM members LIMIT 5;
SELECT * FROM books LIMIT 5;
SELECT * FROM borrowings LIMIT 5;
