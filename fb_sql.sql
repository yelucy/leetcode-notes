######## Not LC, Search SQL question 1 ######## 

### Table 1: searches. 
### columns:
-- * date (string), date of the search
-- * search_id (int), the unique identifier of each search
-- * user_id (int), the unique identifier of the searcher
-- * age_group (string), ('U30', '30-50', '50+')
-- * search_query (string), the text of the search query

-- Sample Rows:
-- date | search_id | user_id | age_group | search_query
-- -----------------------------------------------------------------------------------------
-- ‘2020-01-01’  |      101      | 9991     | 'U30'   |   ‘michael jackson’
-- ‘2020-01-01’  |      102      | 9991     |   ‘U30’   |   ‘menlo park’
-- ‘2020-01-01’  |      103      | 5555     |   ’30-50’ |   ‘john’
-- ‘2020-01-01’  |      104      | 1234     |   ‘50+’   |   ‘funny dogs’

### Table 2: search_results
### columns:
-- * date (string), date of the search action
-- * search_id (int), the unique identifier of each search
-- * result_id (int), the unique identifier of the result
-- * result_type (string), ('page', 'event', 'group','person','post', etc.)
-- * clicked (boolean), did the user click on the result?

-- Sample Rows:
-- date | search_id | result_id | result_type | clicked
-- ---------------------------------------------------------------------------------------
-- ‘2020-01-01’ | 101 | 1001 | ‘page’   |   TRUE
-- ‘2020-01-01’ | 101 | 1002 | ‘event’   |   FALSE
-- ‘2020-01-01’ | 101 | 1003 | 'event’ |   FALSE
-- ‘2020-01-01’ | 101 | 1004 | ‘group' |   FALSE


# Schema:
drop table if exists searches;
drop table if exists search_results;
create table if not exists searches (date varchar(255), search_id int, user_id int, age_group varchar(255), search_query varchar(255));
create table if not exists search_results (date varchar(255), search_id int, result_id int, result_type varchar(255), clicked varchar(255));
insert into searches (date, search_id, user_id, age_group, search_query) values ('2020-01-01', 101, 9991, 'U30', 'michael jackson');
insert into searches (date, search_id, user_id, age_group, search_query) values ('2020-01-01', 102, 9991, 'U30', 'menlo park');
insert into searches (date, search_id, user_id, age_group, search_query) values ('2020-01-01', 103, 5555, '30-50', 'john');
insert into searches (date, search_id, user_id, age_group, search_query) values ('2020-01-15', 104, 8792, '30-50', 'john');
insert into searches (date, search_id, user_id, age_group, search_query) values ('2020-01-01', 105, 1234, '50+', 'funny dogs');
insert into search_results (date, search_id, result_id, result_type, clicked) values ('2020-01-01', 101, 1001, 'page', 'TRUE');
insert into search_results (date, search_id, result_id, result_type, clicked) values ('2020-01-01', 101, 1002, 'event', 'FALSE');
insert into search_results (date, search_id, result_id, result_type, clicked) values ('2020-01-01', 101, 1003, 'event', 'FALSE');
insert into search_results (date, search_id, result_id, result_type, clicked) values ('2020-01-01', 101, 1004, 'group', 'FALSE');
select * from searches;
select * from search_results; 

### Q1: by each age group, how many unique users searched for "john" in the last 7 days?

select age_group, count(distinct user_id) as unique_users 
from searches 
where search_query = 'john' and cast(date as date) >= date_add('2020-01-06', interval -7 day) and cast(date as date) < '2020-01-06' 
group by age_group;


### Q2: what are the top 10 search terms that are most likely to return at least one result about an Event?

select search_query, sum(case when result_type = 'event' then 1 else 0 end)/count(distinct search_id) as prob 
from (
SELECT distinct result_type, a.search_id, search_query  
FROM search_results AS a 
LEFT JOIN searches AS b
ON a.search_id = b.search_id) as c 
group by search_query 
order by prob desc 
limit 10; 



######## Not LC, Search SQL question 2 ######## 

-- Table:
-- searches

