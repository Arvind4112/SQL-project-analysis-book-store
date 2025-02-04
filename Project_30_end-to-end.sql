CREATE DATABASE project_30;
---------------------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS Books;
CREATE TABLE Books(
Book_ID SERIAL PRIMARY KEY,
Title VARCHAR(110),
Author VARCHAR(110),
Genre VARCHAR(60),
Published_Year INT ,
Price NUMERIC(10,2),
Stock INT
);
SELECT * FROM Books;

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers(
Customer_ID SERIAL PRIMARY KEY,
Name VARCHAR(90),
Email  VARCHAR(150),
Phone VARCHAR(12),
City VARCHAR (50),
Country VARCHAR(150)

);

DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders(
Order_ID SERIAL PRIMARY KEY,
Customer_ID INT REFERENCES Customers(Customer_ID),
Book_ID INT REFERENCES Books(Book_ID),
Order_Date DATE,
Quantity INT,
Total_Amount NUMERIC(10,2)

);
---------------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM Orders;
SELECT * FROM Customers;
SELECT * FROM Books;
---------------------------------------------------------------------------------------------------------------------------------------
COPY Books( Book_ID ,Title,Author,Genre,Published_Year,Price,Stock)
FROM 'C:\Users\arvin\Downloads\Books.csv'
DELIMITER ','
CSV HEADER;

COPY Customers(Customer_ID,Email,Phone,City,Country)
FROM 'C:/Users/arvin/Downloads/Customers.csv'
DELIMITER ','
CSV HEADER;

COPY Orders(Order_ID,Customer_ID,Book_ID,Order_Date,Quantity,Total_Amount)
FROM 'C:Users/arvin/Downloads/Orders.csv'
DELIMITER ','
CSV HEADER;

=======================================================================================================================================

-- Basic Queries
-- 1.)Retrieve all books in the "Fiction" genre
SELECT * FROM Books
WHERE genre='Fiction';

-- 2.)Find books published after the year 1950

SELECT * FROM Books
Where published_year>1950;
-- 3.)List all customers from the Canada
SELECT * FROM Customers
WHERE country='Canada';


-- 4.)Show orders placed in November 2023
SELECT * FROM orders
WHERE order_date BETWEEN '2023-11-01'AND'2023-11-30';

-- 5.)Retrieve the total stock of books available
SELECT   SUM(stock) AS Total_stock 
FROM Books;

-- 6.)Find the details of the most expensive book 
SELECT * FROM Books
ORDER BY price DESC
LIMIT 1;


-- 7.)Show all customers who ordered more than 1 quantity of book

SELECT * FROM orders
WHERE quantity>1;
-- 8.)Retrieve all orders where the total amount exceeds $20
SELECT * FROM orders
WHERE total_amount>20;

-- 9.)List all genres available in the Books table
SELECT genre,books FROM Books;

-- 10.)Find the book with the lowest stock 
SELECT * FROM Books
ORDER BY stock 
limit 5;

-- 11.)Calculate the total revenue generated from all orders
SELECT SUM(total_amount)AS total_revenue
FROM Orders;

==============================================================================================================================================================================================================================================================================

-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:

SELECT b.Genre, SUM(o.Quantity) AS Total_Books_sold
FROM Orders o
JOIN Books b
ON o.book_id = b.book_id
GROUP BY b.Genre;

-- 2) Find the average price of books in the "Fantasy" genre:

SELECT AVG(price) As Average_price  FROM Books
WHERE genre='Fantasy';

-- 3) List customers who have placed at least 2 orders:
SELECT o.customer_id, c.name, COUNT(o.order_id )AS Order_place
FROM orders o
JOIN customers c
ON c.customer_id= o.customer_id
GROUP BY o.customer_id,c.name
HAVING COUNT(o.order_id)>=2;

select * from orders;

-- 4) Find the most frequently ordered book:
SELECT book_id, COUNT(order_id) As Frequentlu_order
FROM orders 
GROUP BY book_id,order_id
ORDER BY Frequentlu_order DESC
limit 10;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :

SELECT * FROM Books
WHERE genre = 'Fantasy' 
ORDER BY price DESC
limit 3;

-- 6) Retrieve the total quantity of books sold by each author:
select * from orders;
 
SELECT SUM(o.quantity) ,b.author AS TOTAL_QUANT 
FROM Books b
JOIN Orders o
ON b.book_id=o.book_id
GROUP BY Quantity,author
ORDER BY Quantity desc;
-- 7) List the cities where customers who spent over $30 are located:

SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount > 30;

-- 8) Find the customer who spent the most on orders:

SELECT  c.customer_id ,c.name,sum(o.total_amount) AS most_order
FROM orders o
JOIN customers c
ON c.customer_id=o.customer_id
GROUP BY c.customer_id,c.name
 ORDER BY most_order desc limit 1;
 
--9) Calculate the stock remaining after fulfilling all orders:

    SELECT b.book_id,b.title,b.stock ,COALESCE(SUM(o.quantity),0)AS new_stock
	,b.stock-COALESCE(SUM(o.quantity),0) AS remaning_stock
	from books b
	LEFT JOIN orders o
	ON o.book_id = b.book_id
	GROUP BY b.book_id
	ORDER BY b.stock desc;
	
=======================================================================================================================================

