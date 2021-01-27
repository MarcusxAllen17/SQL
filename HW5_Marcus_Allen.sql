-- Question 1 Marcus Allen jma5328--
SELECT SYSDATE, TRIM(TO_CHAR(SYSDATE, 'YEAR'))AS "YEAR",TRIM(TO_CHAR(SYSDATE, 'DAY-MONTH'))AS "DAY_MONTH",
TO_CHAR(SYSDATE, 'HH') AS "HOUR", ROUND(TO_DATE('31-DEC-2020')-SYSDATE) As "Days_till_end_yr",
TO_CHAR(SYSDATE, 'mon-dy-yyyy') AS "Abbreviated_mon_dy"
FROM dual;

-- Question 2 Marcus Allen jma5328-- 
SELECT video_id,
'posted_on'||' '|| Trim(TO_CHAR(upload_date,'Day')) ||TO_CHAR(upload_date, ', Mon DD, YYYY')AS "video_date",
NVL2(TO_CHAR(revenue, '$999999.99'),TO_CHAR(revenue, '$999999.99'),'None generated') AS "$"
from video
ORDER BY upload_date
;
-- Question 3 Marcus Allen jma5328 --
SELECT SUBSTR(LOWER(first_name), 1,1)||'. '||UPPER(last_name) AS "USER'S_NAMES", 
NVL(title, 'None created') as "video_title"
FROM browser_user b
join contentcreator c
on b.user_id = c.user_id
join video v
on c.contentcreator_id = v.contentcreator_id
ORDER BY title
;
select * from video;
-- Quesiton 4 Marcus Allen jma5328--
SELECT LOWER(video_id) as "Vid_id", Trunc(likes/100) AS "video point", 
((Trunc(likes/100))/500)*100||'%' AS "video_award_percent"
From video
ORDER BY  "video_award_percent"
;
-- Question 5 Marcus Allen jma5328--
SELECT * FROM creditcard;
SELECT contentcreator_id, LENGTH(street_billing) as "billing_address_length", 
ROUND(EXP_DATE-SYSDATE,0) AS "days_until_card_expiration"
FROM creditcard
WHERE ROUND(EXP_DATE-SYSDATE,0) < 120 OR ROUND(EXP_DATE-SYSDATE,0) <= 0
;
-- Question 6 Marcus Allen jma5328--
SELECT last_name, SUBSTR(street_billing,1,(INSTR(street_billing, ' ') -1)) AS "Street_Num",
SUBSTR(street_billing,(INSTR(street_billing, ' ') +1)) AS "Street_Name",
NVL2(middle_name, 'Does list', 'None listed') AS "Middle_name",
city_billing, state_billing, cc.zip_code_bill
FROM browser_user b
join contentcreator c
on b.user_id = c.user_id
JOIN creditcard cc
on cc.contentcreator_id = c.contentcreator_id
;
--Question 7 Marcus Allen jma5328--
SELECT cc_username, SUBSTR(mobile,1,2)||'-***-***-'||SUBSTR(mobile,11,2)
AS redacted_mobile
From contentcreator
;
-- Question 8 Marcus Allen jma5328--
SELECT video_id, revenue, views,
CASE 
    WHEN views > 5000000 THEN '1-Top-Tier' 
    WHEN views >=1000000 AND views <=5000000 THEN '2-Mid-Tier' 
    WHEN views <1000000 THEN '3-Lower-Tier' 
END AS video_tier
FROM video
ORDER BY views DESC
;
-- Question 9 Marcus Allen jma5328 --
SELECT first_name, last_name,
COUNT(DISTINCT video_id) AS "count_of_videos",
SUM(revenue) AS total_revenue,
RANK() OVER (ORDER BY sum(revenue) DESC) AS "Influencer_Rank"
FROM browser_user b
join contentcreator c
on b.user_id = c.user_id
join video v
on c.contentcreator_id = v.contentcreator_id
GROUP BY first_name, last_name
;
-- Question 10 Marcus Allen jma5328 !!! --
SELECT * FROM
(SELECT row_number() OVER(ORDER BY sum(revenue) DESC) AS Row_Number,
first_name, last_name, COUNT(DISTINCT video_id) AS "count_of_videos",
SUM(revenue) AS total_revenue,
RANK() OVER (ORDER BY sum(revenue) DESC) AS "Influencer_Rank"
FROM browser_user b
join contentcreator c
on b.user_id = c.user_id
join video v
on c.contentcreator_id = v.contentcreator_id
GROUP BY first_name, last_name) SUB
WHERE row_number = 4
;