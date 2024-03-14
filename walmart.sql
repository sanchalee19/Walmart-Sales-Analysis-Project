create schema walmart;
use walmart;

select * from  wsd;
describe wsd;

ALTER TABLE wsd
ADD PRIMARY KEY (`InvoiceID`(30));


ALTER TABLE wsd ADD COLUMN time_of_day VARCHAR(20);

UPDATE wsd
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);
select * from wsd;

alter table wsd drop column day_name;

-- -- -- -- -- -- -- -- -- -- -- --
-- GENERIC QUESTIONS --
-- -- -- -- -- -- -- -- -- -- -- -- 

-- 1) How many unique cities does the data have? -- 
select distinct city from wsd;

-- 2) In which city is each branch? --
select distinct city, branch from wsd;

-- -- -- -- -- -- -- -- -- -- -- --
-- PRODUCT --
-- -- -- -- -- -- -- -- -- -- -- -- 

-- 1) How many unique product lines does the data have? --
select distinct productline from wsd;

-- 2) What is the most selling product line --
select sum(quantity) as qty,productline from wsd group by productline order by qty desc
LIMIT 1;

-- 3) What product line had the largest revenue? -- 
select productline, sum(total) as total_revenue from wsd group by productline order by total_revenue desc
LIMIT 1; 

-- 4) What is the city with the largest revenue? --
select city , branch, sum(total) as total_revenue from wsd group by city,branch order by total_revenue desc
LIMIT 1;

-- 5) What product line had the largest VAT? --
select productline, avg(`tax5%`) as VAT from wsd group by productline order by VAT desc
LIMIT 1;

-- 6) Which branch sold more than average product sold? -- 
select branch , sum(quantity) as qty from wsd 
	group by branch
    having sum(quantity) > avg(quantity) order by qty desc;
    
-- 7) What is the average rating of each product line? --

select productline, round(avg(rating), 2) as avg_rating 
from wsd
group by productline
order by avg_rating desc; 

-- 8) What is the most common product line by gender? --

select productline, gender, count(gender) as total from wsd
	group by gender, productline 
    order by total desc;
-- 9) What is the most common payment? --
select payment, count(*) as count from wsd
group by payment
order by count desc
limit 1;

-- -- -- -- -- -- -- -- -- -- -- --
-- SALES --
-- -- -- -- -- -- -- -- -- -- -- --
-- 1) At what time of the day the sales is more?
select count(*) as total_sales , time_of_day from wsd 
group by time_of_day
order by total_sales desc
LIMIT 1;

-- 2) Which of the customer types brings the most revenue?
select customertype , sum(total) as total_revenue
from wsd
group by customertype
order by total_revenue desc
LIMIT 1; 

-- 3) Which city has the largest tax percent/ VAT (Value Added Tax) ?
select city , round(avg(`tax5%`), 2) as largest_VAT from wsd
group by city
order by largest_VAT desc
limit 1;

-- 4) Which customer type pays the most in VAT?
select Customertype,  round(avg(`tax5%`), 2) as largest_VAT from wsd
group by Customertype
order by largest_VAT desc
limit 1;

-- -- -- -- -- -- -- -- -- -- -- --
-- CUSTOMER --
-- -- -- -- -- -- -- -- -- -- -- --
-- 1) How many unique customer types does the data have?
select distinct customertype from wsd;

-- 2)  How many unique payment methods does the data have?
select distinct payment from wsd;

-- 3) What is the most common customer type? / which customer type buys the most? 
select customertype , count(customertype) as count from wsd
group by customertype
order by count desc 
limit 1;

-- 4) What is the gender of most of the customers?
select customertype, gender , count(gender) as count from wsd 
group by gender, Customertype
order by count desc;

-- 5) Which time of the day do customers give most ratings?
select time_of_day , avg(rating) as avg_rating     # count can also be used.
from wsd
group by time_of_day
order by avg_rating desc
limit 1;
 
-- 6) Which time of the day do customers give most ratings per branch?
select branch, time_of_day , round(avg(rating), 2) as avg_rating     # count can also be used.
from wsd
group by time_of_day, branch
order by avg_rating desc;
# A - afternoon , B - Morning, C - Evening