-- Select everything from sales table ?

select * from sales;

-- Add a Amount per Box column with SQL ?

Select SaleDate, Amount, Boxes, Amount / boxes  from sales;

-- Name a field with AS in SQL ?

Select SaleDate, Amount, Boxes, Amount / boxes as 'Amount per box'  from sales;

-- Select everything from sales where amount is geater than 10000 ?

select * from sales
where amount > 10000;

-- Show sales data where amount is smaller than 10,000 by descending order ?
select * from sales
where amount < 10000
order by amount desc;

-- Show sales data where geography is g1 by product ID & descending order of amounts ?

select * from sales
where geoid='g1'
order by PID, Amount desc;

-- Show Sales where amount is greater than 10000 and SaleDate is gretaer than or equal to 1st Jan 2022 ?

Select * from sales
where amount > 10000 and SaleDate >= '2022-01-01';

-- Show Date and amount from Sales where amount is getaer than 15000 and year is 2022 ?

select SaleDate, Amount from sales
where amount > 15000 and year(SaleDate) = 2022


-- Show boxes from sales where no of boxes is more than 0 and less than or equal to 50 ?

select * from sales
where boxes >0 and boxes <=50;

--  Show boxes from sales where no of boxes is between 0 and 50 ?

select * from sales
where boxes between 0 and 50;

-- Show SalesDate,Amount,Boxes from sales where day is monday

select SaleDate, Amount, Boxes, weekday(SaleDate) as 'Day of week'
from sales
where weekday(SaleDate) = 0;


-- Show everything from people where team is delish or juices ?

select * from people
where team = 'Delish' or team = 'Jucies';

or 

select * from people
where team in ('Delish','Jucies');

-- Select all the peoples where salesperson name start with B ?

select * from people
where salesperson like 'B%';

-- Select all the peoples where salesperson name where 'A' is present anywhere is the name ?

select * from people
where salesperson like '%A%';


-- Categeorize the amount of sales from Sales Table ?

select 	SaleDate,Amount,
case
when amount < 1000 then 'Under 1k'
when amount < 5000 then 'Under 5k'
when amount < 10000 then 'Under 10k'
else 'Above 10 k'
end as 'Amount Category'
from Sales ;

-- Name all the people who is selling the products ?

Select s.saleDate,s.Amount,p.salesperson,s.spid,p.spid
from sales s
join people p on
s.spid=p.spid;

-- Name all the product that we are selling in the shipment ?

Select s.saleDate,s.amount,p.product,s.pid,p.pid
from sales s
left join products p on p.pid=s.pid;

-- Name all the people who are selling the products and product name that are selling in the shipment ?

Select sales.saleDate,sales.amount,products.product,people.salesperson,people.team
from sales 
join people  on people.SPID=sales.SPID
join products on sales.pid=products.pid;

-- Name all the people who are selling the products in india and sales amount is more than 500 with product name that are selling in the shipment ?

Select sales.saleDate,sales.amount,products.product,people.salesperson,people.team,geo.Geo
from sales
join people  on people.SPID=sales.SPID
join products on products.pid=sales.pid
join geo on geo.geoid=sales.geoid
where geo.geo = 'India' 
and sales.amount > '500';

-- Tell me the total and avg amount of sales geographically ?

select g.geo,sum(amount),avg(amount)
from sales s
join geo g on s.geoid=g.geoid
group by g.geo;

-- Tell me the total amount by top 10 products ?

select pr.product,sum(amount) as Total_amount
from sales s
join products pr on pr.pid=s.pid
group by pr.product
order by total_amount desc
limit 10 ;

--  Print details of shipments (sales) where amounts are > 2,000 and boxes are <100?

select * from sales
where amount > '2000'and boxes < '100';

-- How many shipments (sales) each of the sales persons had in the month of January 2022?

select p.Salesperson, count(*) as 'Shipment Count'
from sales s
join people p on s.spid = p.spid
where SaleDate between '2022-1-1' and '2022-1-31'
group by p.Salesperson;

-- Which product sells more boxes? Milk Bars or Eclairs?

select pr.product , sum(boxes) as 'Total_Boxes'
from sales s
join products pr on s.pid=pr.pid
where pr.product in ( 'Milk Bars','Eclairs')
group by pr.product;

-- Which product sold more boxes in the first 7 days of February 2022? Milk Bars or Eclairs?

select pr.product , sum(boxes) as 'Total_Boxes'
from sales s
join products pr on s.pid=pr.pid
where pr.product in ( 'Milk Bars','Eclairs')
and SaleDate between '2022/02/01' and '2022/02/07'
group by pr.product;

-- Which shipments had under 100 customers & under 100 boxes? Did any of them occur on Wednesday?

select *,
case when weekday(saledate)=2 then 'Wednesday Shipment'
else 'Other_days' 
end as 'W Shipment'
from sales
where customers < 100 and boxes < 100;

-- What are the names of salespersons who had at least one shipment (sale) in the first 7 days of January 2022?

select distinct p.Salesperson 
from sales s
join people p on s.spid=p.spid
where s.SaleDate  between '2022/01/01' and '2022/01/07' ;

-- Which salespersons did not make any shipments in the first 7 days of January 2022?

select s.salesperson
from people p
where p.spid not in ( select distinct s.spid
from sales 
where s.saledate between '2022/01/01' and '2022/01/07'); 

-- How many times we shipped more than 1,000 boxes in each month?

select year(saledate) as 'year', month(saledate) as 'month', count(*) 'Times we shipped 1k boxes'
from sales
where boxes>1000
group by year(saledate), month(saledate)
order by year(saledate), month(saledate);

-- Did we ship at least one box of ‘After Nines’ to ‘New Zealand’ on all the months?

set @product_name = 'After Nines';
set @country_name = 'New Zealand';

select year(saledate) as 'Year', month(saledate) as 'Month',
if(sum(boxes)>1, 'Yes','No') as 'Status'
from sales s
join products pr on pr.PID = s.PID
join geo g on g.GeoID=s.GeoID
where pr.Product = @product_name and g.Geo = @country_name
group by year(saledate), month(saledate)
order by year(saledate), month(saledate);

-- India or Australia? Who buys more chocolate boxes on a monthly basis?

select year(saledate) as 'Year', month(saledate) as 'Month',
sum(CASE WHEN g.geo='India' = 1 THEN boxes ELSE 0 END) 'India Boxes',
sum(CASE WHEN g.geo='Australia' = 1 THEN boxes ELSE 0 END) 'Australia Boxes'
from sales s
join geo g on g.GeoID=s.GeoID
group by year(saledate), month(saledate)
order by year(saledate), month(saledate);


