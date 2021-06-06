######## 577. Employee Bonus ######## [EASY]

-- Select all employee's name and bonus whose bonus is < 1000. 

# Schema:
drop table if exists Employee;
drop table if exists Bonus;
Create table If Not Exists Employee (EmpId int, Name varchar(255), Supervisor int, Salary int);
Create table If Not Exists Bonus (EmpId int, Bonus int);
insert into Employee (EmpId, Name, Supervisor, Salary) values ('3', 'Brad', null, '4000');
insert into Employee (EmpId, Name, Supervisor, Salary) values ('1', 'John', '3', '1000');
insert into Employee (EmpId, Name, Supervisor, Salary) values ('2', 'Dan', '3', '2000');
insert into Employee (EmpId, Name, Supervisor, Salary) values ('4', 'Thomas', '3', '4000');
insert into Bonus (EmpId, Bonus) values ('2', '500');
insert into Bonus (EmpId, Bonus) values ('4', '2000');

# Solution:
select e.name, b.bonus 
from Employee e 
left join Bonus b on e.empId = b.empId 
where b.bonus < 1000 or b.bonus is null;


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


######## 607. Sales Person ######## [EASY]

-- Given three tables: salesperson, company, orders.
-- Output all the names in the table salesperson, who didn’t have sales to company 'RED'.

# Schema:
drop table if exists salesperson;
drop table if exists company;
drop table if exists orders;
Create table If Not Exists salesperson (sales_id int, name varchar(255), salary int,commission_rate int, hire_date varchar(255));
Create table If Not Exists company (com_id int, name varchar(255), city varchar(255));
Create table If Not Exists orders (order_id int, order_date varchar(255), com_id int, sales_id int, amount int);
insert into salesperson (sales_id, name, salary, commission_rate, hire_date) values ('1', 'John', '100000', '6', '4/1/2006');
insert into salesperson (sales_id, name, salary, commission_rate, hire_date) values ('2', 'Amy', '12000', '5', '5/1/2010');
insert into salesperson (sales_id, name, salary, commission_rate, hire_date) values ('3', 'Mark', '65000', '12', '12/25/2008');
insert into salesperson (sales_id, name, salary, commission_rate, hire_date) values ('4', 'Pam', '25000', '25', '1/1/2005');
insert into salesperson (sales_id, name, salary, commission_rate, hire_date) values ('5', 'Alex', '5000', '10', '2/3/2007');
insert into company (com_id, name, city) values ('1', 'RED', 'Boston');
insert into company (com_id, name, city) values ('2', 'ORANGE', 'New York');
insert into company (com_id, name, city) values ('3', 'YELLOW', 'Boston');
insert into company (com_id, name, city) values ('4', 'GREEN', 'Austin');
insert into orders (order_id, order_date, com_id, sales_id, amount) values ('1', '1/1/2014', '3', '4', '10000');
insert into orders (order_id, order_date, com_id, sales_id, amount) values ('2', '2/1/2014', '4', '5', '5000');
insert into orders (order_id, order_date, com_id, sales_id, amount) values ('3', '3/1/2014', '1', '1', '50000');
insert into orders (order_id, order_date, com_id, sales_id, amount) values ('4', '4/1/2014', '1', '4', '25000');

# Solution:
select s.name 
from salesperson s 
where s.sales_id not in 
(select sales_id 
from orders o left join company c on o.com_id = c.com_id 
where c.name = 'RED') ;


######## 608. Tree Node ######## {MEDIUM} 

-- Given a table tree, id is identifier of the tree node and p_id is its parent node's id.
-- Each node in the tree can be one of three types:
-- Leaf: if the node is a leaf node.
-- Root: if the node is the root of the tree.
-- Inner: If the node is neither a leaf node nor a root node.

-- 			  1
-- 			/   \
-- 		   2      3
-- 		  / \
-- 		 4   5

-- +----+------+
-- | id | p_id |
-- +----+------+
-- | 1  | null |
-- | 2  | 1    |
-- | 3  | 1    |
-- | 4  | 2    |
-- | 5  | 2    |
-- +----+------+

# Schema: 
drop table if exists tree; 
Create table If Not Exists tree (id int, p_id int);
insert into tree (id, p_id) values ('1', null);
insert into tree (id, p_id) values ('2', '1');
insert into tree (id, p_id) values ('3', '1');
insert into tree (id, p_id) values ('4', '2');
insert into tree (id, p_id) values ('5', '2');
select * from tree;

# Solution:
select id, 
case when p_id is null then 'Root' 
when id in (select distinct p_id from tree) then 'Inner' 
else 'Leaf' end as Type 
from tree 
order by 1; 


######## 1112. Highest Grade For Each Student ######## {MEDIUM} 

-- Write a SQL query to find the highest grade with its corresponding course for each student. 
-- In case of a tie, you should find the course with the smallest course_id. The output must be sorted by increasing student_id.

-- Result table:
-- +------------+-------------------+
-- | student_id | course_id | grade |
-- +------------+-----------+-------+
-- | 1          | 2         | 99    |
-- | 2          | 2         | 95    |
-- | 3          | 3         | 82    |
-- +------------+-----------+-------+

# Schema: 
drop table if exists Enrollments; 
Create table If Not Exists Enrollments (student_id int, course_id int, grade int);
insert into Enrollments (student_id, course_id, grade) values ('2', '2', '95');
insert into Enrollments (student_id, course_id, grade) values ('2', '3', '95');
insert into Enrollments (student_id, course_id, grade) values ('1', '1', '90');
insert into Enrollments (student_id, course_id, grade) values ('1', '2', '99');
insert into Enrollments (student_id, course_id, grade) values ('3', '1', '80');
insert into Enrollments (student_id, course_id, grade) values ('3', '2', '75');
insert into Enrollments (student_id, course_id, grade) values ('3', '3', '82');
select * from Enrollments; 

