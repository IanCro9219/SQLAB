--Ian Crofford
--question 2-1 eliminate the STOREFRONT table without losing data

--Alter the PRODUCTLIST table to include a PRICE and DESCRIPTION column
alter table productlist 
add (price      number(8, 2),
    description varchar2 (250));

--move data from storefront to productlist
update productlist
set price = (
select  distinct price
from storefront
where storefront.productcode = productlist.productcode);

update productlist
set description = (
select distinct description
from storefront 
where storefront.productcode = productlist.productcode);

--drop the storefront table
drop table storefront;

-- question 2-2 Your second task is to design a new table to accommodate this feature. Users who receive a message should be able to see the sender’s USERID, the date the message was sent, and the contents of the message. 

-- create chatlog table
CREATE TABLE CHATLOG (
    CHATID NUMBER(3),
    RECEIVERID NUMBER(3),
    SENDERID NUMBER(3),
    DATESENT DATE,
    CONTENT VARCHAR2(250),
    CONSTRAINT PK_CHATLOG PRIMARY KEY (CHATID),
    CONSTRAINT FK_CHAT_RECEIVER FOREIGN KEY (RECEIVERID) REFERENCES USERBASE(USERID),
    CONSTRAINT FK_CHAT_SENDER FOREIGN KEY (SENDERID) REFERENCES USERBASE(USERID)
);

--Insert sample data
INSERT INTO CHATLOG VALUES (1, 101, 102, TO_DATE('2026-02-01', 'YYYY-MM-DD'), 'Hey, are you online?');
INSERT INTO CHATLOG VALUES (2, 102, 101, TO_DATE('2026-02-01', 'YYYY-MM-DD'), 'Yeah, just joining the lobby.');
INSERT INTO CHATLOG VALUES (3, 103, 104, TO_DATE('2026-02-02', 'YYYY-MM-DD'), 'Good game!');
INSERT INTO CHATLOG VALUES (4, 104, 103, TO_DATE('2026-02-02', 'YYYY-MM-DD'), 'Thanks, you too.');
INSERT INTO CHATLOG VALUES (5, 105, 101, TO_DATE('2026-02-03', 'YYYY-MM-DD'), 'Want to trade items?');
INSERT INTO CHATLOG VALUES (6, 101, 105, TO_DATE('2026-02-03', 'YYYY-MM-DD'), 'What do you have?');
INSERT INTO CHATLOG VALUES (7, 106, 107, TO_DATE('2026-02-04', 'YYYY-MM-DD'), 'Dont forget the raid tonight.');
INSERT INTO CHATLOG VALUES (8, 107, 106, TO_DATE('2026-02-04', 'YYYY-MM-DD'), 'I will be there.');
INSERT INTO CHATLOG VALUES (9, 108, 109, TO_DATE('2026-02-05', 'YYYY-MM-DD'), 'Check out the new patch notes.');
INSERT INTO CHATLOG VALUES (10, 109, 108, TO_DATE('2026-02-05', 'YYYY-MM-DD'), 'Reading them now.');

-- question 2-3 help improve user interaction by accommodating a friends list feature

--create friendslist table
create table friendslist (
    userid      number(3),
    friendid    number(3),
                constraint pk_friendslist primary key (userid, friendid),
                constraint fk_friends_user foreign key (userid) references userbase(userid),
                constraint fk_friends_friend foreign key (friendid) references userbase(userid)
);

--insert data
INSERT INTO FRIENDSLIST VALUES (101, 102);
INSERT INTO FRIENDSLIST VALUES (101, 103);
INSERT INTO FRIENDSLIST VALUES (102, 101);
INSERT INTO FRIENDSLIST VALUES (103, 101);
INSERT INTO FRIENDSLIST VALUES (104, 105);
INSERT INTO FRIENDSLIST VALUES (105, 104);
INSERT INTO FRIENDSLIST VALUES (106, 101);
INSERT INTO FRIENDSLIST VALUES (107, 108);
INSERT INTO FRIENDSLIST VALUES (108, 107);
INSERT INTO FRIENDSLIST VALUES (109, 110);

