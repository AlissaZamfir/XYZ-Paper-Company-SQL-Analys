--1 . what  are the top   5   accounts that  placed the highest total amount of orders in usd? 

 select top 5 accounts.name, sum(orders.total_amt_usd) as Total_amount
 from accounts
 join orders
 on accounts.id = orders.account_id 
 group by accounts.name
 ORDER BY  Total_amount desc


 -- 2.	What are the top 5 accounts that ordered the most quantity of standard type of paper


 select  top 5 accounts.name,  max(orders.standard_qty) as Highest_order
 from accounts
 join orders
 on accounts.id =  orders.account_id
 group by accounts.name
 order by Highest_order desc


 --3. Show regions by how much sales each region made



 select  region.name, sum(total_amt_usd) as total_earnings
 from region
 join sales_reps
 on region.id = sales_reps.region_id
join accounts
on sales_reps.id = accounts.sales_rep_id
join orders
on accounts.id = orders.account_id
 group  by  region.name


 --4.	Show the sum of amount ordered by Year

 
SELECT YEAR(occurred_at) as order_year,SUM(total_amt_usd) as Amount_ordered
FROM orders
GROUP BY YEAR(occurred_at)



--5. Show the sales by the 3 types of Paper. which made the most sales?
select sum (standard_amt_usd),  sum(gloss_amt_usd), sum(poster_amt_usd)
from orders

---------------------------------------------------------------------------------------------------------------------------------------------------
/*PART 2 */ 
--1.Who was the primary contact associated with the earliest web event?

select top 1   web_events.occurred_at, max(accounts.primary_poc) as Primary_Contact
from web_events
join accounts
on web_events.account_id = accounts.id
group by web_events.occurred_at 


--2. What was the smallest order placed by each account in terms of the total usd. Provide only two columns - the account name and the total usd. Order from the smallest dollar amount to the largest

select distinct(min(orders.total_amt_usd)) as Smallest_order,  accounts.name
from orders 
join accounts
on orders.account_id = accounts.id 
group by accounts.name
order by accounts.name


/*Determine the number of times a particular channel was used in the web_events table for each sales rep. Your final 
table should have three columns - the name of the sales rep, the channel and the number of occurences.*/

 select  distinct web_events.channel, sales_reps.name, count(*) as no_of_occ
from web_events
join  accounts
on web_events.account_id = accounts.id
join sales_reps
on accounts.sales_rep_id = sales_reps.id
group by sales_reps.name, web_events.channel

/*Determine the number of times a particular channel was used in the web_events table for each region.
Your final table should have three columns - the region name, the channel and the number of occurences. 
Order your table with the highest number of occurences first.*/ 


select   distinct web_events.channel, region.name, count(*) as occurrances
from web_events
join accounts
on web_events.account_id = accounts.id 
join sales_reps
on   accounts.sales_rep_id = sales_reps.id
join region
on sales_reps.region_id = region.id
group by region.name , web_events.channel



--Has any sales_rep worked on more than one account?
select  count(distinct accounts.id) as num_acc_worked , sales_reps.name
from sales_reps
join accounts
on sales_reps.id = accounts.sales_rep_id
group by sales_rep_id ,sales_reps.name
having count( distinct accounts.id) > 1 
order by sales_reps.name




--6. How many of the sales_reps have more than four accounts that they manage?
select  count(distinct accounts.id) as num_acc_worked , sales_reps.name
from sales_reps
join accounts
on sales_reps.id = accounts.sales_rep_id
group by sales_rep_id ,sales_reps.name
having count( distinct accounts.id) > 4



--7	. How many accounts have more than 20 orders?
select accounts.id, count(orders.total) as total_orders, accounts.name
 from accounts 
 join orders
 on accounts.id = orders.account_id 
 group by accounts.id ,accounts.name
 having count(orders.total) > 20



-- 8. Which accounts spent more than 50,000 usd total across all orders?
 select orders.account_id, sum(orders.total_amt_usd ) as Total_orders, accounts.name
 from orders
 join accounts
 on orders.account_id = accounts.id 
  group by  orders.account_id, accounts.name
  having sum(orders.total_amt_usd) > 50000



--9. Which account spent the most amount
  
 select  top 1 orders.account_id, max(orders.total_amt_usd ) as most_amount, accounts.name
 from orders
 join accounts
 on orders.account_id = accounts.id 
  group by  orders.account_id, accounts.name


  --10. Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. USE the YEAR function


  select year(occurred_at) as sales_year, SUM(total_amt_usd) as Amount_ordered
FROM orders
  group by   YEAR(occurred_at)

  --11. Which year did Parch and Posey have the greatest sales in terms of total number of orders? 
  
  select  top 1 year(occurred_at) as sales_year, SUM(total) as Gratest_sales
FROM orders
  group by   YEAR(occurred_at)

  
  --12. Write a query to display for each order, the account ID, total amount of the order, and the level of the order -
--'Large' or 'Small' - depending on if the order is $3000 or more, or less than $3000


--select  orders.occurred_at , orders.account_id, orders.total

select account_id, total_amt_usd as Total_amount,
		case when total_amt_usd  >=  '3000' then 'large'
			else 'small'
				end as level_orders
 from orders 


 /*13. Write a query to display the number of orders in each of three categories, based on the total number of items in each order
The three categories are: 'At Least 2000', 'Between 1000 and 2000', and 'Less than 1000' */ 


select id, standard_qty, gloss_qty, poster_qty, 

		case when total >= 2000  then 'at_least 2000'
			when total between 1000 and 2000 then ' between 1000 and 2000'
			else 'less than 1000'
			end as Categories
from orders


/*14. We would like to identify top performing sales reps, which are sales reps asscoiated with more than 200 orders.
Create a table with the sales rep name, the total number of orders, and a column with these conditions:
if they have more than 200 orders = Top_Sellers
between 100-199 = Medium Sellers
less than 100  = Low Sellers */

select sales_reps.name, orders.total,
		case when total > 200 then 'top_sellers'
			when  total between 100 and 199 then 'medium_sellers'
			else 'low_sellers'
			end as sellers_level
		
from orders
join accounts
on orders.account_id = accounts.id
join sales_reps
on accounts.sales_rep_id = sales_reps.id


--15.Write a query that returns the number of accounts without a sales rep

select count(accounts.id) as Total_no_accounts
from accounts


