-- Drops for the tables. Marcus Allen jma5328 --
   
DROP TABLE User_topic_subscr;

DROP TABLE Video_topic_linking;

DROP TABLE Comments;

DROP TABLE Topic;

DROP TABLE Video;

DROP TABLE credit_cards;

DROP TABLE ContentCreator;

DROP TABLE Browser_User;

  -- Drops for the different sequences in the schemas. Marcus Allen jma5328 --

DROP SEQUENCE User_id_seq
;

DROP SEQUENCE Card_id_seq
;

DROP SEQUENCE Topic_id_seq
;

DROP SEQUENCE Video_id_seq
;

DROP SEQUENCE comment_id_seq
;

DROP SEQUENCE contentcreator_id_seq
;

  -- Sequences for the schemas. Marcus Allen jma5328 --

CREATE SEQUENCE User_id_seq
START WITH 1000000 
INCREMENT BY 1
;

CREATE SEQUENCE Card_id_seq
START WITH 1000000
INCREMENT BY 1
;

CREATE SEQUENCE Topic_id_seq
START WITH 1000
INCREMENT BY 1
;

CREATE SEQUENCE Video_id_seq
START WITH 1000
INCREMENT BY 1
;

CREATE SEQUENCE comment_id_seq
START WITH 1000
INCREMENT BY 1
;

CREATE SEQUENCE contentcreator_id_seq
START WITH 1000
INCREMENT BY 1
;

 -- Browser_User table. Marcus Allen jma5328 --

CREATE TABLE Browser_User
(
user_id         NUMBER  DEFAULT  User_id_seq.nextval CONSTRAINT  Browser_User_pk  PRIMARY KEY,
first_name      VARCHAR(20)  NOT NULL,
middle_name     VARCHAR(20),
last_name       VARCHAR(20)  NOT NULL,
birthdate       DATE         NOT NULL,
email           VARCHAR(40)  NOT NULL         UNIQUE,
CC_flag         CHAR(1)      DEFAULT 'N'      NOT NULL,
 CONSTRAINT User_age_check  CHECK ((TO_DATE('08-OCT-2020')-birthdate)/365 >= 13),
 CONSTRAINT email_length_ck CHECK (length(email) >=7)
);

-- ContentCreator Table. Marcus Allen jma5328. --

CREATE TABLE ContentCreator
(
ContentCreator_id     NUMBER  DEFAULT contentcreator_id_seq.nextval  CONSTRAINT ContentCreator_pk PRIMARY KEY,
user_id               NUMBER  REFERENCES Browser_User (user_id),
username              VARCHAR(50)   NOT NULL  UNIQUE,
street_address        VARCHAR(50)   NOT NULL,
city                  VARCHAR(20)   NOT NULL,
State                 CHAR(2)       NOT NULL,
zip_code              CHAR(5)       NOT NULL,
state_residence       CHAR(2)       NOT NULL,
country_res           VARCHAR(50)   NOT NULL,
mobile                CHAR(12)      NOT NULL,
tier_level            VARCHAR(20)   NOT NULL
);

   --  credit_cards table. Marcus Allen jma5328 --

CREATE TABLE credit_cards
(
Card_id               NUMBER  DEFAULT Card_id_seq.nextval  CONSTRAINT credit_cards_pk PRIMARY KEY,
ContentCreator_id     NUMBER         NOT NULL    REFERENCES ContentCreator (ContentCreator_id),
card_type             VARCHAR(20)    NOT NULL,
card_num              NUMBER         NOT NULL,
exp_date              DATE           NOT NULL,
CC_ID                 NUMBER         NOT NULL,
street_billing        VARCHAR(50)    NOT NULL,
city_billing          VARCHAR(20)    NOT NULL,
state_billing         VARCHAR(20)    NOT NULL,
zip_code_billing      NUMBER         NOT NULL
);

  --  Video table. Marcus Allen jma5328 --

