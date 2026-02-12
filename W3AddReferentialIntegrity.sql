--Ian Cofford
-- question 1 Enforce referential integrity by adding foreign key constraints to: ORDERS, REVIEWS, and USERLIBRARY.

ALTER TABLE ORDERS
ADD CONSTRAINT fk_orders_user
FOREIGN KEY (USERID)
REFERENCES USERBASE(USERID);

ALTER TABLE ORDERS
ADD CONSTRAINT fk_orders_product
FOREIGN KEY (PRODUCTCODE)
REFERENCES PRODUCTLIST(PRODUCTCODE);

ALTER TABLE REVIEWS
ADD CONSTRAINT fk_reviews_user
FOREIGN KEY (USERID)
REFERENCES USERBASE(USERID);

ALTER TABLE REVIEWS
ADD CONSTRAINT fk_reviews_product
FOREIGN KEY (PRODUCTCODE)
REFERENCES PRODUCTLIST(PRODUCTCODE);

ALTER TABLE USERLIBRARY
ADD CONSTRAINT fk_library_user
FOREIGN KEY (USERID)
REFERENCES USERBASE(USERID);

ALTER TABLE USERLIBRARY
ADD CONSTRAINT fk_library_product
FOREIGN KEY (PRODUCTCODE)
REFERENCES PRODUCTLIST(PRODUCTCODE);

-- question 2 display the full name and USERNAME of every user who is at least 18 years old. A user’s full name should include their FIRSTNAME and LASTNAME separated by a single space 
SELECT FIRSTNAME || ' ' || LASTNAME AS FULLNAME,
       USERNAME
FROM USERBASE
WHERE BIRTHDAY <= ADD_MONTHS(SYSDATE, -12 * 18 );

-- question 3 Your task is to find the maximum length of a USERNAME and the average length of a USERNAME in the USERBASE table.
SELECT 
    MAX(LENGTH(USERNAME)) AS MAX_USERNAME_LENGTH,
    AVG(LENGTH(USERNAME)) AS AVG_USERNAME_LENGTH
FROM USERBASE;

-- question 4 Your task is to display every QUESTION that starts with ‘What is’ or ‘What was’ in the SECURITYQUESTION table.
SELECT QUESTIONID,
       QUESTION
FROM SECURITYQUESTION
WHERE QUESTION LIKE 'What is%'
or    QUESTION LIKE 'What was%';

-- question 5 Your task is to display the PRODUCTCODE, lowest RATING, and number of reviews for each product in the REVIEWS table. Order the results in descending order of the REVIEW count.
SELECT PRODUCTCODE,
       MIN(RATING) AS LOWEST_RATING,
       COUNT(*) AS REVIEW_COUNT
FROM REVIEWS
GROUP BY PRODUCTCODE
ORDER BY REVIEW_COUNT DESC;

-- question 6 Your task is to display any PRODUCTCODE that is ranked at POSITION 1, as well as the number of users who have the product ranked at that position.
SELECT PRODUCTCODE,
       COUNT(USERID) AS USER_COUNT
FROM WISHLIST
WHERE POSITION = 1
GROUP BY PRODUCTCODE;

-- question 7 Your task is to display the USERID and the total amount each user has spent in ORDERS
SELECT USERID,
       SUM(PRICE) AS TOTAL_SPENT
FROM ORDERS
GROUP BY USERID;

-- question 8 Determine the most profitable days of the site by showing the gross profits of all orders categorized by their PURCHASEDATE, sorted in descending order of profit.
SELECT PURCHASEDATE,
       SUM(PRICE) AS DAILY_PROFIT
FROM ORDERS
GROUP BY PURCHASEDATE
ORDER BY DAILY_PROFIT DESC;   

-- question 9 Your task is to display the PRODUCTCODE and sum of HOURSPLAYED from the USERLIBRARY table. Limit the results to the top 5 games with the most play time and order them in descending order by HOURSPLAYED.
SELECT *
FROM (
    SELECT PRODUCTCODE,
           SUM(HOURSPLAYED) AS SUM_OF_HOURS_PLAYED
FROM USERLIBRARY
GROUP BY PRODUCTCODE
ORDER BY SUM_OF_HOURS_PLAYED DESC)
WHERE ROWNUM <= 5;

