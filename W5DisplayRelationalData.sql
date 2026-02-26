-- Ian Crofford
--Question 1 Display the USERID of any users who have not made an order.
SELECT USERID
FROM USERBASE
MINUS
SELECT USERID
FROM ORDERS;

--Question 2 Display the PRODUCTCODE of any products that have no reviews.
select productcode
from productlist
minus
select productcode
from reviews;

--Question 3 Display all data in the USERBASE table. Show another column that states “Adult” for any user that is at least 18 years old, and “Minor'' for all other users.
SELECT U.*, 
       CASE 
           WHEN FLOOR(MONTHS_BETWEEN(SYSDATE, BIRTHDAY)/12) >= 18 THEN 'Adult'
           ELSE 'Minor'
       END AS AGE_STATUS
FROM USERBASE U;

--Question 4 Display all data in the PRODUCTLIST table. Show another column that states “On Sale” for any product that is priced at $20 or less, and “Base Price” for all other products.
SELECT P.*, 
       CASE 
           WHEN PRICE <= 20 THEN 'On Sale'
           ELSE 'Base Price'
       END AS PRICE_STATUS
FROM PRODUCTLIST P;

--Question 5 Display the USERID of any user who has played the product with a PRODUCTCODE of GAME6 and has a user profile image.
select userid
from userlibrary
where productcode = 'GAME6'

intersect

select userid
from userprofile
where imagefile is not null;

-- Question 6 Display any PRODUCTCODE from the intersect of the WISHLIST and REVIEWS table, where the product is in POSITION 1 or 2, and has a review RATING of 3 or higher.
select productcode
from wishlist
where position in (1,2)

intersect

select productcode
from reviews 
where rating >= 3;

-- Question 7 Display both user’s USERNAME and BIRTHDAY for any users who share the same BIRTHDAY.
select a.username,
       a.birthday
from userbase a
join userbase b
    on a.birthday = b.birthday
    and a.userid <> b.userid
order by a.birthday;

--Question 8 Display the Cartesian Product of the USERLIBRARY table cross joined with the WISHLIST table.
select *
from userlibrary
cross join wishlist;

--Question 9 Perform a union all on the USERBASE and PRODUCTLIST tables to generate data on all users and products.
select to_char (userid) as ID, username as Name, 'User' as type
from userbase

union all

select productcode as ID,
Productname as Name,
 'Product' as Type
from productlist;

-- Question 10 Perform a union all on the CHATLOG and USERPROFILE tables to generate data on user activity.
SELECT SENDERID AS ID, DATESENT AS ACTIVITY_DATE, 'Sent a Chat' AS ACTIVITY_TYPE
FROM CHATLOG
UNION ALL
SELECT USERID, NULL, 'Profile Exists: ' || DESCRIPTION FROM USERPROFILE;

--Question 11 Display the USERNAME of all users who have not received an INFRACTION.
select username 
from userbase
where userid in (select userid
             from userbase
minus
            select userid 
            from infractions);

--Question 12 Display the TITLE and DESCRIPTION of any COMMUNITYRULES that have not been broken.
select title,
       description
from communityrules
minus
select cr.title, cr.description
from communityrules cr
join infractions i
on cr.rulenum = i.rulenum;

--Question 13 Display the USERNAME and EMAIL of all users who have received a penalty for their INFRACTION.
select u.username,
       u.email
from userbase u
join infractions i
on u.userid = i.userid
where i.penalty is not null;

--Question 14 Display the dates where an INFRACTION was assigned and a USERSUPPORT ticket was submitted on the same day.
select trunc(dateassigned)
from infractions
intersect
select trunc(datesubmitted)
from usersupport;

--Question 15 Display every COMMUNITYRULES TITLE and PENALTY.
select c.title,
       i.penalty
from communityrules c
left join infractions i
on c.rulenum = i.rulenum;

--Question 16 Display all data in the COMMUNITYRULES table. Show another column that states “Bannable'' for any rule with a 10 or higher SEVERITYPOINT, and “Appealable” for all other rules.
select c.*,
          case
            when severitypoint >= 10 then 'Bannable'
            else 'Appealable'
          end as Status
from communityrules c;

--Question 17 Display all data in the USERSUPPORT table. Show another column that states “High Priority” for any ticket that is not closed and has not been updated in the past week.
select u.*,
        case
            when status <> 'CLOSED' and dateupdated < (sysdate-7)
            then 'High Priority'
            else 'Normal'
        end as priority
from usersupport u;

--Question 18 Display the Cartesian Product of the USERSUPPORT table cross joined with the INFRACTIONS table.
select * 
from usersupport
cross join infractions;


--Question 19 Display both TICKETIDs and DATEUPDATED for any support tickets that are ‘CLOSED’ and the last DATEUPDATED was on the same day.
select a.ticketid,
       b.ticketid,
       a.dateupdated
from usersupport a
join usersupport b on trunc(a.dateupdated) = trunc(b.dateupdated)
    and a.ticketid < b.ticketid
where a.status = 'CLOSED' and b.status = 'CLOSED';

--Question 20 Perform a union all on the USERBASE and INFRACTIONS tables to generate data on user activity.
select userid,
       username
from userbase
union all
select userid,
       to_char(infractionid) 
from infractions;