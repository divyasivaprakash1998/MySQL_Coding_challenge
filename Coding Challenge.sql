Create Database HospitalDB;
Use HospitalDB;

-- Day 1: Hospital DB
/*-- Question 1: CREATE Table
Scenario: Create a table named Patients with the following fields:
PatientID, PatientName, Age, Gender, AdmissionDate.
Expected Output:
A new table Patients is created successfully. */
Create Table Patients(
PatientID Int,
PatientName Varchar(20),
Age Int,
Gender Varchar(20),
AdmissionDate date default (curdate())
);

/* -- Question 2: ALTER – Add Column
Scenario: Add a new column DoctorAssigned VARCHAR(50) to the Patients table.
Expected Output:
The Patients table now has an additional column DoctorAssigned.*/
Alter Table Patients
Add DoctorAssigned Varchar(50);

/* -- Question 3: ALTER – Modify Column
Scenario: Increase the length of PatientName from VARCHAR(50) to VARCHAR(100).
Expected Output:
The column PatientName now allows up to 100 characters.*/
Alter Table Patients
Modify PatientName Varchar(100);

/* -- Question 4: RENAME Table
Scenario: Rename the table Patients to Patient_Info.
Expected Output:
The table name is successfully changed to Patient_Info.*/
Rename table Patients to Patient_Info;

/*-- Question 5: TRUNCATE vs DROP
Scenario:
At year-end, delete all patient records but keep the table. Later, remove it permanently.
Expected Output:
•    TRUNCATE keeps the structure but clears data.
•    DROP removes the table completely.*/
truncate table Patients;
drop table Patients;


-- Day 2 - Online Bookstore
create database Online_bookstore;
use Online_bookstore;

/* -- Question 1: CREATE TABLE with PRIMARY & FOREIGN KEY
Scenario:
You are creating a database for an online bookstore.
Task:
•	Create a table Books with columns:
o	BookID → INTEGER, PRIMARY KEY
o	Title → VARCHAR(100), NOT NULL
o	Author → VARCHAR(50), NOT NULL
o	ISBN → VARCHAR(20), UNIQUE
o	Price → DECIMAL(8,2), CHECK(Price > 0) */
create table Books(
BookID Int Primary key,
Title varchar(100) NOT NULL,
Author Varchar(50) NOT NULL,
ISBN Varchar(20) UNIQUE,
Price decimal(8,2) check(price>0)
);

describe Books;

/* -- •	Create a table Orders with columns:
o	OrderID → INTEGER, PRIMARY KEY
o	BookID → INTEGER, FOREIGN KEY REFERENCES Books(BookID)
o	OrderDate → DATE, NOT NULL
o	Quantity → INTEGER, CHECK(Quantity > 0) */
Create Table Orders(
OrderID Int Primary Key,
BookID Int,
OrderDate Date Not Null,
Quantity Int Check(Quantity>0),
FOREIGN KEY (BookID) references Books(BookID) -- FK 
);

/* -- Question 2: ALTER TABLE – Add Default Constraint
Scenario:
The bookstore wants to make sure ISBN is Default for every book.
Task:
•	Alter the Books table to add a Default constraint to the ISBN column.
Expected Output:
The ISBN column enforces uniqueness. */
Alter table Books
modify ISBN Varchar(20) UNIQUE Default 'Unknown';

/* -- Question 3: INSERT, RETRIEVE & UPDATE with Constraints
Scenario:
You want to add sample book data and update certain records.
Task:
•	Insert at least 5 records into the Books table, respecting all constraints.
•	Retrieve all records to verify entries.
•	Update the Price or Quantity for a specific record while maintaining the CHECK constraints.
Expected Output:
All entries and updates comply with constraints and are displayed correctly. */

Select * from books;

Insert into Books (BookID, Title, Author, ISBN, Price)
Values
(1, 'Looking for Alaska', 'John', 23, 65.222),
(2, 'Mindset', 'Carol', 34, 434.3),
(3, 'Scars Fade', 'Pawankumar', 43, 543.0),
(4, 'Love the way', 'Dweck', 42, 511),
(5, 'Men with Beard', 'Gwen', 12, 8453);

UPDATE Books
SET Price = 150
WHERE BookID = 1;

Insert into Orders (OrderID, BookID, OrderDate, Quantity)
Values
(101, 1 , '2025-10-02', 23),
(102, 2 , '2025-10-10', 65),
(103, 3 , '2025-10-06', 43),
(104, 4 , '2025-08-02', 90),
(105, 5 , '2025-10-23', 45);

Select * from Orders;
/* Question 4: DELETE vs TRUNCATE
Scenario:
The bookstore wants to manage orders by removing some rows or clearing all data.
Task:
•	Use DELETE with a WHERE clause to remove specific rows from Orders table.
•	Use TRUNCATE to remove all rows while keeping table structure intact.
Expected Output:
•	DELETE removes selected rows.
•	TRUNCATE clears all rows quickly but keeps the table structure.*/
delete from orders 
where OrderID = 103;

Truncate table Orders;

/*-- Day 3
Database: ECommerceDB
Question 1: ORDER BY & LIMIT
Scenario:
Management wants to see the top 3 highest-priced products in the e-commerce system.
Task:
•	Write a SQL query to display the top 3 most expensive products.
•	Sort by price in descending order.
•	Use a LIMIT clause (or equivalent in SQL Server: TOP) to restrict to 3 products.
Expected Output:
Top 3 products with their product_id, product_name, and price.*/
Select * from product;

/* -- Question 2: Aggregate Functions
Scenario:
Management wants summary statistics of the sales data.
Task:
•	Write SQL queries using aggregate functions on the Sales table:
Expected Output:
Aggregated results showing total sales, average sale amount, highest and lowest sale amounts.*/

-- COUNT() → total number of sales records
Select Count(*) as Total_sales from Sales;

-- SUM() → total sales amount
select sum(sale_amount) as Total_sales_amount from Sales;

-- AVG() → average sale amount
Select Round(Avg(Sale_amount),0) as Avg_sales_amount from Sales;

-- MAX() → highest sale amount
Select max(Sale_amount) as Max_Sale_amount from Sales;
-- MIN() → lowest sale amount
Select min(Sale_amount) as Min_Sale_amount from Sales;

/* -- Question 3: GROUP BY & HAVING
Scenario:
Management wants to know which products have total sales amount greater than ₹100.
Task:
•	Use GROUP BY on product_id (or product_name) to calculate total sales per product.
•	Use HAVING to filter products with total sales > 100.
Expected Output:
List of products with product_id, product_name, and total sales amount greater than ₹100*/
Select Product_id, SUM(Sale_amount) as Total_sales_amount
from Sales group by Product_id
Having Total_sales_amount > 100;

/* -- Question 4: Window Functions
Scenario:
Management wants a ranking of products based on their prices.
Task:
•	Write a SQL query using a Window Function (RANK() or DENSE_RANK()) to rank products.
•	Rank products from highest to lowest price.
Expected Output:
Each product with product_id, product_name, price, and rank according to price.*/
Select product_id, product_name, price, row_number() over (order by price desc) as Row_Num from product;
Select product_id, product_name, price, Rank() over (order by price desc) as Price_Rank from product;
Select product_id, product_name, price, dense_rank() over (order by price desc) as Price_dense_rank from product;