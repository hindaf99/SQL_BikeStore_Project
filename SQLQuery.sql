--Sales Analysis
     -- Total Sales per Customer
     -- Top 5 Products by Sales Volume
     --  Monthly Sales Trend
     -- Sales by Store

--1. Total Sales per Customer

SELECT c.customer_id, c.first_name, c.last_name, SUM(oi.list_price* oi.quantity) as Totel_Sales
from customers c
JOIN orders o ON 
c.customer_id= o.customer_id
JOIN order_items oi ON 
o.order_id = oi.order_id

GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY Totel_Sales desc

--2.  Top 5 Products by Sales Volume:

SELECT TOP 5 p.product_name, SUM(oi.quantity) AS Total_Quantity
FROM products p
JOIN order_items oi ON 
p.product_id = oi.product_id
GROUP BY product_name
ORDER BY Total_Quantity desc


--3. Monthly Sales Trend:

SELECT FORMAT (o.order_date, 'yyyy-MM') AS Month, ROUND(SUM(oi.list_price * oi.quantity),2) AS Total_Sales
FROM orders o
JOIN order_items oi ON 
o.order_id= oi.order_id
GROUP BY FORMAT (o.order_date, 'yyyy-MM')
ORDER BY Total_Sales desc

--4.Sales by Store:
   
SELECT s.store_name, ROUND(SUM(oi.quantity * oi.list_price),2) AS Total_Sales
FROM stores s
JOIN orders o ON
o.store_id= s.store_id
JOIN order_items oi ON 
oi.order_id = o.order_id
GROUP BY s.store_name
ORDER BY Total_Sales

--Customer Analysis
    -- Top 5 Customers by Number of Orders
    -- Customer Purchase Frequency
   
--1.	Top 5 Customers by Number of Orders:

SELECT top 5 c.first_name, c.last_name, count(o.order_id) AS Number_Of_Orders
FROM customers c
JOIN orders o ON
c.customer_id= o.customer_id
GROUP BY c.first_name, c.last_name
ORDER BY Number_Of_Orders DESC

--2.	Customer Purchase Frequency:
   
SELECT c.customer_id, c.first_name, c.last_name, COUNT(o.order_id) AS number_of_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY number_of_orders DESC;

--Product and Inventory Analysis
   --	Stock Level by Store:
   --	Products Below Minimum Stock Level:

--1.	Stock Level by Store:

SELECT s.store_name, sum(t.quantity) AS Stock_Level
FROM stores s
JOIN stocks t ON
s.store_id= t.store_id
GROUP BY s.store_name
ORDER BY Stock_Level


--2.	Products Below Minimum Stock Level:

SELECT p.product_name, SUM(s.quantity) AS Total_quantity
FROM products p
JOIN stocks s ON
p.product_id= s.product_id
GROUP BY p.product_name
HAVING  SUM(s.quantity) <10 
ORDER BY Total_quantity


--Staff and Store Performance
    --Sales Performance by Staff:
    --Top Performing Stores:

--1. Sales Performance by Staff:

SELECT s.first_name, s.last_name,COUNT(o.order_id) AS Number_Order_Sold, ROUND(SUM(oi.quantity*oi.list_price),2) AS Total_Sales 
FROM staffs s
JOIN orders o ON
s.staff_id= o.staff_id
JOIN order_items oi ON
o.order_id = oi.order_id
GROUP BY s.first_name, s.last_name
ORDER BY Total_Sales  DESC

--2.Top Performing Stores:

SELECT s.store_name, round(SUM(oi.quantity * oi.list_price), 2)AS Total_Store_Sales 
FROM stores s
JOIN orders o ON
s.store_id = o.store_id
JOIN order_items oi ON
o.order_id = oi.order_id
GROUP BY s.store_name
ORDER BY Total_Store_Sales  DESC 

--Miscellaneous
     --List of Orders with Product Details:
     -- Orders Not Shipped on Time:

--1.List of Orders with Product Details
   
SELECT o.order_id, o.order_date, c.first_name,c.last_name, p.product_name, g.category_name
FROM orders o
JOIN customers c ON
o.customer_id= c.customer_id 
JOIN order_items oi ON 
oi.order_id= o.order_id
JOIN products p ON
p.product_id= oi.product_id 
JOIN categories g ON 
p.category_id  = g.category_id 

--2. Orders Not Shipped on Time:

SELECT o.order_id, o.required_date, o.shipped_date, c.first_name, c.last_name
FROM orders o
JOIN customers c ON
c.customer_id = o.customer_id 
WHERE o.shipped_date > o.required_date  
ORDER BY o.required_date 
