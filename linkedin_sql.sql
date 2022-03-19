#### Video Posts ####


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






























