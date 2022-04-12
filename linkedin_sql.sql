
##########################################################
##				1.) Video Posts 						##
##########################################################

-- video_posts
-- post_date|   memberid|    video_length
-- 2018-12-18  		123    		95
-- 2018-12-18 		576    		65
-- 2018-12-19  		576    		22
-- 2018-12-19  		123     	20 
-- 2018-12-20 		260     	100
-- 2018-12-21  		450     	150
-- 2018-12-22  		123     	200

-- members
-- memberid| country| join_date  
-- 123     usa         2018-11-03
-- 576     uk           2016-05-15
-- 807     aus         2012-04-12
-- 260     uk           2017-12-01
-- 450     india       2019-01-12

# Schema: 
Create table If Not Exists video_posts (post_date date, memberid int, video_length int);
Truncate table video_posts;
insert into video_posts (post_date, memberid, video_length) values ('2018-12-18', 123, 95);
insert into video_posts (post_date, memberid, video_length) values ('2018-12-18', 576, 65);
insert into video_posts (post_date, memberid, video_length) values ('2018-12-19', 576, 22);
insert into video_posts (post_date, memberid, video_length) values ('2018-12-19', 123, 20);
insert into video_posts (post_date, memberid, video_length) values ('2018-12-20', 260, 100);
insert into video_posts (post_date, memberid, video_length) values ('2018-12-21', 450, 150);
insert into video_posts (post_date, memberid, video_length) values ('2018-12-22', 123, 200);
select * from video_posts;

Create table If Not Exists members (memberid int, country varchar(6), join_date date);
Truncate table members;
insert into members (memberid, country, join_date) values (123, 'usa', '2018-11-03');
insert into members (memberid, country, join_date) values (576, 'uk', '2016-05-15'); 
insert into members (memberid, country, join_date) values (807, 'aus', '2012-04-12'); 
insert into members (memberid, country, join_date) values (260, 'uk', '2017-12-01'); 
insert into members (memberid, country, join_date) values (450, 'india', '2019-01-12'); 
select * from members; 


# a.) 
# How many members post their first video on the same day they've joined the platform?

# steps: 
-- first make a list of the members 
-- conditions: 
	-- first video post date = member join date 
-- count the number of members 

# Things we need to consider (any edge cases?): 
-- edge case(s): members may post their first video not on their join date 
-- there’s no match and we may need to consider the null condition 

# Code: 
WITH first_video AS (
	SELECT memberid,  
		min(post_date) as first_post_date 
	FROM video_posts 
    group by memberid 
	)
SELECT IFNULL(count(distinct m.memberid), 0) as num_of_members 
FROM members m 
JOIN first_video fv 
ON m.memberid = fv.memberid 
AND m.join_date = fv.first_post_date 
;


# b.) 
# We hypothesize that our video posting features might not be catching on as well internationally as they do in the US. 
# Do US members upload more videos than non-US members?

# steps:
-- count number of videos posted by US members 
-- count number of videos posted by non-US members 
-- return counts in one table 

# Code: 
WITH mem_videos AS (
	SELECT 
    vp.memberid, 
    mem.country, 
	count(*) as video_count 
    FROM video_posts vp
    LEFT JOIN members mem
	ON vp.memberid = mem.memberid 
    GROUP BY 1,2 
    )
SELECT CASE WHEN country = 'usa' then 'US' ELSE 'nonUS' END AS country_flag, 
	sum(video_count) as total_videos 
FROM mem_videos 
GROUP BY 1  
;






##########################################################
##					 2.) Job Posts 						##
##########################################################

# Schema: 
Create table If Not Exists postings (job_id int, member_id int, posting_date date);
Truncate table postings;
insert into postings (job_id, member_id, posting_date) values (1001, 1, '2017-01-14'); 
insert into postings (job_id, member_id, posting_date) values (1002, 1, '2017-08-14');
insert into postings (job_id, member_id, posting_date) values (1003, 2, '2017-05-31');
insert into postings (job_id, member_id, posting_date) values (1004, 3, '2017-08-23');
insert into postings (job_id, member_id, posting_date) values (1005, 3, '2017-04-28');
insert into postings (job_id, member_id, posting_date) values (1006, 3, '2017-05-23');
insert into postings (job_id, member_id, posting_date) values (1001, 3, '2017-12-08');
SELECT * FROM postings; 


