select * from sql_project_p2
order by transactions_id asc limit 10;

select count(*) from retail_sales;

create database sql_project_p2;

use sql_project_p2;

create table sql_project_p2(
	transactions_id int,	
    sale_date	date,
    sale_time	time,
    customer_id	int,
    gender	varchar(10),
    age	int,
    category varchar(20),	
    quantiy	int,
    price_per_unit	float,
    cogs	float,
    total_sale float
);
update table 
rename column reatil_sales;
select * from sql_project_p2
order by transactions_id;


select count(*) from sql_project_p2;

select * from sql_project_p2
where (total_sale and sale_date) is null;

-- Data Exploration

-- How many sales we have?
select count(*) as total_sale from sql_project_p2;

-- How any unique customers we have?
select count(distinct customer_id) from sql_project_p2;

-- How mnay category we have?
select distinct category from sql_project_p2;

-- Data Analysis & Business Problems and Answers

-- Q1. Write a SQL Query to retrieve all columns for sale made on '2022-11-05'.
select *
from sql_project_p2
where sale_date = '2022-11-05';

-- Q2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:

select category,
		sum(quantiy)
from sql_project_p2
where category = 'Clothing'
	and 
    to_char(sale_date, 'yyyy-mm') = '2022-11'
group by 1;



select *
from sql_project_p2
where category = 'Clothing' 
or date_format(sale_date, '%y-%m') = '2022-11-05'
and quantiy >=4;


-- Q3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
select category,
	sum(total_sale) as net_sale,
    count(*) as total_orders
from sql_project_p2
group by category;

-- Q4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
select round(avg(age), 2) as AVG_Age
from sql_project_p2
where category = "Beauty";

-- Q5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
select *
from sql_project_p2
where total_sale > 1000;

-- Q6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
select 
	category,
    gender,
    count(*) as total_trans
from sql_project_p2
group by category, gender
order by 1; 

-- Q7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
select 
	extract(year from sale_date)as year,
    extract(month from sale_date)as month,
    avg(total_sale) as avg_sale
from sql_project_p2
group by 1, 2
order by 1, 3 desc;

-- Ranking
select 
	extract(year from sale_date)as year,
    extract(month from sale_date)as month,
    avg(total_sale) as avg_sale,
    rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as Ranking
from sql_project_p2
group by 1, 2;
-- order by 1, 3 desc;

-- 1st Ranking
select * from
(
	select 
	extract(year from sale_date)as year,
    extract(month from sale_date)as month,
    avg(total_sale) as avg_sale,
    rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as Ranking
	from sql_project_p2
	group by 1, 2
) as t1
where ranking = 1;

-- ignore ranking
select year, month, avg_sale
from
(
	select 
	extract(year from sale_date)as year,
    extract(month from sale_date)as month,
    avg(total_sale) as avg_sale,
    rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as Ranking
	from sql_project_p2
	group by 1, 2
) as t1
where ranking = 1;

-- Q8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
select	customer_id,
		sum(total_sale) as total_sales
from sql_project_p2
group by 1
order by 2 desc
limit 5 ;


-- Q9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
select	category,
		count(distinct customer_id) as Unique_id
from sql_project_p2
group by 1;


-- Q10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
-- shifting
select *, 
	case
		when extract(hour from sale_time) < 12 then 'Morning'
        when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
        else 'Evening'
	end as shift
from sql_project_p2;

-- CTE
with hourly_sale as
(
select *, 
	case
		when extract(hour from sale_time) < 12 then 'Morning'
        when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
        else 'Evening'
	end as shift
from sql_project_p2
)
select shift,
		count(*) as total_sales
from hourly_sale
group by shift;