-- restaurant database

-- 5 tables
-- write 3-5 queries
-- 1x WITH
-- 1x SUBQUERY
-- 1x Aggregate Function

.open restaurant.db
DROP table Menus;
DROP table Customers;
DROP table Orders;
DROP table Park_Car;

create table if not exists Menus (
  menus_id int,
  price_id int,
  name char,
  type char,
  price int
);

create table if not exists Customers (
  customers_id int,
  phone char,
  name char
);

create table if not exists Orders (
  order_id int,
  menus_id int,
  customers_id int,
  menus_name char,
  amount int,
  payment_type char
);

create table if not exists Park_Car (
  park_id int,
  customers_id int,
  location char,
  type char
);

insert into Menus (menus_id, price_id, name, type, price) values
(1, 1, 'Somtum Thai', 'Somtum', 60),
(2, 2, 'Somtum Laos', 'Somtum', 50),
(3, 3, 'Somtum Korat', 'Somtum', 60),
(4, 4, 'Somtum Pu', 'Somtum', 60),
(5, 5, 'Grilled Chicken', 'Grilled', 150),
(6, 6, 'Grilled Catfish', 'Grilled', 50),
(7, 7, 'Shimp Tomyum', 'Boiled', 200),
(8, 8, 'Padthai', 'Fried', 90),
(9, 9, 'Fried pork with basil', 'Fried', 70),
(10, 10, 'Sticky rice', 'Rice', 30);

insert into Customers (customers_id, phone, name) values
(1, '091-565-9565', 'Dum'),
(2, '069-741-8523', 'Anna'),
(3, '063-215-9514', 'Thong'),
(4, '087-953-9954', 'Mod'),
(5, '082-025-7498', 'Daeng'),
(6, '093-441-7789', 'Marry'),
(7, '095-236-6587', 'John'),
(8, '067-723-7495', 'Lukus'),
(9, '094-761-7325', 'Mam'),
(10, '096-994-9761', 'James');

insert into Orders (order_id, menus_id, customers_id, menus_name, amount, payment_type) values
(1, 1, 1, 'Somtum Thai', 60, 'Credit'),
(1, 2, 1, 'Somtum Laos', 50, 'Credit'),
(1, 5, 1, 'Grilled Chicken', 150, 'Credit'),
(1, 8, 1, 'Padthai', 90, 'Credit'),
(1, 10, 1, 'Sticky rice', 30, 'Credit'),
(2, 3, 2, 'Somtum Korat', 60, 'Prompt Pay'),
(2, 6, 2, 'Grilled Catfish', 50, 'Prompt Pay'),
(2, 7, 2, 'Shimp Tomyum', 200, 'Prompt Pay'),
(2, 9, 2, 'Fried pork with basil', 70, 'Prompt Pay'),
(3, 4, 3, 'Somtum Pu', 60, 'Cash'),
(3, 9, 3, 'Fried pork with basil', 70, 'Cash'),
(4, 9, 4, 'Fried pork with basil', 70, 'Cash'),
(5, 1, 5, 'Somtum Thai', 60, 'Cash'),
(5, 2, 5, 'Somtum Laos', 50, 'Cash'),
(5, 10, 5, 'Sticky rice', 30, 'Cash'),
(6, 1, 6, 'Somtum Thai', 60, 'Credit'),
(6, 7, 6, 'Shimp Tomyum', 200, 'Credit'),
(6, 9, 6, 'Fried pork with basil', 70, 'Credit'),
(7, 9, 7, 'Fried pork with basil', 70, 'Prompt Pay'),
(8, 9, 8, 'Fried pork with basil', 70, 'Prompt Pay'),
(9, 9, 9, 'Fried pork with basil', 70, 'Cash'),
(10, 9, 10, 'Fried pork with basil', 70, 'Cash');

insert into Park_Car (park_id, customers_id, location, type) values
(1, 1, 'A01', 'VIP'),
(2, 2, 'A02', 'VIP'),
(3, 3, 'B', 'Regular'),
(4, 4, 'B', 'Regular'),
(5, 5, 'A03', 'VIP'),
(6, 6, 'B', 'Regular'),
(7, 7, 'B', 'Regular'),
(8, 8, 'A04', 'VIP'),
(9, 9, 'B', 'Regular'),
(10, 10, 'B', 'Regular');

-- Query 1 -------------------------------------------------------------
-- Find total amount of each order
with a as(
  select * from Customers
  join Orders
  on Customers.customers_id = Orders.customers_id
)
select phone, name, menus_name, sum(amount) as total_amount, payment_type
from a
group by customers_id;

-- -- Query 2 -------------------------------------------------------------
-- Find top 3 sales orders
SELECT * FROM  (
select COUNT(*) as total_sales, menus_name
from Orders 
GROUP by menus_name
order BY 1 DESC
LIMIT 3 );

-- Query 3 -------------------------------------------------------------
-- Categorize of customers type
SELECT *,
	case 
    WHEN total_prices < 150 THEN 'Regular' 
    ELSE 'VIP' 
    END as new_type
FROM (
SELECT SUM(amount) as total_prices, Orders.customers_id, menus_name, Park_Car.type, Customers.name
FROM Orders
JOIN Park_Car 
  ON Orders.customers_id = Park_Car.customers_id 
JOIN Customers
  ON Orders.customers_id = Customers.customers_id 
GROUP by order_id
 ) ORDER BY total_prices DESC;