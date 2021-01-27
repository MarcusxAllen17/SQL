SET SERVEROUTPUT ON;

--1--
DECLARE
    count_videos    NUMBER;
BEGIN 
    SELECT COUNT(v.video_id) 
    INTO count_videos
    FROM VIDEO v
    join video_topic_linking vt
    on v.video_id = vt.video_id
    join topic t
    on t.topic_id = vt.topic_id
    WHERE topic_name = 'SQL'
    ;
    IF count_videos > 2  THEN 
    DBMS_OUTPUT.PUT_LINE('The number of SQL videos is greater than 2');
    ELSE
    DBMS_OUTPUT.PUT_LINE('The number of SQL videos is less than or equal to 2');
    END IF;
END;
/
-- 2--!!!
SET DEFINE ON; 
DECLARE
    count_videos    NUMBER;
    user_id         NUMBER := &user_defined_id;
    first_name_var      browser_user.first_name%type;
    last_name_var       browser_user.last_name%type;
BEGIN 
    SELECT COUNT(v.video_id), first_name, last_name
    INTO count_videos, first_name_var, last_name_var
    FROM VIDEO v
    join contentcreator cc
    on v.contentcreator_id = cc.contentcreator_id
    join browser_user b
    on b.user_id = cc.user_id
    WHERE b.user_id = &user_defined_id
    GROUP BY b.first_name, b.last_name
    ;
    IF count_videos > 2  THEN 
    DBMS_OUTPUT.PUT_LINE('The number of videos by'||first_name_var||last_name_var||'is greater than 2');
    ELSE
    DBMS_OUTPUT.PUT_LINE('The number of videos by'||first_name_var||last_name_var||'is less than or equal to 2');
    END IF;
END;
/
--3
select *from comments;
BEGIN
   INSERT INTO comments VALUES (100001,10002,comment_id_seq.nextval, sysdate, 'I like this');
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('row is not inserted');
END;
/
--4
CREATE OR REPLACE PROCEDURE insert_comment
(
  video_id_param             number,
  user_id_param              number,
  comment_body_param         varchar2
  
)
AS
BEGIN
  insert into comments (video_id, user_id, time_date, comment_body) 
  values (video_id_param, user_id_param, sysdate, comment_body_param);
  
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN 
    ROLLBACK;
END;
/
--test1
CALL insert_comment (100001, 10003,'I think Tricia is the cats pajamas!');
--test2

--5--
SELECT * FROM COMMENTS;
DECLARE 
    TYPE comment_table    IS TABLE OF VARCHAR2(100);
    comment_var           comment_table;
BEGIN
    SELECT comment_body
    BULK COLLECT INTO comment_var
    FROM comments
    WHERE video_id = 100000
    ORDER BY time_date;
    
    FOR i IN 1..comment_var.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE('Person ' || i|| ' wrote: '|| comment_var(i));
    END LOOP;
END;
/
--6--
CREATE OR REPLACE FUNCTION count_comments
(
video_id_param NUMBER
)
RETURN NUMBER 
AS 
    comment_id_var NUMBER;
BEGIN 
    SELECT COUNT(distinct comment_id)
    INTO comment_id_var
    FROM comments
    WHERE video_id = video_id_param;
    
    RETURN comment_id_var;
END;
/

select video_id, title, count_comments(video_id)
from video
order by count_comments(video_id) desc;






