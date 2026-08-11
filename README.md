# sql_queries
# 📚 Library Management System - SQL Project

## 🎯 Project Overview
A complete database system to manage a library's books, members, and borrowing records. This project demonstrates fundamental SQL concepts including:

- ✅ Database Schema Design
- ✅ CRUD Operations (Create, Read, Update, Delete)
- ✅ Complex Queries with JOINs
- ✅ Subqueries and Aggregate Functions
- ✅ Views and Indexes for Performance

---

## 📊 Database Schema (ER Diagram)
+----------------+ +------------------+ +----------------+
| Books | | Borrowings | | Members |
+----------------+ +------------------+ +----------------+
| book_id (PK) |<----| book_id (FK) |---->| member_id (PK) |
| title | | member_id (FK) | | full_name |
| author | | borrow_date | | email |
| isbn | | return_date | | phone |
| genre | | status | | membership_date|
| total_copies | +------------------+ | address |
| available_copies| +----------------+
+----------------+
text

---

## 🛠️ Tech Stack
- **Database:** MySQL 8.0+
- **Tools:** MySQL Workbench / Command Line
- **Version Control:** Git & GitHub

---

## 🚀 Setup Instructions (Step-by-Step)

### Prerequisites
- MySQL installed on your system
- MySQL Workbench (recommended) or any SQL client

### Step 1: Clone the Repository
```bash
git clone https://github.com/yourusername/library-management-system.git
cd library-management-system
Step 2: Create Database
Open MySQL and run:

sql
CREATE DATABASE library_db;
USE library_db;
Step 3: Run Schema File
bash
mysql -u root -p library_db < schema.sql
Step 4: Insert Sample Data
bash
mysql -u root -p library_db < sample_data.sql
Step 5: Test Your Queries
bash
mysql -u root -p library_db < queries.sql
📝 Sample Queries Included
Query	Description
queries.sql	All CRUD operations, JOIN queries, reports
sample_data.sql	50+ books, 20 members, 30 borrow records
📈 Features Demonstrated
Basic CRUD: Insert, Update, Delete operations

Advanced Queries:

Find overdue books

Most borrowed books

Member borrowing history

Available books count

Database Optimization:

Indexes on frequently searched columns

Views for common reports

Stored Procedures for repetitive tasks

🤝 Contributing
Feel free to fork this project and add your own features! Some ideas:

Add fine calculation for late returns

Create a dashboard using Python/Streamlit

Add triggers for automatic status updates

📧 Contact
yashfawasem2006@gmail.com

⭐ Show Your Support
If you found this helpful, please give it a star! ⭐
