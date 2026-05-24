-- SQL Reatil Sales Analysis - P1 

-- create table
create table retail_sales(
transactions_id int primary key,
sale_date date,
sale_time time,	
customer_id int,
gender varchar (15),
age int,
category varchar (15),	
quantiy int,
price_per_unit float,
cogs float,
total_sale float
);

select * from retail_sales;

select 
count(*) 
from retail_sales;

-- Data Cleaning 
select * from retail_sales
where 
transactions_id is null 
or 
sale_date is null
or 
sale_time is null
or 
customer_id is null
or 
gender is null 
or 
age is null 
or
category is null 
or 
quantiy is null 
or 
price_per_unit is null 
or 
cogs is null 
or 
total_sale is null;

-- 
delete from retail_sales 
where 
transactions_id is null 
or 
sale_date is null
or 
sale_time is null
or 
customer_id is null
or 
gender is null 
or 
age is null 
or
category is null 
or 
quantiy is null 
or 
price_per_unit is null 
or 
cogs is null 
or 
total_sale is null;

-- Data Exploration 

-- How many sales we have?
select count(*) as total_sale from retail_sales;

-- How many unique customers we have?
select count(distinct customer_id) as total_sale from retail_sales;

-- How many unique category we have?
select distinct category from retail_sales;

-- Data Analysis & Business Key Problems & Answers 

-- Q.1. Retrieve all columns for sales made on `2022-11-05`
select * from retail_sales where sale_date = '2022-11-05'; 

-- Q.2. Retrieve all transactions where  category is `Clothing`, quantity sold is more than 4 and sale happened in `Nov 2022`.
select * from retail_sales where category = 'Clothing' and
to_char(sale_date, 'YYYY-MM') = '2022-11' and quantiy >= 4;

-- Q.3. Calculate the total sales (`total_sale`) for each category.
select category, sum(total_sale) from retail_sales group by category;

-- Q.4. Find the average age of customers who purchased items from the `Beauty` category.
select round(avg(age),2) as avg_age from retail_sales where category = 'Beauty';

-- Q.5. Find all transactions where `total_sale` is greater than `1000`.
select * from retail_sales where total_sale > 1000;

-- Q.6. Find the total number of transactions made by each gender in each category.
select gender, category, count(transactions_id) from retail_sales group by gender , category order by 1;

-- Q.7. Calculate the average sale for each month and identify the best-selling month in each year.
select 
      year,
	  month,
	  avg_sale
from 
(
select 
extract (year from sale_date) as year,
extract (month from sale_date) as month,
avg(total_sale) as avg_sale, 
rank() over(partition by extract (year from sale_date) order by avg(total_sale) desc) as rank 
from retail_sales
group by 1,2) as t1 
where rank = 1

-- Q.8. Find the top 5 customers based on highest total sales.
select customer_id, sum(total_sale) from retail_sales group by 1 order by 2 desc limit 5;

-- Q.9. Find the number of unique customers who purchased items from each category.
select category, count(distinct customer_id) from retail_sales group by category;

-- Q.10. Create shifts based on sale time (Morning: before 12 , Afternoon: between 12 and 17, Evening: after 17)
with hourly_sales
as
(
select *, 
    case 
	    when extract(hour from sale_time) < 12 then 'morning'
		when extract(hour from sale_time) between 12 and 17 then 'afternoon'
		else 'evening'
	end as shift
from retail_sales
)
select shift,
count (*) as total_orders
from hourly_sales
group by shift;

-- end of project