-- Sample Rows:
-- date         | search_id |  user_id  | age_group | search_query
-- --------------------------------------------------------------------
-- '2020-01-01' |    101    |   9991    |  '<30'    |  'justin bieber'
-- '2020-01-01' |    102    |   9991    |  '<30'    |  'menlo park'  
-- '2020-01-01' |    103    |   5555    |  '30-50'  |  'john'
-- '2020-01-01' |    104    |   1234    |  '50+'    |  'funny cats'

-- Table:
-- search_results 

-- Sample Rows:
-- date         | search_id | result_id | result_type | clicked
-- --------------------------------------------------------------------
-- '2020-01-01' |    101    |    1001   |   'page'    |  TRUE
-- '2020-01-01' |    101    |    1002   |   'event'   |  FALSE
-- '2020-01-01' |    101    |    1003   |   'event'   |  FALSE
-- '2020-01-01' |    101    |    1004   |   'group'   |  FALSE


### Q1. Over the last 7 days, how many users made more than 10 searches?


### Q2. What % of searchers today (users that searched today) have clicked on a 'group' result?






######## 176. Second Highest Salary ######## [EASY]

-- Write a SQL query to get the second highest salary from the Employee table.

-- +----+--------+
-- | Id | Salary |
-- +----+--------+
-- | 1  | 100    |
-- | 2  | 200    |
-- | 3  | 300    |
-- +----+--------+

# Output:
-- +---------------------+
-- | SecondHighestSalary |
-- +---------------------+
-- | 200                 |
-- +---------------------+

# Schema:
drop table if exists Employee;
Create table If Not Exists Employee (Id int, Salary int);
Truncate table Employee;
insert into Employee (Id, Salary) values ('1', '100');
insert into Employee (Id, Salary) values ('2', '200');
insert into Employee (Id, Salary) values ('3', '300');
select * from Employee; 

# Solution:
select( 
select distinct Salary 
from Employee 
order by Salary desc 
limit 1 offset 1)
as SecondHighestSalary;


######## 177. Nth Highest Salary ######## {MEDIUM}

-- Write a SQL query to get the nth highest salary from the Employee table.

-- +----+--------+
-- | Id | Salary |
-- +----+--------+
-- | 1  | 100    |
-- | 2  | 200    |
-- | 3  | 300    |
-- +----+--------+

# Output:
-- +------------------------+
-- | getNthHighestSalary(2) |
-- +------------------------+
-- | 200                    |
-- +------------------------+

# Schema:
drop table if exists Employee;
Create table If Not Exists Employee (Id int, Salary int);
Truncate table Employee;
insert into Employee (Id, Salary) values ('1', '100');
insert into Employee (Id, Salary) values ('2', '200');
insert into Employee (Id, Salary) values ('3', '300');
select * from Employee; 

# Solution:
DELIMITER $$
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  RETURN (
      # Write your MySQL query statement below.
      select if(count(*)<N,null,min(s.Salary))
      from 
      (select distinct Salary
      from Employee
      order by Salary DESC
      limit 0,N) s
  ); 
END$$
DELIMITER ;

select getNthHighestSalary(2) from Employee; 


######## 183. Customers Who Never Order ######## [EASY]

-- Suppose that a website contains two tables, the Customers table and the Orders table. 
-- Write a SQL query to find all customers who never order anything.

-- Table: Customers
-- +----+-------+
-- | Id | Name  |
-- +----+-------+
-- | 1  | Joe   |
-- | 2  | Henry |
-- | 3  | Sam   |
-- | 4  | Max   |
-- +----+-------+

-- Table: Orders 
-- +----+------------+
-- | Id | CustomerId |
-- +----+------------+
-- | 1  | 3          |
-- | 2  | 1          |
-- +----+------------+

# Schema:
drop table if exists Customers;
drop table if exists Orders;
Create table If Not Exists Customers (Id int, Name varchar(255));
Create table If Not Exists Orders (Id int, CustomerId int);
Truncate table Customers;
insert into Customers (Id, Name) values ('1', 'Joe');
insert into Customers (Id, Name) values ('2', 'Henry');
insert into Customers (Id, Name) values ('3', 'Sam');
insert into Customers (Id, Name) values ('4', 'Max');
Truncate table Orders;
insert into Orders (Id, CustomerId) values ('1', '3');
insert into Orders (Id, CustomerId) values ('2', '1');
select * from Customers;
select * from Orders; 