select * from friendslist

--question 2-4 providing a wish list feature. Users should be able to change the position of each item in the list. 


CREATE TABLE WISHLIST (
    USERID NUMBER(3),
    PRODUCTCODE VARCHAR2(5),
    POSITION NUMBER(3),
    CONSTRAINT PK_WISHLIST PRIMARY KEY (USERID, PRODUCTCODE),
    CONSTRAINT FK_WISH_USER FOREIGN KEY (USERID) REFERENCES USERBASE(USERID),
    CONSTRAINT FK_WISH_PROD FOREIGN KEY (PRODUCTCODE) REFERENCES PRODUCTLIST(PRODUCTCODE)
);

INSERT INTO WISHLIST VALUES (101, 'GAME1', 1);
INSERT INTO WISHLIST VALUES (101, 'GAME2', 2);
INSERT INTO WISHLIST VALUES (102, 'GAME3', 1);
INSERT INTO WISHLIST VALUES (103, 'GAME4', 1);
INSERT INTO WISHLIST VALUES (104, 'GAME5', 1);
INSERT INTO WISHLIST VALUES (104, 'GAME6', 2);
INSERT INTO WISHLIST VALUES (105, 'GAME7', 1);
INSERT INTO WISHLIST VALUES (106, 'GAME8', 1);
INSERT INTO WISHLIST VALUES (107, 'GAME9', 1);
INSERT INTO WISHLIST VALUES (108, 'GME12', 1);

-- question 2-5 add a user profile page and VaporGames has accepted this request, including it in your task list. Users would like to save the path to an image file to use as a profile picture and be able to describe themselves in an “About Me” section. 


--create userprofile table
create table userprofile (
    userid      number(3),
    imagefile   varchar2(250),
    description varchar2(250),
                constraint pk_userprofile primary key (userid),
                constraint fk_profile_user foreign key (userid) references userbase(userid)
);


--insert data
INSERT INTO USERPROFILE VALUES (101, '/imgs/p1.jpg', 'Lover of RPGs and fantasy games.');
INSERT INTO USERPROFILE VALUES (102, '/imgs/p2.jpg', 'Competitive FPS player.');
INSERT INTO USERPROFILE VALUES (103, '/imgs/p3.jpg', 'Speedrunner and retro fan.');
INSERT INTO USERPROFILE VALUES (104, '/imgs/p4.jpg', 'I play mostly cozy farm sims.');
INSERT INTO USERPROFILE VALUES (105, '/imgs/p5.jpg', 'Streaming every weekend!');
INSERT INTO USERPROFILE VALUES (106, '/imgs/p6.jpg', 'Trophy hunter.');
INSERT INTO USERPROFILE VALUES (107, '/imgs/p7.jpg', 'Casual gamer.');
INSERT INTO USERPROFILE VALUES (108, '/imgs/p8.jpg', 'Into strategy and grand scale games.');
INSERT INTO USERPROFILE VALUES (109, '/imgs/p9.jpg', 'Modder and developer.');
INSERT INTO USERPROFILE VALUES (110, '/imgs/p10.jpg', 'Here for the community.');

select * from userprofile;

-- question 2-6 help with account retrieval by storing responses to security questions.


--create securityquestion table
create table securityquestion(
    questionid      number,
    userid          number(3),
    question        varchar2(250),
    answer          varchar2(250),
                    constraint pk_sec_ques primary key (questionid),
                    constraint fk_sec_user foreign key (userid) references userbase(userid)
);

--insert data
INSERT INTO SECURITYQUESTION VALUES (1, 101, 'What was your first pets name?', 'Rex');
INSERT INTO SECURITYQUESTION VALUES (2, 102, 'What city were you born in?', 'Boston');
INSERT INTO SECURITYQUESTION VALUES (3, 103, 'What was your first car?', 'Civic');
INSERT INTO SECURITYQUESTION VALUES (4, 104, 'What city were you born in?', 'Chicago');
INSERT INTO SECURITYQUESTION VALUES (5, 105, 'What was your first pets name?', 'Goldie');
INSERT INTO SECURITYQUESTION VALUES (6, 106, 'Mothers maiden name?', 'Smith');
INSERT INTO SECURITYQUESTION VALUES (7, 107, 'Name of your high school?', 'North High');
INSERT INTO SECURITYQUESTION VALUES (8, 108, 'What was your first pets name?', 'Fluffy');
INSERT INTO SECURITYQUESTION VALUES (9, 109, 'Favorite food?', 'Pizza');
INSERT INTO SECURITYQUESTION VALUES (10, 110, 'First concert?', 'Queen');

