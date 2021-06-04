######## 586. Customer Placing the Largest Number of Orders ######## [EASY]

-- Write an SQL query to find the customer_number for the customer who has placed the largest number of orders.
-- It is guaranteed that exactly one customer will have placed more orders than any other customer.

# Schema: 
drop table if exists orders;
Create table orders (order_number int, customer_number int);
insert into orders (order_number, customer_number) values ('1', '1');
insert into orders (order_number, customer_number) values ('2', '2');
insert into orders (order_number, customer_number) values ('3', '3');
insert into orders (order_number, customer_number) values ('4', '3');
select * from orders;

# Solution: 
select customer_number from(
select customer_number, count(order_number) as orders, max(count(order_number)) over () as max_orders 
from orders 
group by 1 
order by 2 desc) z 
where z.orders=z.max_orders;


######## 1270. All People Report to the Given Manager ######## {MEDIUM} 

-- Write an SQL query to find employee_id of all employees that directly or indirectly report their work to the head of the company.
-- The indirect relation between managers will not exceed 3 managers as the company is small.
-- Return result table in any order without duplicates.


# Schema: 
drop table if exists Employees; 
Create table If Not Exists Employees (employee_id int, employee_name varchar(30), manager_id int); 
insert into Employees (employee_id, employee_name, manager_id) values ('1', 'Boss', '1');
insert into Employees (employee_id, employee_name, manager_id) values ('3', 'Alice', '3');
insert into Employees (employee_id, employee_name, manager_id) values ('2', 'Bob', '1');
insert into Employees (employee_id, employee_name, manager_id) values ('4', 'Daniel', '2');
insert into Employees (employee_id, employee_name, manager_id) values ('7', 'Luis', '4');
insert into Employees (employee_id, employee_name, manager_id) values ('8', 'John', '3');
insert into Employees (employee_id, employee_name, manager_id) values ('9', 'Angela', '8');
insert into Employees (employee_id, employee_name, manager_id) values ('77', 'Robert', '1');

# Solution: 
select * 
from employees e1 join employees e2 
on e1.manager_id = e2.employee_id 
join employees e3 
on e2.manager_id = e3.employee_id
where e3.manager_id = 1 AND e1.employee_id != 1;





######## 1511. Customer Order Frequency ######## [EASY]

-- Write an SQL query to report the customer_id and customer_name of customers who have spent at least $100 in each month of June and July 2020.
-- Return the result table in any order.

# Schema: 
drop table if exists Customers;
drop table if exists Product;
drop table if exists Orders;
Create table If Not Exists Customers (customer_id int, cname varchar(30), country varchar(30));
Create table If Not Exists Product (product_id int, description varchar(30), price int);
Create table If Not Exists Orders (order_id int, customer_id int, product_id int, order_date date, quantity int);
insert into Customers (customer_id, cname, country) values ('1', 'Winston', 'USA');
insert into Customers (customer_id, cname, country) values ('2', 'Jonathan', 'Peru');
insert into Customers (customer_id, cname, country) values ('3', 'Moustafa', 'Egypt');
insert into Product (product_id, description, price) values ('10', 'LC Phone', '300');
insert into Product (product_id, description, price) values ('20', 'LC T-Shirt', '10');
insert into Product (product_id, description, price) values ('30', 'LC Book', '45');
insert into Product (product_id, description, price) values ('40', 'LC Keychain', '2');
insert into Orders (order_id, customer_id, product_id, order_date, quantity) values ('1', '1', '10', '2020-06-10', '1');
insert into Orders (order_id, customer_id, product_id, order_date, quantity) values ('2', '1', '20', '2020-07-01', '1');
insert into Orders (order_id, customer_id, product_id, order_date, quantity) values ('3', '1', '30', '2020-07-08', '2');
insert into Orders (order_id, customer_id, product_id, order_date, quantity) values ('4', '2', '10', '2020-06-15', '2');
insert into Orders (order_id, customer_id, product_id, order_date, quantity) values ('5', '2', '40', '2020-07-01', '10');
insert into Orders (order_id, customer_id, product_id, order_date, quantity) values ('6', '3', '20', '2020-06-24', '2');
insert into Orders (order_id, customer_id, product_id, order_date, quantity) values ('7', '3', '30', '2020-06-25', '2');
insert into Orders (order_id, customer_id, product_id, order_date, quantity) values ('9', '3', '30', '2020-05-08', '3');
select * from Customers;
select * from Product;
select * from Orders;

# Solution: 
select c.customer_id, c.cname
from customers c join orders o on c.customer_id = o.customer_id 
join product p on o.product_id = p.product_id 
group by 1,2
having sum(if(order_date between '2020-06-01' and '2020-06-30', quantity, 0)*price) >= 100 
and sum(if(order_date between '2020-07-01' and '2020-07-31', quantity, 0)*price) >= 100; 