# Solution: 
select Name as Customers 
from Customers c left join Orders o on c.Id = o.CustomerId 
where CustomerId is null;


######## 185. Department Top Three Salaries ######## <HARD>

-- A company's executives are interested in seeing who earns the most money in each of the company's departments. 
-- A high earner in a department is an employee who has a salary in the top three unique salaries for that department.

-- Write an SQL query to find the employees who are high earners in each of the departments.

-- Return the result table in any order.

-- Employee table:
-- +----+-------+--------+--------------+
-- | Id | Name  | Salary | DepartmentId |
-- +----+-------+--------+--------------+
-- | 1  | Joe   | 85000  | 1            |
-- | 2  | Henry | 80000  | 2            |
-- | 3  | Sam   | 60000  | 2            |
-- | 4  | Max   | 90000  | 1            |
-- | 5  | Janet | 69000  | 1            |
-- | 6  | Randy | 85000  | 1            |
-- | 7  | Will  | 70000  | 1            |
-- +----+-------+--------+--------------+

-- Department table:
-- +----+-------+
-- | Id | Name  |
-- +----+-------+
-- | 1  | IT    |
-- | 2  | Sales |
-- +----+-------+

-- Result table:
-- +------------+----------+--------+
-- | Department | Employee | Salary |
-- +------------+----------+--------+
-- | IT         | Max      | 90000  |
-- | IT         | Joe      | 85000  |
-- | IT         | Randy    | 85000  |
-- | IT         | Will     | 70000  |
-- | Sales      | Henry    | 80000  |
-- | Sales      | Sam      | 60000  |
-- +------------+----------+--------+

# Schema: 
drop table if exists Employee;
drop table if exists Department; 
Create table If Not Exists Employee (Id int, Name varchar(255), Salary int, DepartmentId int);
Create table If Not Exists Department (Id int, Name varchar(255));
Truncate table Employee;
insert into Employee (Id, Name, Salary, DepartmentId) values ('1', 'Joe', '85000', '1');
insert into Employee (Id, Name, Salary, DepartmentId) values ('2', 'Henry', '80000', '2');
insert into Employee (Id, Name, Salary, DepartmentId) values ('3', 'Sam', '60000', '2');
insert into Employee (Id, Name, Salary, DepartmentId) values ('4', 'Max', '90000', '1');
insert into Employee (Id, Name, Salary, DepartmentId) values ('5', 'Janet', '69000', '1');
insert into Employee (Id, Name, Salary, DepartmentId) values ('6', 'Randy', '85000', '1');
insert into Employee (Id, Name, Salary, DepartmentId) values ('7', 'Will', '70000', '1');
Truncate table Department;
insert into Department (Id, Name) values ('1', 'IT');
insert into Department (Id, Name) values ('2', 'Sales');
select * from Employee;
select * from Department;

# Solution:
select Department, Employee, Salary 
from (
select d.Name as Department, e.Name as Employee, e.Salary, 
dense_rank() over (partition by e.DepartmentId order by e.Salary desc) as rnk 
from Employee e join Department d on e.DepartmentId = d.Id 
) z 
where rnk <= 3; 


######## 550. Game Play Analysis IV ######## {MEDIUM}

-- Write an SQL query that reports the fraction of players that logged in again on the day after the day they first logged in, 
-- rounded to 2 decimal places. In other words, 
-- you need to count the number of players that logged in for at least two consecutive days 
-- starting from their first login date, then divide that number by the total number of players.

# Schema: 
drop table if exists Activity; 
Create table If Not Exists Activity (player_id int, device_id int, event_date date, games_played int);
Truncate table Activity;
insert into Activity (player_id, device_id, event_date, games_played) values ('1', '2', '2016-03-01', '5');
insert into Activity (player_id, device_id, event_date, games_played) values ('1', '2', '2016-03-02', '6');
insert into Activity (player_id, device_id, event_date, games_played) values ('2', '3', '2017-06-25', '1');
insert into Activity (player_id, device_id, event_date, games_played) values ('3', '1', '2016-03-02', '0');
insert into Activity (player_id, device_id, event_date, games_played) values ('3', '4', '2018-07-03', '5');
select * from Activity;