select * from securityquestion;

-- question 2-7 implement guidelines to promote a healthy and respectful environment on the platform with these new user interaction updates. Each guideline should have a number to reference by, a title that denotes the type of rule, a description explaining the conditions of the rule, and a numerical point system indicating its importance (a higher point number means a more important rule). 


--create communityrules table
create table communityrules (
    rulenum         number(3),
    title           varchar2(250),
    description     varchar2(250),
    severitypoint   number(4),
                    constraint pk_communityrules primary key (rulenum)
);

--insert data
INSERT INTO COMMUNITYRULES VALUES (1, 'Respect', 'Treat all users with kindness.', 10);
INSERT INTO COMMUNITYRULES VALUES (2, 'No Spam', 'Do not flood chat channels.', 5);
INSERT INTO COMMUNITYRULES VALUES (3, 'No Cheating', 'Using 3rd party software is banned.', 50);
INSERT INTO COMMUNITYRULES VALUES (4, 'Age Limit', 'Users must be 13 or older.', 100);
INSERT INTO COMMUNITYRULES VALUES (5, 'Safe Content', 'No inappropriate imagery allowed.', 30);
INSERT INTO COMMUNITYRULES VALUES (6, 'Privacy', 'Do not share others personal info.', 40);
INSERT INTO COMMUNITYRULES VALUES (7, 'No Phishing', 'Scamming links are strictly banned.', 80);
INSERT INTO COMMUNITYRULES VALUES (8, 'Fair Trade', 'Do not deceive in item trades.', 20);
INSERT INTO COMMUNITYRULES VALUES (9, 'Language', 'No offensive slurs.', 25);
INSERT INTO COMMUNITYRULES VALUES (10, 'Impersonation', 'Do not pretend to be staff.', 60);

select * from communityrules;

-- Question 2-8 track when users have violated the rules and if they received a punishment for the violation. 

--create infractions table
CREATE TABLE INFRACTIONS (
    INFRACTIONID NUMBER,
    USERID NUMBER(3),
    RULENUM NUMBER(3),
    DATEASSIGNED DATE,
    PENALTY VARCHAR2(250),
    CONSTRAINT PK_INFRACTIONS PRIMARY KEY (INFRACTIONID),
    CONSTRAINT FK_INF_USER FOREIGN KEY (USERID) REFERENCES USERBASE(USERID),
    CONSTRAINT FK_INF_RULE FOREIGN KEY (RULENUM) REFERENCES COMMUNITYRULES(RULENUM)
);

--insert data
INSERT INTO INFRACTIONS VALUES (1, 102, 2, SYSDATE, '24 hour mute');
INSERT INTO INFRACTIONS VALUES (2, 105, 1, SYSDATE, 'Warning');
INSERT INTO INFRACTIONS VALUES (3, 109, 3, SYSDATE, 'Permanent Account Ban');
INSERT INTO INFRACTIONS VALUES (4, 101, 9, SYSDATE, '3 day suspension');
INSERT INTO INFRACTIONS VALUES (5, 103, 8, SYSDATE, 'Trade restriction');
INSERT INTO INFRACTIONS VALUES (6, 104, 2, SYSDATE, 'Warning');
INSERT INTO INFRACTIONS VALUES (7, 107, 5, SYSDATE, 'Image upload disabled');
INSERT INTO INFRACTIONS VALUES (8, 108, 10, SYSDATE, '7 day suspension');
INSERT INTO INFRACTIONS VALUES (9, 106, 1, SYSDATE, 'Warning');
INSERT INTO INFRACTIONS VALUES (10, 110, 3, SYSDATE, 'Permanent Account Ban');

