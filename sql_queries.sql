
-- 1. To find out duplicate rows from season_ticket.
SELECT TicketID, COUNT(*) 
FROM Season_Ticket
GROUP BY TicketID
HAVING COUNT(*) > 1;
    
-- 2. To find out duplicate rows from ticket.
select UserID, RouteID, Journey_Date, Ticket_Type, COUNT(*) AS cnt from Ticket
group by UserID, RouteID, Journey_Date, Ticket_Type having COUNT(*) > 1;

-- 3. Create a event that runs daily and updates all expired tickets.

SET GLOBAL event_scheduler = ON;
DELIMITER //

CREATE EVENT expire_normal_tickets
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    UPDATE Ticket
    SET Status = 'expired'
    WHERE Status = 'active'
    AND Ticket_Type IN ('normal','return','platform')
    AND Journey_Date < CURDATE();
END//

DELIMITER ;

select * from information_schema.Events where event_schema="Ticket_Booking";
select Ticket_id, Ticket_Type, Journey_Date, Status
from Ticket where Status = 'expired';
drop event expire_normal_tickets;

-- 4.To find the active status dates from season tickets which have to expired.
SELECT T.Ticket_id, T.Status, ST.Start_Date, ST.End_Date
FROM Ticket as T
JOIN Season_Ticket as ST 
ON T.Ticket_id = ST.TicketID
WHERE ST.End_Date < CURDATE()
AND T.Status = 'active';

-- 5. find the name users who never scan QR_code 
SELECT DISTINCT u.User_name
FROM User u
JOIN Ticket t ON u.UserID = t.UserID
LEFT JOIN QR_Booking q ON t.Ticket_id = q.TicketID
WHERE q.TicketID IS NULL;


-- 6.Retrieve user give highest feedback.
select u.user_name, f.comment, f.rating from user as u 
inner join feedback as f on u.userID=f.userID where 
f.rating=(select max(rating) from feedback);

-- 7. Find how many ticket booked by each user.
SELECT u.User_name, COUNT(t.Ticket_id) AS ticket_booked
FROM User as u
LEFT JOIN Ticket as t
ON u.UserID = t.UserID
GROUP BY u.UserID, u.User_name;
  
-- 8.Find users whose wallet balance is less than 100.
select u.User_name, w.Balance as wallet from User as u 
inner join Wallet as w 
on u.UserID= w.UserID
where w.Balance<100;

-- 9.Find total number of tickets booked for each route.
select r.RouteID,count(t.Ticket_id) as total_ticket from Route as r
left join Ticket as t
on r.RouteID = t.RouteID
group by r.RouteID;

-- 10.Find the total revenue generated from successful payments.
select SUM(Amount) AS total_revenue
from Payment where Status = 'Success';

-- 11.Find the names of users who booked season tickets.
select distinct u.User_name from User as u 
inner join Ticket as t on u.UserID= t.UserID
inner join Season_Ticket as s on t.TicketID=s.TicketID;

-- 12.Find tickets whose payment status is 'Failed'.
select t.TicketID, p.Status  from Ticket as t
inner join Payment as p 
on t.TicketID = p.TicketID
where p.Status = "Failed";

-- 13.Find the top 3 users who booked the most tickets.
select u.User_name, count(t.TicketID) as total from User as u 
inner join Ticket as t 
on u.UserID = t.UserID group by u.UserID,u.User_name
order by total desc limit 3;

-- 14.Find trains and their category names.
select t.Train_Name, c.Train_Category from Train as t
left join Train_Category as c
on t.CategoryID = c.CategoryID;

-- 15.Find users who booked more than 5 tickets.
select u.User_name, COUNT(t.TicketID) AS total_tickets
from User u
inner join Ticket t 
on u.UserID = t.UserID
GROUP BY u.UserID, u.User_name
having COUNT(t.TicketID) > 5;

-- 16.Find the most popular route (route with highest tickets)
select r.RouteID, COUNT(t.TicketID) AS total_tickets
from Route r
inner join Ticket t on r.RouteID = t.RouteID
GROUP BY r.RouteID
ORDER BY total_tickets DESC limit 1;

-- 17.Find the latest ticket booked by each user.
select u.User_name, MAX(t.Journey_Date) AS last_ticket_date
from User u
inner join Ticket t 
on u.UserID = t.UserID
GROUP BY u.UserID, u.User_name;

-- 18.Find routes that have no tickets booked.
select r.RouteID from Route r
left join Ticket t 
on r.RouteID = t.RouteID
where t.TicketID is null;

-- 19.Find users who never booked any ticket.
select u.User_name from User u
left join Ticket t 
on u.UserID = t.UserID
where t.TicketID is null;

-- 20.Find the average wallet balance of users
select avg(balance) as Average_Wallet_Balance from wallet;