-- question 10 Create a view showing a list of each USERID and the count of infractions they have received, sorted with the highest infraction count first.
CREATE OR REPLACE VIEW VIEW_USER_INFRACTIONS AS
SELECT USERID,
       COUNT(*) AS INFRACTION_COUNT
FROM INFRACTIONS
GROUP BY USERID
ORDER BY INFRACTION_COUNT DESC;

-- question 11 Create a view showing a list of each USERID, RULENUM, and number of times the user broke that RULENUM, sorted by USERID.
CREATE OR REPLACE VIEW BROKEN_RULE_VIEW AS
SELECT USERID,
       RULENUM,
       COUNT(*) AS VIOLATION_COUNT
FROM INFRACTIONS
GROUP BY USERID, RULENUM
ORDER BY USERID;

-- question 12 Help the Customer Support team by displaying every RULENUM, PENALTY that has been assigned for breaking said rule, and the number of times that PENALTY has been assigned to that RULENUM.
SELECT RULENUM,
       PENALTY,
       COUNT(*) AS PENALTY_COUNT
FROM INFRACTIONS
WHERE PENALTY IS NOT NULL
GROUP BY RULENUM, PENALTY;

-- question 13 Your task is to display the average, maximum, and minimum time between the DATEUPDATED and DATESUBMITTED for all tickets with a STATUS of ‘CLOSED’.
SELECT AVG(DATEUPDATED - DATESUBMITTED) AS AVG_DAYS,
       MAX(DATEUPDATED - DATESUBMITTED) AS MAX_DAYS,
       MIN(DATEUPDATED - DATESUBMITTED) AS MIN_DAYS
FROM USERSUPPORT
WHERE STATUS = 'CLOSED';

-- question 14 display the EMAIL, ISSUE, and the count of times that ISSUE has been submitted, for all tickets with a STATUS of ‘NEW’, grouped by the DATESUBMITTED and ordered by the count.
SELECT EMAIL,
       ISSUE,
       COUNT(*) AS ISSUE_COUNT
FROM USERSUPPORT
WHERE STATUS = 'NEW'
GROUP BY DATESUBMITTED, EMAIL, ISSUE
ORDER BY ISSUE_COUNT;

-- question 15 Verify if any current users do not comply with these protocols by displaying any user who has their FIRSTNAME or LASTNAME in their PASSWORD.
SELECT USERID, USERNAME
FROM USERBASE
WHERE LOWER(PASSWORD) LIKE '%' || LOWER(FIRSTNAME) || '%'
OR    LOWER(PASSWORD) LIKE '%' || LOWER(LASTNAME) || '%';

-- question 16 Display every PUBLISHER and average PRICE of their products, sorted in alphabetical order of PUBLISHER.
SELECT PUBLISHER,
       AVG(PRICE) AS AVG_PRICE
FROM PRODUCTLIST
GROUP BY PUBLISHER
ORDER BY PUBLISHER;

-- question 17 Create a view that displays the PRODUCTNAME and PRICE for all products with a RELEASEDATE over 5 years ago. Apply a 25% discount to the PRICE.
CREATE OR REPLACE VIEW VW_DISCOUNTED_PRODUCTS AS 
SELECT PRODUCTNAME,
       PRICE * 0.75 AS DISCOUNTED_PRICE
FROM PRODUCTLIST
WHERE RELEASEDATE <= ADD_MONTHS(SYSDATE, -60);

-- question 18 Calculate the maximum and minimum PRICE of all products based on GENRE.
SELECT GENRE,
       MAX(PRICE) AS MAX_PRICE,
       MIN(PRICE) AS MIN_PRICE
FROM PRODUCTLIST
GROUP BY GENRE;

-- question 19 
CREATE OR REPLACE VIEW VW_RECENT_CHAT AS
SELECT *
FROM CHATLOG
WHERE DATESENT BETWEEN SYSDATE -7 AND SYSDATE;

SELECT * FROM VW_RECENT_CHAT;
-- question 20 create a view that displays the USERID, DATEASSIGNED, and PENALTY for any user whose PENALTY is not null and the infraction was assigned within the last month.
CREATE OR REPLACE VIEW VW_RECENT_PENALTIES AS
SELECT USERID,
       DATEASSIGNED,
       PENALTY
FROM INFRACTIONS
WHERE PENALTY IS NOT NULL
AND DATEASSIGNED >= ADD_MONTHS(SYSDATE, -1);