-- question 2-9 user support ticketing system. Users should be able to provide a contact email address and a quick description of what they need support on. The ticketing system should also keep track of the date the ticket was submitted, when it was last updated, and the current status of the ticket (‘NEW’, ’IN PROGRESS’, ’CLOSED’). 

--create user support table
create table usersupport (
    ticketid        number,
    email           varchar2(250),
    issue           varchar2(250),
    datesubmitted   date,
    dateupdated     date,
    status          varchar2(250),
                    constraint pk_usersupport primary key (ticketid)
);

--insert data
INSERT INTO USERSUPPORT VALUES (1, 'user1@email.com', 'Cannot login', TO_DATE('2026-02-01', 'YYYY-MM-DD'), TO_DATE('2026-02-02', 'YYYY-MM-DD'), 'IN PROGRESS');
INSERT INTO USERSUPPORT VALUES (2, 'user2@email.com', 'Missing item', TO_DATE('2026-02-01', 'YYYY-MM-DD'), TO_DATE('2026-02-01', 'YYYY-MM-DD'), 'NEW');
INSERT INTO USERSUPPORT VALUES (3, 'user3@email.com', 'Bug in level 3', TO_DATE('2026-02-02', 'YYYY-MM-DD'), TO_DATE('2026-02-04', 'YYYY-MM-DD'), 'CLOSED');
INSERT INTO USERSUPPORT VALUES (4, 'user4@email.com', 'Payment failed', TO_DATE('2026-02-03', 'YYYY-MM-DD'), TO_DATE('2026-02-03', 'YYYY-MM-DD'), 'NEW');
INSERT INTO USERSUPPORT VALUES (5, 'user5@email.com', 'Refund request', TO_DATE('2026-02-03', 'YYYY-MM-DD'), TO_DATE('2026-02-04', 'YYYY-MM-DD'), 'IN PROGRESS');
INSERT INTO USERSUPPORT VALUES (6, 'user6@email.com', 'Account stolen', TO_DATE('2026-02-04', 'YYYY-MM-DD'), TO_DATE('2026-02-04', 'YYYY-MM-DD'), 'NEW');
INSERT INTO USERSUPPORT VALUES (7, 'user7@email.com', 'Game crash', TO_DATE('2026-02-04', 'YYYY-MM-DD'), TO_DATE('2026-02-05', 'YYYY-MM-DD'), 'CLOSED');
INSERT INTO USERSUPPORT VALUES (8, 'user8@email.com', 'Lag issues', TO_DATE('2026-02-05', 'YYYY-MM-DD'), TO_DATE('2026-02-05', 'YYYY-MM-DD'), 'NEW');
INSERT INTO USERSUPPORT VALUES (9, 'user9@email.com', 'Report a player', TO_DATE('2026-02-05', 'YYYY-MM-DD'), TO_DATE('2026-02-05', 'YYYY-MM-DD'), 'IN PROGRESS');
INSERT INTO USERSUPPORT VALUES (10, 'user10@email.com', 'Feature request', TO_DATE('2026-02-05', 'YYYY-MM-DD'), TO_DATE('2026-02-05', 'YYYY-MM-DD'), 'NEW');

select * from usersupport;

-- question 2-10 generate views to display some useful information. 

--Create a view that displays every unique QUESTION from the SECURITYQUESTION table.
CREATE VIEW VIEW_UNIQUE_QUESTIONS AS
SELECT DISTINCT QUESTION
FROM SECURITYQUESTION;

--Create a view that displays the TICKETID, EMAIL, ISSUE, and DATEUPDATED only for tickets with a STATUS of ‘NEW’ or ‘IN PROGRESS’, sorted by the earliest DATEUPDATED.
CREATE VIEW VIEW_ACTIVE_TICKETS AS
SELECT TICKETID, EMAIL, ISSUE, DATEUPDATED
FROM USERSUPPORT
WHERE STATUS IN ('NEW', 'IN PROGRESS');

select * from view_active_tickets
ORDER BY DATEUPDATED ASC;