# Definitions: 
-- New job posting: Job post by a member who's never posted a job on LinkedIn platform before
-- Repeat job posting: Job post by member who has posted a job on LinkedIn platform before
-- Reactivated posting: If a member hasn't posted in over 180 days, the post after 180 days is called reactivated post 

# a.) 
# Count the number of new job postings. 

# Edge case(s):
-- a job_id could be posted by multiple members (i.e. job_id 1001 was first posted by member_id 3, then by member_id 1)
-- is the date column sorted? 
-- multiple dates affecting the 180 days timeframe 

# Steps: 
-- count number of job_ids with the condition that the post date of the member who posted that job_id is min(posting_date) 

# Code: 
# Solution 1: 
WITH new_post_members AS (
	SELECT member_id, 
			min(posting_date) as first_post_date  
	FROM postings 
	GROUP BY 1 
    )
SELECT count(distinct job_id) as new_job_posts 
FROM postings po 
JOIN new_post_members npm 
ON po.member_id = npm.member_id 
AND po.posting_date = npm.first_post_date 
; 

# Solution 2: 
SELECT COUNT(DISTINCT P.JOB_ID) 
FROM POSTINGS P 
JOIN
(SELECT MEMBER_ID, MIN(POSTING_DATE) AS FIRST_POSTING_DATE 
FROM POSTINGS
GROUP BY MEMBER_ID) AS T
ON P.MEMBER_ID = T.MEMBER_ID 
AND T.FIRST_POSTING_DATE = P.POSTING_DATE;

# b.) 
# Count the number of repeat job postings. 

# Steps:
-- count number of job_ids with the condition that the post date of the member who posted that job_id is > min(posting_date)  

# Code: 
# Solution 1: 
WITH new_post_members AS (
	SELECT member_id, 
			min(posting_date) AS first_post_date  
	FROM postings 
	GROUP BY 1 
    )
SELECT count(distinct job_id) as repeated_job_posts 
FROM postings po 
JOIN new_post_members npm 
ON po.member_id = npm.member_id 
AND po.posting_date > npm.first_post_date 
;

# Solution 2: 
SELECT count(distinct(member_id)) as new_job_count, 
count(job_id)-count(distinct(member_id)) as repeated_job_count
FROM postings;


# c.) 
# Count the number of reactivated postings. 

# Steps:
-- lag() to get posting date matched up to posting date immediately prior to it, partition by member_id 
-- count job_id where datediff > 180 

# Code:
# Solution 1: 
WITH CTE AS(
	SELECT MEMBER_ID, 
			JOB_ID, 
			POSTING_DATE, 
            LAG(POSTING_DATE,1) OVER (PARTITION BY MEMBER_ID) AS NEXT_POSTING_DATE FROM POSTINGS
            )
SELECT COUNT(DISTINCT JOB_ID)
FROM CTE
WHERE NEXT_POSTING_DATE-POSTING_DATE >180;


# similar solution, but with ordered table by member_id, by date 
create table postings2 as 
select member_id, job_id, posting_date 
from postings 
order by 1,3
;
-- SELECT MEMBER_ID, 
-- 		JOB_ID, 
-- 		POSTING_DATE, 
-- 		LAG(POSTING_DATE,1) OVER (PARTITION BY MEMBER_ID) AS NEXT_POSTING_DATE 
-- FROM postings2 ;

SELECT count(distinct job_id) as reactivated_job_posts 
FROM 
(
SELECT MEMBER_ID, 
		JOB_ID, 
		POSTING_DATE, 
		LAG(POSTING_DATE,1) OVER (PARTITION BY MEMBER_ID) AS NEXT_POSTING_DATE 
FROM postings2 ) Z
where datediff(posting_date, next_posting_date) > 180
;





##########################################################
##				 3.) Current Status 					##
##########################################################


-- TABLE 1:  "status" - contains all LinkedIn members' latest push notification setting status as of the last day of Jan (01/31/2020)
-- -------------------------------
-- member_id      status 
--       1         on
--       2         off
--       3         on
--       4         off