CREATE TABLE Video
(
video_id              NUMBER             DEFAULT Video_id_seq.nextval CONSTRAINT video_pk PRIMARY KEY,
contentCreator_id     NUMBER             NOT NULL    REFERENCES   ContentCreator  (contentcreator_id),
title                 varchar(50)        NOT NULL,
subtitle              varchar(60)        NOT NULL,
upload_date           DATE               NOT NULL,
video_length          NUMBER             NOT NULL,
video_size            VARCHAR(15)        NOT NULL,
views                 NUMBER             DEFAULT 0     NOT NULL,
likes                 NUMBER             DEFAULT 0     NOT NULL,
revenue               NUMBER             DEFAULT 0     NOT NULL 
);

  -- Comments table. Marcus Allen jma5328 --

CREATE TABLE Comments 
(
comment_id          NUMBER          DEFAULT   Comment_id_seq.nextval     CONSTRAINT  comment_pk    PRIMARY KEY,
video_id            NUMBER          NOT NULL  REFERENCES  Video         (video_id),
user_id             NUMBER          NOT NULL  REFERENCES  Browser_User  (user_id),
time_date           DATE            NOT NULL,
comment_body        VARCHAR(100)    NOT NULL
);

 -- Topic table. jma5328 Marcus Allen --

CREATE TABLE Topic
(
topic_id           number  DEFAULT Topic_id_seq.nextval CONSTRAINT  topic_id_pk  PRIMARY KEY, 
topic_name         VARCHAR(20)      NOT NULL,
topic_desc         VARCHAR(100)     NOT NULL
);

--  User,topic, &  linking table. Marcus Allen jma5328 --

CREATE TABLE User_topic_subscr
(
user_id            NUMBER                   REFERENCES  Browser_User (user_id),
topic_id           NUMBER                   REFERENCES  Topic (topic_id),
CONSTRAINT         User_topic_subscr_pk     PRIMARY KEY (user_id, topic_id)
);

  -- Video,topic, linking table. Marcus Allen jma5328 --

CREATE TABLE Video_topic_linking
(
video_id           NUMBER            REFERENCES  Video   (video_id),
topic_id           NUMBER            REFERENCES  Topic   (topic_id),
CONSTRAINT         Video_topic_linking       PRIMARY KEY (video_id, topic_id)
);

-- Indexes for the schemas. Marcus Allen jma5328 --

CREATE INDEX Browser_User_ix
ON Browser_User (last_name, email)
;

CREATE INDEX ContentCreator_ix
ON ContentCreator (user_id, username, mobile)
;

CREATE INDEX credit_cards_ix
ON credit_cards (contentcreator_id, card_num, card_type)
;

CREATE INDEX Video_ix
ON Video (contentCreator_id, title, views)
;

CREATE INDEX Comments_ix
ON Comments (video_id, user_id, time_date , comment_body)
;

CREATE INDEX Topic_ix
ON Topic (topic_name, topic_desc)
;

-- Data inserts for Browser_User table. Justin Allen jma5328 --

Insert Into Browser_User 
Values 
    ( DEFAULT, 'Kendrick', DEFAULT , 'Lamar', '17-JUN-87', 'K.DOT@gmail.com', 'Y')
    ;
Insert Into Browser_User 
Values 
    (DEFAULT, 'Alicia', 'Augello' , 'Keys', '25-JAN-81', 'GirlOnFire@gmail.com', 'Y')
    ;
    
Insert Into Browser_User 
Values 
    ( DEFAULT, 'Kurt', 'Donald' , 'Cobain', '20-FEB-67', 'Nevermind@gmail.com', 'Y')
    ;
    
Insert Into Browser_User 
Values 
    (DEFAULT, 'Bob', DEFAULT , 'Marley', '06-FEB-1945', 'BuffaloSoldier@gmail.com', 'Y')
    ;
    
Insert Into Browser_User 
Values 
    (DEFAULT, 'Charlamagne', 'Tha' , 'God', '29-JUN-78', 'Instigator@gmail.com', 'N')
    ;
    
Insert Into Browser_User 
Values 
    (DEFAULT, 'D.J', DEFAULT , 'Akademics', '17-MAY-91', 'GossipMan@gmail.com', 'N')
    ;
    
COMMIT;   
   
   -- Data insets for content creator table. Justin Allen jma5328 --

INSERT INTO contentcreator
Values
    (DEFAULT, '1000000', 'K.DOT23', '2727 Compton Rd', 'Compton' ,'CA', '90059', 'CA', 'USA','213-457-9787',' Platinum')
    ;
    
