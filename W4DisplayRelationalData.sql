--Ian Crofford
-- Question 1 Display every USERNAME and the lowest RATING they have left in a review.
select u.username,
       min(r.rating) as lowest_rating
from userbase u
join reviews r on u.userid = r.userid
group by u.username;

-- Question 2 Display every user’s EMAIL, QUESTION, and ANSWER.
select u.email,
       s.question,
       s.answer
from userbase u
join securityquestion s
on u.userid = s.userid;

-- Question 3 Display the FIRSTNAME, EMAIL, and WALLETFUNDS of every user that does not have a WISHLIST.
select u.firstname,
       u.email,
       u.walletfunds
from userbase u
left join wishlist w
on u.userid = w.userid
where w.userid is null;

-- Question 4 Display every USERNAME and number of products they have ordered.
select u.username,
       count(o.productcode) as product_count
from userbase u
join orders o 
on u.userid = o.userid
group by u.username;

-- Question 5 Display the age of any user who has ordered a product within the last 6 months.
select u.username, 
       floor(months_between(sysdate, u.birthday)/12) as age
from userbase u
join orders o
on u.userid = o.userid
where o.purchasedate >= add_months(sysdate, -6);

-- Question 6 Display the USERNAME and BIRTHDAY of the user who has the highest friend count.
select u.username,
       u.birthday,
       count(f.friendid) as friend_count
from userbase u
join friendslist f on u.userid = f.userid
group by u.username,
         u.birthday
order by friend_count desc;

--Question 7 Display the PRODUCTNAME, RELEASEDATE, PRICE, and DESCRIPTION for any product found in the WISHLIST table.
select p.productname,
       p.releasedate,
       p.price,
       p.description
from productlist p
join wishlist w
on p.productcode = w.productcode;

--Question 8 Display the PRODUCTNAME, highest RATING, and number of reviews for each product in the REVIEWS table. Order the results in descending order of the RATING.
select p.productname,
       max(r.rating) as highest_rating,
       count(r.review) as review_count
from productlist p
join reviews r
on p.productcode = r.productcode
group by p.productname
order by highest_rating desc;

-- Question 9 Create a view that displays the PRODUCTNAME, GENRE, and RATING for every product with a 5 or a 1 RATING. Order the results in ascending order of the RATING.
create view ratings1 as
select p.productname,
       p.genre,
       r.rating
from productlist p
join reviews r
on p.productcode = r.productcode
where r.rating in (1,5)
order by r.rating asc;

-- Question 10 Display the count of products ordered, grouped by GENRE. Order the results in alphabetical order of GENRE.
select p.genre,
       count(o.productcode) as products_ordered
from productlist p
join orders o
on p.productcode = o.productcode
group by p.genre
order by p.genre asc;

--Question 11 Create a view that displays each PUBLISHER, the average PRICE, and the sum of HOURSPLAYED for their products.
create view publisher_products as 
select p.publisher,
       avg(p.price) as avg_price,
       sum(u.hoursplayed) as total_hours_played
from productlist p
join userlibrary u
on p.productcode = u.productcode
group by p.publisher;

-- Question 12 Display the sum of money spent on products and their corresponding PUBLISHER, from the ORDERS table. Order the results in descending order of the sum of money spent.
select p.publisher,
       sum(o.price) as total_amount_purchased
from productlist p
join orders o
on p.productcode = o.productcode
group by p.publisher
order by total_amount_purchased desc;

-- Question 13 Display the TICKETID, USERNAME, EMAIL, and ISSUE only for tickets with a STATUS of ‘NEW’ or ‘IN PROGRESS’, sorted by the latest DATEUPDATED.
select s.ticketid,
       s.email,
       s.issue,
       s.status,
       u.username
from usersupport s
left join userbase u
on s.email = u.email
where s.status = 'NEW' 
      or s.status = 'IN PROGRESS'
order by s.dateupdated desc;

-- Question 14 Display the USERNAME and count of TICKETID that users have submitted for user support.
select u.username,
       count(s.ticketid) as count_of_tickets
from userbase u
left join usersupport s
on u.email = s.email
group by u.username;

-- Question 15 Display the USERID and EMAIL of any user who has submitted a support ticket that used their FIRSTNAME, LASTNAME, or combination of the two in their EMAIL address.
select  u.userid,
        u.email
from userbase u
join usersupport s
on u.email = s.email
where  s.email LIKE '%' || U.FIRSTNAME || '%'
   OR s.email LIKE '%'|| U.LASTNAME || '%'
   OR s.email LIKE '%'|| U.FIRSTNAME || U.LASTNAME || '%';


-- Question 16 Display the EMAIL address of any user who has a ‘NEW’ or ‘IN PROGRESS’ support ticket STATUS, where the EMAIL is not currently saved in the USERBASE table.
select s.email
from usersupport s
left join userbase u
on s.email = u.email
where s.status in ('NEW', 'IN PROGRESS')
and u.email is null;

--Question 17 Display the TICKETID, FIRSTNAME, LASTNAME, and USERNAME of any user whose USERNAME is mentioned in the ISSUE of a support ticket.
select s.ticketid,
       u.firstname,
       u.lastname,
       u.username
from usersupport s
left join userbase u 
on s.issue like '%' || u.username || '%';

--Question 18 Display the USERNAME and PASSWORD associated with the EMAIL address provided in the support tickets.
select u.username,
       u.password
from userbase u
left join usersupport s
on u.email = s.email;

--Question 19 Create a view that displays the USERNAME, DATEASSIGNED, and PENALTY for any user whose PENALTY is not null and the infraction was assigned within the last month.
create view penalty1 as 
select u.username,
       i.dateassigned,
       i.penalty
from userbase u
join infractions i
on u.userid = i.userid
where i.penalty is not null
and i.dateassigned >= add_months(sysdate, -1);    

--Question 20 Display the USERNAME and EMAIL of any user who is at least 18 years old and has not received an infraction within the last 4 months.
select u.username,
       u.email
from userbase u
left join infractions i
on u.userid = i.userid
and i.dateassigned >= add_months(sysdate, -4)
where months_between(sysdate, u.birthday) / 12 >= 18
and i.userid is null;

--Question 21 Display the USERNAME, DATEASSIGNED, and full guideline name (RULENUM and TITLE with a blank space inbetween) for any user who has violated the community rules.
select u.username,
       i.dateassigned,
       i.rulenum || ' ' || c.title as guideline
from infractions i
join userbase u
on i.userid = u.userid
join communityrules c 
on i.rulenum = c.rulenum;

-- Question 22 Display the USERID, USERNAME, EMAIL, and sum of all SEVERITYPOINTS each user has received.
select u.userid,
       u.username,
       u.email,
       sum(c.severitypoint) as total_severity_points
from userbase u
join infractions i
on u.userid = i.userid
join communityrules c
on i.rulenum = c.rulenum
group by u.userid, u.username, u.email;


--Question 23 Display the TITLE, DESCRIPTION, and PENALTY for all infractions assigned.
select c.title,
       c.description,
       i.penalty
from infractions i
join communityrules c
on c.rulenum = i.rulenum;

--Question 24 Display the USERNAME and count of infractions for users who have violated the community rules at least 15 times.
SELECT u.username,
       COUNT(i.infractionid) AS infraction_count
FROM userbase u
JOIN infractions i ON u.userid = i.userid
GROUP BY u.username
HAVING COUNT(i.infractionid) >= 15;