-- TABLE 2: "actions" - all actions that members made in Feb (after the time period of 'status' table).
-- (For the simplicity, Let's assume a member can have at most one action per day)
-- -------------------------------
-- member_id    date_sk   action
--       1        2/2       turn_off
--       1        2/5       turn_on
--       2        2/3       turn_on
--       4        2/10      turn_on
--       4        2/13      turn_off
--       5        2/13      turn_off

-- =======================================================================
-- EXPECTED RESULT - the current status (as of 02/29/2020).
-- ---------------------------------
-- member_id   current_status
--       1            on
--       2            on
--       3            on
--       4            off


# Schema: 
drop table if exists statuses; 
Create table If Not Exists statuses (member_id int, curr_status varchar(4));
Truncate table statuses;
insert into statuses (member_id, curr_status) values (1, 'on');
insert into statuses (member_id, curr_status) values (2, 'off'); 
insert into statuses (member_id, curr_status) values (3, 'on'); 
insert into statuses (member_id, curr_status) values (4, 'off'); 
SELECT * from statuses; 

drop table if exists actions; 
Create table If Not Exists actions (member_id int, date_sk date, action varchar(10));
Truncate table actions;
insert into actions (member_id, date_sk, action) values (1, '2020-02-02', 'turn_off');
insert into actions (member_id, date_sk, action) values (1, '2020-02-05', 'turn_on'); 
insert into actions (member_id, date_sk, action) values (2, '2020-02-03', 'turn_on'); 
insert into actions (member_id, date_sk, action) values (4, '2020-02-10', 'turn_on'); 
insert into actions (member_id, date_sk, action) values (4, '2020-02-13', 'turn_off'); 
insert into actions (member_id, date_sk, action) values (5, '2020-02-13', 'turn_off'); 
SELECT * from actions; 


# a.) return the current status as of 2/29/2020 

# Considerations:
-- only IDs from the statuses table 
-- there may be multiple actions per ID 
-- no multiple actions on the same day 
-- if there exists an ID in statuses table but not in actions table, then leave its current status as is 

# Code: 
WITH latest_action AS (
	SELECT a.member_id, a.latest_date, b.action 
	FROM (
		SELECT member_id, 
				max(date_sk) as latest_date 
		FROM actions 
		GROUP BY 1 
		) a 
		LEFT JOIN actions b 
		ON a.member_id = b.member_id 
		AND a.latest_date = b.date_sk 
	) 
SELECT s.member_id, 
	CASE WHEN la.action = 'turn_off' then 'off'  
		WHEN la.action = 'turn_on' then 'on' 
        ELSE s.curr_status 
        END AS current_status 
FROM statuses s 
LEFT JOIN latest_action la 
ON s.member_id = la.member_id 
;







##########################################################
##				 4.) Article Views  					##
##########################################################


-- Articles: 
-- view_date   viewer_id   article_id  author_id
-- 2019-08-01      123         456         789
-- 2019-08-02      432         543         654
-- 2019-08-01      789         456         789
-- 2019-08-03      567         780         432


# Schema: 
drop table if exists articles;
create table if not exists articles (view_date date, viewer_id int, article_id int, author_id int); 
insert into articles (view_date, viewer_id, article_id, author_id) values ('2019-08-01', 123, 456, 789); 
insert into articles (view_date, viewer_id, article_id, author_id) values ('2019-08-02', 432, 543, 654); 
insert into articles (view_date, viewer_id, article_id, author_id) values ('2019-08-01', 789, 456, 789); 
insert into articles (view_date, viewer_id, article_id, author_id) values ('2019-08-03', 567, 780, 432); 
select * from articles; 

# a.) 
# How many members viewed more than one article on 2019-08-01?

# Steps:
-- only looking at date = 2019-08-01 
-- count number of article_id by viewer_id 

# Clarify:
-- can the viewer view the same article multiple times on the same day - how is that counted? 

# Code: 
WITH viewers AS (
	SELECT viewer_id, count(distinct article_id) as dist_articles 
	FROM articles 
	WHERE view_date = '2019-08-01' 
    GROUP BY 1 
    HAVING count(distinct article_id) > 1 
    ) 
SELECT count(viewer_id) as viewer_count 
FROM viewers 
;



# b.) 
# How many article authors have never viewed their own article?

# Steps: 
-- get a list of all the authors who is also the viewer (a) 
-- match up from the main list of all the authors, take out the authors who are in (a) 
-- count 


# Code:

SELECT count(distinct author_id) as authors 
FROM articles 
WHERE author_id NOT IN (
	SELECT author_id 
	FROM articles 
	WHERE author_id = viewer_id
    )
; 










