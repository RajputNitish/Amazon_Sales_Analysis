create schema Amazon;


-- importing data from the local file



-- Alter The name of the column
ALTER TABLE amazon CHANGE `Invoice ID` Invoice_ID text;
ALTER TABLE amazon CHANGE `Customer type` Customer_type TEXT;
ALTER TABLE amazon CHANGE `Product line` Product_line TEXT;
ALTER TABLE amazon CHANGE `Unit price` Unit_price double;
ALTER TABLE amazon CHANGE `Tax 5%` VAT double;
ALTER TABLE amazon CHANGE `gross margin percentage` gross_margin_percentage double;
ALTER TABLE amazon CHANGE `gross income` gross_income double;

-- Change the datatype of the column

alter table amazon modify column Invoice_ID varchar(30);
alter table amazon modify column Branch varchar(5);
alter table amazon modify column City varchar(30);
alter table amazon modify column Customer_type varchar(30);
alter table amazon modify column Gender varchar(10);
alter table amazon modify column Product_line varchar(100);
alter table amazon modify column Unit_price decimal(10,2);
alter table amazon modify column Quantity int;
alter table amazon modify column VAT float(6,4);
alter table amazon modify column Total decimal(10,2);
alter table amazon modify column Date date;
alter table amazon modify column Time Time;
alter table amazon modify column Payment varchar(20);
alter table amazon modify column cogs decimal(10,2);
alter table amazon modify column gross_margin_percentage float(11,9);
alter table amazon modify column gross_income decimal(10,2);
alter table amazon modify column Rating decimal(4,1);

-- Check if any null value in the dataset 

select * from amazon where Invoice_ID is null or Branch is null
or Customer_type is null or Product_line is null or Quantity is null or 
total is null or Gender is null or Date is null or Payment is null or 
gross_margin_percentage is null or rating is null or gross_income is null;

-- Feature Engineering - add new column
alter table amazon
add TimeofDay varchar(255);

UPDATE amazon
SET timeofday = CASE
    WHEN HOUR(`Time`) >= 5 AND HOUR(`Time`) < 12 THEN 'Morning'
    WHEN HOUR(`Time`) >= 12 AND HOUR(`Time`) < 17 THEN 'Afternoon'
    ELSE 'Evening'
END;

-- 1. What is the count of distinct cities in the dataset?
select distinct city from amazon;

-- 2. For each branch, what is the corresponding city?
select branch,city from amazon
group by branch,city;

-- 3. What is the count of distinct product lines in the dataset?
select count(distinct Product_line) from amazon;

-- 4. Which payment method occurs most frequently?
select payment,count(payment) as Most_freq from amazon
group by Payment;

-- 5. Which product line has the highest sales?
select Product_line,max(total) from amazon
group by Product_line
order by max(Total) desc;

-- 6. How much revenue is generated each month?
select monthname(Date) as Each_month,sum(total) as revenue from amazon
group by Each_month;

-- 7. In which month did the cost of goods sold reach its peak?
select monthname(date), sum(cogs) as costofgood from amazon
group by monthname(date);

-- 8. Which product line generated the highest revenue?
select product_line, max(total) as Highest_revenue
from amazon
group by Product_line
order by Highest_revenue desc;

-- 9. In which city was the highest revenue recorded?
select city,sum(Total) as High_revenue from amazon
group by City;

-- 10. Which product line incurred the highest Value Added Tax?
select product_line, sum(VAT) as High_vat from amazon
group by Product_line
order by high_vat desc;

-- 11. For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."

SELECT product_line, total,
  (CASE WHEN total > (SELECT AVG(total) FROM amazon) 
  THEN 'Good' ELSE 'Bad' END) AS sales_performance
FROM amazon;

-- 12. Identify the branch that exceeded the average number of products sold.
select * from amazon;

select Branch,avg(Quantity) as avg_quantity from amazon
group by Branch
having avg_quantity > (select avg(Quantity) from amazon);

-- 13. Which product line is most frequently associated with each gender?
with most_frequent as (select Product_line,gender,count(*) as no_of_purchase
from amazon
group by gender,product_line)
select product_line,
sum(case when gender="male" then no_of_purchase else 0 end) as male_freq,
sum(case when gender="female" then no_of_purchase else 0 end) as female_freq
from most_frequent
group by product_line
order by male_freq,female_freq desc;

-- 14. Calculate the average rating for each product line.
select Product_line,avg(rating) as avg_rating from amazon
group by Product_line
order by avg_rating desc;

-- 15. Count the sales occurrences for each time of day on every weekday.
select dayname(Date) as every_weekday ,TimeofDay ,
count(*) as sales_occ from amazon
group by TimeofDay,every_weekday
order by sales_occ desc;

-- 16. Identify the customer type contributing the highest revenue.
select customer_type,sum(total) as High_revenue from amazon
group by customer_type;

-- 17. Determine the city with the highest VAT percentage.
select City,sum(VAT) as high_vat from amazon
group by city;

-- 18. Determine the customer_type with the highest VAT payment.
select Customer_type,sum(VAT) as high_vat from amazon
group by Customer_type;

-- 19. What is the count of distinct customer types in the dataset?
select count(distinct customer_type) as customer_types from amazon;

-- 20. What is the count of distinct payment methods in the dataset?
select count(distinct payment) as payment_method from amazon;

-- 21. Which customer type occurs most frequently?
select Customer_type,count(Customer_type) as most_occur
 from amazon
 group by Customer_type
 order by most_occur;
 
 -- 22. Identify the customer type with the highest purchase frequency.
 select Customer_type,count(*) as Purchase_frequency from amazon
group by Customer_type;

-- 23. Determine the predominant gender among customers.
select gender,count(*) as customer_count from amazon
group by gender
order by customer_count;

-- 24. Examine the distribution of genders within each branch.
SELECT branch,
SUM(CASE WHEN gender = 'Male' THEN 1 ELSE 0 END) AS male_count,
SUM(CASE WHEN gender = 'Female' THEN 1 ELSE 0 END) AS female_count,
count(*) as total_count from amazon
group by Branch;

-- 25. Identify the time of day when customers provide the most ratings.
select timeofday ,count(rating) as most_ra from amazon
group by TimeofDay
order by TimeofDay desc;

-- 26.Determine the time of day with the highest customer ratings for each branch.
select branch,timeofday,max(rating) as high_rating from amazon
group by branch,timeofday
order by high_rating desc;

-- 27.Identify the day of the week with the highest average ratings.
select dayname(date) as day_of_week,avg(rating) as avg_rating
 from amazon
 group by day_of_week
 order by avg_rating desc;
 
 -- 28.Determine the day of the week with the highest average ratings for each branch.
 select Branch,dayname(date) as day_of_week,avg(rating) as avg_rating
 from amazon
 group by branch,day_of_week
 order by avg_rating desc;