select round(count(t2.player_id)/count(t1.player_id),2) as fraction 
from 
(select player_id, min(event_date) as first_login from Activity group by player_id) t1 left join Activity t2 
on t1.player_id = t2.player_id and t1.first_login = t2.event_date -1;


######## 597. Friend Requests I: Overall Acceptance ######## [EASY]

-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | sender_id      | int     |
-- | send_to_id     | int     |
-- | request_date   | date    |
-- +----------------+---------+
-- There is no primary key for this table, it may contain duplicates.
-- This table contains the ID of the user who sent the request, the ID of the user who received the request, 
-- and the date of the request.

-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | requester_id   | int     |
-- | accepter_id    | int     |
-- | accept_date    | date    |
-- +----------------+---------+
-- There is no primary key for this table, it may contain duplicates.
-- This table contains the ID of the user who sent the request, the ID of the user who received the request, 
-- and the date when the request was accepted.

-- Write an SQL query to find the overall acceptance rate of requests, 
-- which is the number of acceptance divided by the number of requests. 
-- Return the answer rounded to 2 decimals places.

# Schema:
drop table if exists FriendRequest;
drop table if exists RequestAccepted;
Create table If Not Exists FriendRequest (sender_id int, send_to_id int, request_date date);
Create table If Not Exists RequestAccepted (requester_id int, accepter_id int, accept_date date);
Truncate table FriendRequest;
insert into FriendRequest (sender_id, send_to_id, request_date) values ('1', '2', '2016/06/01');
insert into FriendRequest (sender_id, send_to_id, request_date) values ('1', '3', '2016/06/01');
insert into FriendRequest (sender_id, send_to_id, request_date) values ('1', '4', '2016/06/01');
insert into FriendRequest (sender_id, send_to_id, request_date) values ('2', '3', '2016/06/02');
insert into FriendRequest (sender_id, send_to_id, request_date) values ('3', '4', '2016/06/09');
Truncate table RequestAccepted;
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('1', '2', '2016/06/03');
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('1', '3', '2016/06/08');
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('2', '3', '2016/06/08');
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('3', '4', '2016/06/09');
insert into RequestAccepted (requester_id, accepter_id, accept_date) values ('3', '4', '2016/06/10');
select * from FriendRequest;
select * from RequestAccepted;

# Solution:

select 
round(
ifnull(
(select (
(select count(*) from (
select distinct requester_id, accepter_id from RequestAccepted) as a)
/
(select count(*) from (
select distinct sender_id, send_to_id from FriendRequest) as b)
)), 0), 2) as accept_rate;



######## 602. Friend Requests II: Who Has the Most Friends ######## {MEDIUM}

-- Write a query to find the the people who has most friends and the most friends number under the following rules:
	-- It is guaranteed there is only 1 people having the most friends.
	-- The friend request could only been accepted once, 
		-- which mean there is no multiple records with the same requester_id and accepter_id value.

-- +--------------+-------------+------------+
-- | requester_id | accepter_id | accept_date|
-- |--------------|-------------|------------|
-- | 1            | 2           | 2016_06-03 |
-- | 1            | 3           | 2016-06-08 |
-- | 2            | 3           | 2016-06-08 |
-- | 3            | 4           | 2016-06-09 |
-- +--------------+-------------+------------+
-- This table holds the data of friend acceptance, while requester_id and accepter_id both are the id of a person.

# Schema:
Create table If Not Exists request_accepted ( requester_id INT NOT NULL, accepter_id INT NULL, accept_date DATE NULL);
Truncate table request_accepted;
insert into request_accepted (requester_id, accepter_id, accept_date) values ('1', '2', '2016/06/03');
insert into request_accepted (requester_id, accepter_id, accept_date) values ('1', '3', '2016/06/08');
insert into request_accepted (requester_id, accepter_id, accept_date) values ('2', '3', '2016/06/08');
insert into request_accepted (requester_id, accepter_id, accept_date) values ('3', '4', '2016/06/09');
select * from request_accepted;

# Solution:
select id, sum(cnt) as num 
from 
(select requester_id as id, count(*) as cnt 
from request_accepted 
group by requester_id 
union all
select accepter_id as id, count(*) as cnt 
from request_accepted
group by accepter_id) as z 
group by id 
order by num desc 
limit 1;