INSERT INTO contentcreator
Values
    (DEFAULT, '1000001', 'AKISONFIRE', '3939 Hells Kitchen St', 'New York City' ,'NY', '10019', 'NY', 'USA','212-787-2141',' Platinum')
    ;

INSERT INTO contentcreator
Values
    (DEFAULT, '1000002', 'Pixie.Meat17', '1994 Lithium Dr', 'Seattle' ,'WA', '98101', 'WA', 'USA','206-444-6959',' Platinum')
    ;
    
INSERT INTO contentcreator
Values
    (DEFAULT, '1000003', 'Onelover', '1981 Easy Skanking Dr ', 'Nine Mile' ,'SP', '98101', 'SP', 'Jamaica','304-333-1313',' Platinum')
    ;

    COMMIT;

--Data inserts for credit_cards table. Marcus Allen jma5328.--

INSERT INTO credit_cards
Values
    (DEFAULT, '1000', 'Visa', 4343567867769009, '08-AUG-25', 443, '2727 Compton Rd', 'Compton', 'CA', '90059')
    ;
    
INSERT INTO credit_cards
Values
    (DEFAULT, '1000', 'Visa', 2332678721124569, '07-JUN-24', 737, '2727 Compton Rd', 'Compton', 'CA', '90059')
    ;
    
INSERT INTO credit_cards
Values
    (DEFAULT, '1001', 'Visa', 2442568498784778, '01-JAN-26', 323, '3939 Hells Kitchen St', 'New York City', 'NY', '10019')
    ;
    
INSERT INTO credit_cards
Values
    (DEFAULT, '1002', 'Mastercard', 4357879057554324, '02-MAR-24', 987, '1994 Lithium Dr', 'Seattle', 'WA', '98101')
    ;

COMMIT;

-- Data Inserts for Video table. Justin Allen jma5328.--

INSERT INTO Video
Values
    (DEFAULT, '1000', 'Alright', 'Music video for Alright', TO_DATE('15-JUN-2015 12:17:45 PM', 'DD-MON-YYYY HH:MI:SS PM'), 3.40 , ' 600 MB', 24357654,789765, 14789456)
    ;
    
INSERT INTO Video
Values
    (DEFAULT, '1001', 'Underdog', 'Inspiration for the underdogs', TO_DATE('07-OCT-2020 3:56:23 PM', 'DD-MON-YYYY HH:MI:SS PM'), 3.28 , ' 584 MB', DEFAULT ,DEFAULT, DEFAULT)
    ;
    
INSERT INTO Video
Values
    (DEFAULT, '1002', 'Smells like Teen Spirit', 'Pure Angst', TO_DATE('17-JUN-2012 04:19:34 PM', 'DD-MON-YYYY HH:MI:SS PM'), 5.03 , ' 676 MB', 45678989,5987876, 10456784)
    ;
    
INSERT INTO Video
Values
    (DEFAULT, '1003', 'Is This Love', 'when you think you are in love', TO_DATE('01-AUG-2015 08:17:17 PM', 'DD-MON-YYYY HH:MI:SS PM'), 3.53 , ' 640 MB', 45897876,10456653, 20678984)
    ;
    
COMMIT;

-- Data inserts for comments table. Justin Allen jma5328--

INSERT INTO comments
Values
    (DEFAULT, '1000', '1000004', TO_DATE('17-JUN-2015 09:21:17 PM', 'DD-MON-YYYY HH:MI:SS PM'),'You are the greatest rapper alive!') 
    ;
    
INSERT INTO comments
Values
    (DEFAULT, '1002', '1000004', TO_DATE('19-JUN-2012 08:31:18 PM', 'DD-MON-YYYY HH:MI:SS PM'),'Yo rock music is kinda live') 
    ;
    
INSERT INTO comments
Values
    (DEFAULT, '1000', '1000005', TO_DATE('16-JUN-2015 10:41:58 PM', 'DD-MON-YYYY HH:MI:SS PM'),'I can rap better lololol') 
    ; 
    
INSERT INTO comments
Values
    (DEFAULT, '1003', '1000005', TO_DATE('02-AUG-2015 11:51:38 PM', 'DD-MON-YYYY HH:MI:SS PM'),'Reggae is trash. This music is way too slow lololol') 
    ;