# Solution:
select student_id, course_id, grade 
from 
(
select *, 
rank() over (partition by student_id order by grade desc, course_id) as xrank 
from Enrollments) z 
where xrank = 1 
order by 1; 


######## 1083. Sales Analysis II ######## [EASY]

-- Write an SQL query that reports the buyers who have bought S8 but not iPhone. 
-- Note that S8 and iPhone are products present in the Product table.

# Schema: 
drop table if exists Product;
drop table if exists Sales; 
Create table If Not Exists Product (product_id int, product_name varchar(10), unit_price int);
Create table If Not Exists Sales (seller_id int, product_id int, buyer_id int, sale_date date, quantity int, price int);
insert into Product (product_id, product_name, unit_price) values ('1', 'S8', '1000');
insert into Product (product_id, product_name, unit_price) values ('2', 'G4', '800');
insert into Product (product_id, product_name, unit_price) values ('3', 'iPhone', '1400');
insert into Sales (seller_id, product_id, buyer_id, sale_date, quantity, price) values ('1', '1', '1', '2019-01-21', '2', '2000');
insert into Sales (seller_id, product_id, buyer_id, sale_date, quantity, price) values ('1', '2', '2', '2019-02-17', '1', '800');
insert into Sales (seller_id, product_id, buyer_id, sale_date, quantity, price) values ('2', '1', '3', '2019-06-02', '1', '800');
insert into Sales (seller_id, product_id, buyer_id, sale_date, quantity, price) values ('3', '3', '3', '2019-05-13', '2', '2800');
select * from Product;
select * from Sales; 

# Solution:
select s.buyer_id 
from Sales s 
inner join Product p on s.product_id = p.product_id 
group by 1 
having sum(case when p.product_name = 'S8' then 1 else 0 end) > 0 
and sum(case when p.product_name = 'iPhone' then 1 else 0 end) = 0; 


######## 1113. Reported Posts ######## [EASY]

-- Write an SQL query that reports the number of posts reported yesterday for each report reason. Assume today is 2019-07-05. 

-- Result table:
-- +---------------+--------------+
-- | report_reason | report_count |
-- +---------------+--------------+
-- | spam          | 1            |
-- | racism        | 2            |
-- +---------------+--------------+ 

# Schema: 
drop table if exists Actions; 
Create table If Not Exists Actions (user_id int, post_id int, action_date date, action ENUM('view', 'like', 'reaction', 'comment', 'report', 'share'), extra varchar(10));
insert into Actions (user_id, post_id, action_date, action, extra) values ('1', '1', '2019-07-01', 'view', 'None');
insert into Actions (user_id, post_id, action_date, action, extra) values ('1', '1', '2019-07-01', 'like', 'None');
insert into Actions (user_id, post_id, action_date, action, extra) values ('1', '1', '2019-07-01', 'share', 'None');
insert into Actions (user_id, post_id, action_date, action, extra) values ('2', '4', '2019-07-04', 'view', 'None');
insert into Actions (user_id, post_id, action_date, action, extra) values ('2', '4', '2019-07-04', 'report', 'spam');
insert into Actions (user_id, post_id, action_date, action, extra) values ('3', '4', '2019-07-04', 'view', 'None');
insert into Actions (user_id, post_id, action_date, action, extra) values ('3', '4', '2019-07-04', 'report', 'spam');
insert into Actions (user_id, post_id, action_date, action, extra) values ('4', '3', '2019-07-02', 'view', 'None');
insert into Actions (user_id, post_id, action_date, action, extra) values ('4', '3', '2019-07-02', 'report', 'spam');
insert into Actions (user_id, post_id, action_date, action, extra) values ('5', '2', '2019-07-04', 'view', 'None');
insert into Actions (user_id, post_id, action_date, action, extra) values ('5', '2', '2019-07-04', 'report', 'racism');
insert into Actions (user_id, post_id, action_date, action, extra) values ('5', '5', '2019-07-04', 'view', 'None');
insert into Actions (user_id, post_id, action_date, action, extra) values ('5', '5', '2019-07-04', 'report', 'racism');
select * from Actions; 

# Solution:
select extra as report_reason, count(distinct post_id) as report_count 
from Actions 
where action = 'report' 
and action_date = cast(date('2019-07-05')-1 as date) 
group by 1 
order by 2 desc;


######## 1164. Product Price at a Given Date ######## {MEDIUM}

-- Write an SQL query to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10.

# Schema:
drop table if exists Products;
Create table If Not Exists Products (product_id int, new_price int, change_date date);
insert into Products (product_id, new_price, change_date) values ('1', '20', '2019-08-14');
insert into Products (product_id, new_price, change_date) values ('2', '50', '2019-08-14');
insert into Products (product_id, new_price, change_date) values ('1', '30', '2019-08-15');
insert into Products (product_id, new_price, change_date) values ('1', '35', '2019-08-16');
insert into Products (product_id, new_price, change_date) values ('2', '65', '2019-08-17');
insert into Products (product_id, new_price, change_date) values ('3', '20', '2019-08-18');
select * from Products; 

# Solution:
select distinct a.product_id, coalesce(b.new_price, 10) as price 
from Products a left join 
(select product_id, rank() over(partition by product_id order by change_date desc) as xrank, new_price 
from Products 
where change_date <= '2019-08-16') as b 
on a.product_id = b.product_id and b.xrank = 1 
order by 2 desc; 


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







