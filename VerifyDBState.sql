--Ian Crofford

--1. displaying what users have access to the database
select USER_ID,
       USERNAME,
       CREATED,
       PASSWORD_CHANGE_DATE
from USER_USERS;

-- 2. Checking what tables are present in the database
select * from USER_TABLES;

-- 3. Examining the design of each table
select column_name,
       data_type,
       data_length,
       nullable
from user_tab_columns
where table_name in ('ORDERS',
                   'PRODUCTLIST',
                   'REVIEWS',
                   'STOREFRONT',
                   'USERBASE',
                   'USERLIBRARY');

-- 4. Displaying all data currently present in database
select * from ORDERS;
select * from PRODUCTLIST;
select * from REVIEWS;
select * from STOREFRONT;
select * from USERBASE;
select * from USERLIBRARY;

-- 5. checking what constraints are present in the database
select TABLE_NAME,
       CONSTRAINT_NAME,
       CONSTRAINT_TYPE,
       STATUS
from USER_CONSTRAINTS;

--6. Checking what views are present in the database
select VIEW_NAME,
       TEXT
from USER_VIEWS;

--7. Displaying all usernames in alphabetical order
select USERNAME
from USERBASE
order by USERNAME;

--8. Displaying all users with a yahoo email address
select FIRSTNAME,
       LASTNAME,
       USERNAME,
       PASSWORD,
       EMAIL
FROM USERBASE
where EMAIL like '%@yahoo%';

--9. Displaying all users who have less than 25 dollars in funds
select USERNAME,
       BIRTHDAY,
       WALLETFUNDS
FROM USERBASE
where WALLETFUNDS < 25;

--10. Displaying all users who have more than 100 hours played
select USERID,
       PRODUCTCODE
from USERLIBRARY
where HOURSPLAYED > 100;

--11. Displaying the product code of any game played less than 10 hours
select PRODUCTCODE
from USERLIBRARY
where HOURSPLAYED < 10;

--12. Displaying every unique publisher
select distinct PUBLISHER
from PRODUCTLIST;

--13.Display the PRODUCTNAME, RELEASEDATE, PUBLISHER, and GENRE of all products, sorted by GENRE.
select PRODUCTNAME,
       RELEASEDATE,
       PUBLISHER,
       GENRE
from PRODUCTLIST
order by GENRE;

--14. Display the PRODUCTCODE and PUBLISHER of any product in the ‘Strategy’ GENRE.
select PRODUCTCODE,
       PUBLISHER
from PRODUCTLIST
where GENRE = 'Strategy';

--15. Display the PRODUCTCODE, DESCRIPTION, and PRICE for any product that costs more than $25, sorted by descending PRICE.
select PRODUCTCODE,
       PRICE
from ORDERS
where PRICE > 25
order by PRICE desc;

--16.Display the INVENTORYID and PRICE of all products in the STOREFRONT table, sorted by ascending PRICE.
select INVENTORYID,
       PRICE
from STOREFRONT
order by PRICE asc;

--17.	Display the PRODUCTCODE and REVIEW of any product with a RATING of 1.
select PRODUCTCODE,
       REVIEW
from REVIEWS
where RATING = 1;

--18.	Display the PRODUCTCODE and REVIEW of any product with a RATING of 4 or higher.
select PRODUCTCODE,
       REVIEW
from REVIEWS
where RATING >= 4;

--19.Display every unique USERID from users who have placed an order.
select distinct USERID
from ORDERS;

--20.Display all order data, sorted by the earliest PURCHASEDATE.
select * from ORDERS
order by PURCHASEDATE asc;

commit;