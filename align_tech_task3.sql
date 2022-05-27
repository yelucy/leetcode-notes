# Align Technology Task 3 

# 
-- Implement a SQL query for a report that will provide the following information: 
	-- for each customer output top 5 dates which contain the highest mean amount.

# Output: 
-- customer_name	order_date	mean_amt
-- Bond, James	1/10/2011	32041
-- Bond, James	2/5/2011	33229
-- Bond, James	3/19/2011	30526
-- Bond, James	3/25/2011	36804
-- Bond, James	3/29/2011	33545
-- Dow, Jones	1/2/2011	34674
-- Dow, Jones	1/5/2011	33128
-- Dow, Jones	1/15/2011	39672
-- Dow, Jones	1/26/2011	39939
-- Dow, Jones	2/2/2011	19912
-- McCormick, Kenny	1/22/2011	39138
-- McCormick, Kenny	2/5/2011	31609
-- McCormick, Kenny	2/17/2011	19982
-- McCormick, Kenny	3/19/2011	32874
-- McCormick, Kenny	3/24/2011	34659

             
# Schema: 
drop table if exists customer;
create table if not exists customer (customer_id int, customer_name varchar(256)); 
insert into customer (customer_id, customer_name) values (1, 'Bond, James'); 
insert into customer (customer_id, customer_name) values (2, 'Dow, Jones'); 
insert into customer (customer_id, customer_name) values (3, 'McCormick, Kenny'); 
select * from customer;

drop table if exists purchase_order; 
create table if not exists purchase_order (purchase_order_id int, customer_id int, amount int, order_date date); 
insert into purchase_order (purchase_order_id, customer_id, amount, order_date) values (101, 1, 32040, '2011-01-10'); 
insert into purchase_order (purchase_order_id, customer_id, amount, order_date) values (102, 1, 32042, '2011-01-10'); 
insert into purchase_order (purchase_order_id, customer_id, amount, order_date) values (103, 1, 33229, '2011-02-05'); 
insert into purchase_order (purchase_order_id, customer_id, amount, order_date) values (104, 1, 30526, '2011-03-19'); 
insert into purchase_order (purchase_order_id, customer_id, amount, order_date) values (105, 1, 36804, '2011-03-25'); 
insert into purchase_order (purchase_order_id, customer_id, amount, order_date) values (106, 1, 33545, '2011-03-29'); 
insert into purchase_order (purchase_order_id, customer_id, amount, order_date) values (107, 1, 11922, '2011-03-08'); 
insert into purchase_order (purchase_order_id, customer_id, amount, order_date) values (108, 2, 34674, '2011-01-02'); 
insert into purchase_order (purchase_order_id, customer_id, amount, order_date) values (109, 2, 33128, '2011-01-05'); 
insert into purchase_order (purchase_order_id, customer_id, amount, order_date) values (110, 2, 39672, '2011-01-15'); 
insert into purchase_order (purchase_order_id, customer_id, amount, order_date) values (111, 2, 39939, '2011-01-26'); 
insert into purchase_order (purchase_order_id, customer_id, amount, order_date) values (112, 2, 19911, '2011-02-02'); 
insert into purchase_order (purchase_order_id, customer_id, amount, order_date) values (113, 2, 19913, '2011-02-02'); 
select * from purchase_order; 


-- WITH customer_purchases AS 
-- (
-- SELECT b.customer_name, a.order_date, AVG(a.amount) AS mean_amt 
-- FROM purchase_order a 
-- LEFT JOIN customer b 
-- ON a.customer_id = b.customer_id 
-- ) 

WITH customer_purchases AS (
SELECT *, ROW_NUMBER() OVER (
	PARTITION BY c.customer_name 
	ORDER BY c.mean_amt DESC 
) AS row_order 
FROM 
(SELECT b.customer_name, a.order_date, AVG(a.amount) AS mean_amt 
	FROM purchase_order a 
	LEFT JOIN customer b 
		ON a.customer_id = b.customer_id 
	GROUP BY 1,2  
) c 
) 

SELECT customer_name, order_date, mean_amt 
FROM customer_purchases   
WHERE row_order <= 5 
ORDER BY customer_name, order_date 
;

-- SELECT customer_name, order_date, format(mean_amt, 'C4') 
-- FROM customer_purchases   
-- WHERE row_order <= 5 
-- ORDER BY customer_name, order_date 
-- ;




