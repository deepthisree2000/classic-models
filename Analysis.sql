use classicmodels;
show tables;
/* 1.what the population of the database looks like. 
     How many rows are in each table in the database?*/
SELECT 'Customers' AS 'Table', COUNT(*) AS Num_of_Rows FROM customers
UNION
SELECT 'Employees' AS 'Table', COUNT(*) AS Num_of_Rows FROM employees
UNION
SELECT 'Offices' AS 'Table', COUNT(*) AS Num_of_Rows FROM offices
UNION
SELECT 'Order Details' AS 'Table', COUNT(*) AS Num_of_Rows FROM orderdetails
UNION
SELECT 'Orders' AS 'Table', COUNT(*) AS Num_of_Rows FROM orders
UNION
SELECT 'Payments' AS 'Table', COUNT(*) AS Num_of_Rows FROM payments
UNION
SELECT 'Product Lines' AS 'Table', COUNT(*) AS Num_of_Rows FROM productlines
UNION
SELECT 'Products' AS 'Table', COUNT(*) AS Num_of_Rows FROM products;

/* 2.Which country has high number of customers?*/
select country,count(customernumber)AS No_of_customers
from customers 
group by country
order by No_of_customers desc;

/*3. Report the number of customers in New Zealand, Norway, and Sweden.*/
select country,count(customernumber)AS No_of_customers
from customers
where country in('New Zealand','Norway','Sweden')
group by country;

/*4. How many employees are there in the company.*/
SELECT count(*) As 'Employees_Count'
from employees;

/*5. Count of orders for each product and which product has highest orders Count?.*/
select od.productcode,p.productline,count(od.ordernumber)No_of_orders
from orderdetails od
join products p
on od.productcode=p.productcode
group by od.productcode
order by No_of_orders desc ;

/*6. which orders have a value greater than $5,000.*/
SELECT orderNumber,round(sum(priceEach*quantityOrdered),2) AS order_value
from orderdetails
group by orderNumber
having order_value > 5000
order by order_value desc;

/*7.Count of orders based on their status total. 326 orders*/
select status,count(ordernumber) No_of_orders
from orders
group by status;

/*8.Which month has the most total items ordered?*/
SELECT  monthname(ord.orderDate)Month_name,
        SUM(quantityOrdered) AS TotalQuantityOrdered
FROM    (SELECT  orderNumber,orderDate,quantityOrdered
		 FROM    orders
		 JOIN orderdetails 
		 USING (orderNumber)) AS ord
GROUP BY    month_name
ORDER BY  TotalQuantityOrdered DESC;

/*9.Over the three years where data was collected, how many orders were there per year?*/
SELECT  YEAR(orderDate) AS orderYear,COUNT(*) No_of_Orders
FROM    orders 
GROUP BY orderYear
order by No_of_Orders desc;

/*10.what was the total revenue each year.*/
select year(paymentdate)Year_No,round(sum(amount),2)Total_revenue
from payments 
group by year(paymentdate)
order by Total_revenue desc;

/*11.Which product line has the highest sales volume?*/
SELECT  productLine,
        round(quantityOrdered*priceEach,2) AS TotalSalesVolume
FROM    productlines
        JOIN products USING (productLine)
        JOIN orderdetails USING (productCode)
GROUP BY    productLine
ORDER BY    TotalSalesVolume DESC;

/*12.Which product line has the highest quantity in stock?*/
SELECT  productLine,
        SUM(quantityInStock) AS TotalQuantityInStock
FROM    productlines
        JOIN products USING (productLine)
GROUP BY    productLine
ORDER BY    TotalQuantityInStock DESC;

/*13.Count of  products in each product line*/
SELECT productLine,count(*) As 'Count_Of_Products'
FROM products
GROUP BY productLine
ORDER BY count(*) DESC;

/*14.What is the average percentage markup of the MSRP on buyPrice ?*/
select round(AVG((MSRP-buyPrice)/MSRP)*100,2) Average_Percentage_Markup
from products;

/*15. Report total payments for november 28,2004*/
SELECT sum(amount) As 'Amount for 28th November 2004'
from payments
WHERE paymentDate = '2004-11-28';

/*16.List products sold by order date. 146 rows*/
SELECT productName , orderDate , DAYNAME(orderDate) As 'DayName'
FROM products
INNER JOIN orderdetails
ON products.productCode = orderdetails.productCode
INNER JOIN Orders
ON orderdetails.orderNumber = orders.orderNumber
 WHERE DAYNAME(Orders.orderDate) = 'Saturday';
 
 /*17.list all the payments greater than twice the average amount ? 13 rows*/
SELECT *
FROM payments
WHERE amount > 2 * (SELECT AVG(amount) FROM payments)
order by amount desc;

/*18.List the names of products sold at less than 85% of the MSRP (manufacturer suggested retail price). 109 rows*/
SELECT distinct products.productName, products.MSRP
FROM products
JOIN orderdetails 
ON products.productCode = orderdetails.productCode
WHERE orderdetails.priceEach < (0.85*products.MSRP)
ORDER BY products.MSRP DESC;

/*19.Which employees have the highest total sales volumes?*/
SELECT  salesRepEmployeeNumber,employees.lastName,
        employees.firstName,round(SUM(quantityOrdered*priceEach),2)  TotalSales
FROM    orderdetails 
        JOIN orders USING (orderNumber)
        JOIN customers USING (customerNumber)
        JOIN employees ON
        customers.salesRepEmployeeNumber = employees.employeeNumber
GROUP BY    salesRepEmployeeNumber
ORDER BY    totalSales DESC;

/*20.List all the products purchased by Herkku Gifts.*/
select  od.productcode,sum(od.quantityordered)
from orderdetails od,
(select c.customerNumber,c.customerName,o.orderNumber
from customers c
join orders o
on c.customernumber=o.customerNumber
where c.customername='Herkku Gifts') HG 
group by od.productcode ;





