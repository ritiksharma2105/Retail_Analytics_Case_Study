#--------------------------------------Retail Analytics Case Study-----------------------------------------#

Create database Retail_Analytics;

use Retail_analytics;

/*----------------------------------- Data Understanding and Data Cleaning ------------------------------*/

Select * from customer_profiles;   -- Table 1 --
/*
Customer Profiles
 
> Customer ID - Unique or not?
> Age, Gender, Location of a customer
> Joining Date of a Customer? Is this First Purches or First failed Purchsed?
> Col name of ï»¿CustomerID to -- > CustomerID
> How many rows?
*/

select * from product_inventory; -- Table 2 --
/*
Product Inventory

> Col name of ï»¿ï»¿ProductID to -- > ProductID
> Unique Rows?
> Product Name -- How many products do we have?
> Category - how many category are there and which category comes under which product?
> Stock level? Means Inventory?
> Price?  Individual Price
*/

select * from sales_transaction; -- Table 3 --

/*
Sales Transaction

> Col name of ï»¿ï»¿ï»¿TransactionID to -- > TransactionID
> CustomerID
> ProductID
> PK and FK?
*/

-- Describing the tables --

DESC customer_profiles;                 -- Describing Table --
DESC sales_transaction;                 -- Describing Table --
DESC product_inventory;                 -- Describing Table --

#------------------------------------Changing Column Names---------------------------------------#

Alter Table customer_profiles  -- Changing the customer_profile col name --
Change ï»¿CustomerID CustomerID INT;

Select * from customer_profiles;             -- Retrieving table after changes --
       
Alter Table sales_transaction -- Changing the sales_transaction col name --
Change ï»¿TransactionID TransactionID INT;

Select * from sales_transaction;              -- Retrieving table after changes --

Alter Table product_inventory -- Changing the Product_Inventory col name --     
Change ï»¿ProductID ProductID INT;

Select * from product_inventory;               -- Retrieving table after changes --

#------------------------------------Identifying Primary Key in tables & removing duplicates--------------------------------------#

Select * from customer_profiles;

Select Count(*) from customer_profiles;              -- Retrieving the Count for Customers Table --

Select CustomerID,
Count(*) from customer_profiles
group by CustomerID; -- There is unique values in each customerID

#------------------------------------ To Create PK or checking is there any PK & FK existing --------------------------------------#

-- Customer Profiles
Select customerID,
Count(*) from customer_profiles
Group By CustomerID
Having Count(*) > 1; -- There is no duplicate in CustomerID of customer_profiles (PK)

DESC customer_profiles;

-- For product_inventory
Select * from product_inventory;

Select ProductID,
Count(*) from product_inventory
Group by ProductID
Having Count(*) > 1;  -- There is no duplicate in CustomerID of customer_profiles (PK)

-- For sales_transaction
Select * from sales_transaction;

Select TransactionID,
Count(*) from sales_transaction
Group By TransactionID
Having Count(*) > 1; -- There is duplicates in sales transaction in transaction ID

/*
-- We have to remove the dublicates  
-- Create a dummy table 
-- Insert a data into a dummy table 
-- drop the actual tble 
-- rename the dummy table to actual table
   */
   
Create Table sales_transaction_nodup as                   -- Create New Table for Distinct Item --
Select Distinct * from sales_transaction;

Select * from sales_transaction_nodup;

Select TransactionID,
Count(*) from sales_transaction
Group By TransactionID
Having Count(*) > 1;

Drop Table sales_transaction; -- Executed and Implemented

Alter Table sales_transaction_nodup
Rename to sales_transaction;

Select * from customer_profiles;
select * from product_inventory;
Select * from sales_transaction;

#------------------------------------ Checking of Null & Missing Values --------------------------------------#

Select * from sales_transaction st 
Join product_inventory pi 
On st.ProductID = pi.ProductID
Where pi.ProductID is null; -- no missing value


select * from customer_profiles cp
Join Sales_transaction as st
on cp.CustomerID = st.CustomerID
Where cp.CustomerID is null; -- no missing value

#------------------------------------ Checking table data matching Values --------------------------------------#

-- Left JOIN
-- Row 1 and Matches Row 1
-- Row 2 no match with other table

select 
pi.ProductID,
st.TransactionID,
pi.Price as pi_price,
st.Price as st_price
from sales_transaction st
Join Product_inventory pi
On pi.ProductID = st.ProductID
Where st.Price <> pi.Price; -- this identifies the duplicate & repeated wrong values that are not matching with each other

Select pi.ProductID, pi.Price as pi_price from product_inventory pi Where pi.ProductID = 51;
select st.TransactionID, st.ProductID, st.Price as st_price from sales_transaction st where st.ProductID = 51; -- this both showing the duplicate 1 value repeated for many


/*
-- Goal --
1. Look into corrct price from product_inventory table  -- 93.12
2. Update all the rows which is present in sales_transution table 
 where  price is wrong or 9312
*/

Select * from product_inventory pi
join sales_transaction st 
on pi.ProductID = st.ProductID
Where pi.ProductID = st.productID; -- Joined two table here for comparing the prices

-- One off the way we are removing the discre in the data

update sales_transaction st
Join product_inventory pi 
on st.ProductID = pi.ProductID
Set st.Price = pi.Price
Where st.Price <> pi.price; -- Updated Price of both the tables by comparing St.Price & Pi.Price

Update Sales_transaction st -- Updating sales table  -- 91 = 91
Set Price = (
	Select pi.Price 
    from product_inventory pi
    where pi.ProductID = st.ProductID)
Where st.ProductID in
   (
   Select pi.ProductID
   From Product_inventory pi
   Where st.price <> pi.price
   ); 	
   
-- We are using multiple table -- Join and Sub query 

/*
-- Check for the Primary Key
-- Validation Step - Join
-- Compare values and check for the discrepency  -- JOIN and UPDATE and Sub Query 
*/

/* 
-- Missing Values and Working on NULL
*/

select * from customer_profiles;
select * from product_inventory;
select * from sales_transaction;

Select Count(*) from customer_profiles
Where Location is null;

Update Customer_profiles
Set Location = 'Unknown'
Where Location is null; -- this query not working

Update Customer_profiles
Set Location = 'Unknown'
Where Location = ''; -- this query worked & replaced all blank cells to unknown type

Select Count(*) from customer_profiles
Where Location = '';

#---------------------------------------------------------------------------------------#

#-------Analyzing & Cleaning DATE Column---------#

-- 1. Sales Transaction Table

select * from sales_transaction;
desc sales_transaction;

Create Table sales_transaction_updated As 
Select *, Cast(TransactionDate as DATE) as Transaction_Date_Updated
From Sales_transaction; 

Drop table sales_transaction;

Select * from sales_transaction_updated;

Alter Table sales_transaction_updated
Rename to sales_transaction;

select * from sales_transaction;
desc sales_transaction;

-- 2. Customer Profiles Table

Select * from customer_profiles;
Desc customer_profiles;

Create table customer_profiles_updated As
Select *, Cast(JoinDate as Date) as JoinDate_Updated
From customer_profiles;

Drop table customer_profiles;

Alter Table customer_profiles_updated
Rename to customer_profiles;

Select * from customer_profiles;

-- 3. Sales transaction 

Select * from sales_transaction;

Update sales_transaction
Set Transaction_Date_Updated = date_format(str_to_date(TransactionDate, '%d/%m/%Y'), '%Y-%m-%d');

#----------------------- Setting a primary Key -----------------------------#

select * from customer_profiles;
select * from product_inventory;
select * from sales_transaction;

Alter Table customer_profiles
ADD primary key (CustomerID);

Alter Table product_inventory
Add primary key (ProductID);

Alter Table sales_transaction
Add primary key (TransactionID);

/*
1. What is the Table and how to know thw tables and cols
2. Try finding it out PRIMARY KEY AND how to check (Group by and Having)
3. Relationship between the tables -- JOIN
4. Discripency in the table and price (UPDATE, JOIN and Sub Query)
5. NULL -- missing values 
6. DATE FORMAT and update with diff table 
*/

Select * from customer_profiles;
Select JoinDate, JoinDate_Updated,
str_to_date(JoinDate, '%d/%m/%Y') as Updated_Date
From customer_profiles;

update customer_profiles
Set JoinDate_Updated = str_to_date(JoinDate, '%d/%m/%Y');

select * from customer_profiles;

-- Exploratory Data Analysis
select * from product_inventory;

Desc customer_profiles;

Select 
category,
count(*) as Category_count
from product_inventory
Group by Category;

Select 
ProductName,
Count(*) Product_name_Count
from Product_inventory
Group by ProductName
Having Count(*) > 1;

SELECT Category,
COUNT(ProductName) AS TotalProducts,
Sum(StockLevel) as sum_stock_level,
Round(Avg(StockLevel),2) as Avg_Stock_levels
FROM Product_inventory
GROUP BY Category
Order By sum_stock_level desc;

/* 
--> I want you to do the distribution? --

1. Total Sales Trans
2. Averga, Revenue or sales
3. Daily & monthly trend, group by
*/

#-------------------------------------------------------------------------------------------------#

Select * from sales_transaction;      -- Retrieving the sales transaction table

-- Total revenue, Total Units, Total Transactions

Select 
    Count(TransactionID) as Total_Transactions,
    Sum(QuantityPurchased) as Total_units,
    Round(Sum(QuantityPurchased * Price), 2) as Total_Revenue
From Sales_transaction;

#---------------------------------------------------------------------------------------#

-- Monthly Sales Trend Category wise -- View

Create view Cat_Wise_Mnthly_Sales_Trend AS
Select Distinct pi.Category,
	 Month(Transaction_Date_Updated) as Month,
	 date_format(st.Transaction_Date_Updated, '%M') as Month_Name,
     Round(Sum(st.QuantityPurchased * st.Price),0) as Total_Sales
From sales_transaction st
join product_inventory pi On st.ProductId = pi.ProductId
Group By pi.Category,
Month(Transaction_Date_Updated),
date_format(st.Transaction_Date_Updated, '%M')
Order By Month Asc;

Select * from Cat_Wise_Mnthly_Sales_Trend;

#---------------------------------------------------------------------------------------#

-- Category Wise Current Inv Vs Inventory Value

Create View Cat_CurInv_InvValue as 
Select category,
    round(sum(StockLevel),0) as Current_Inventory,
    Round(sum(StockLevel * Price),0) as Inventory_Value
From product_inventory
Group By category
Order BY Current_Inventory, Inventory_Value;

Select * from Cat_CurInv_InvValue;
   
Select * from sales_transaction;
Select * from product_inventory;

#---------------------------------------------------------------------------------------#

-- Revenue Distribution by Product

Select 
    ProductID,
    Sum(QuantityPurchased) as Total_units,
    Round(Sum(QuantityPurchased * Price), 2) as Total_Revenue
From Sales_transaction
Group By ProductID
Order By Total_Revenue DESC;

#---------------------------------------------------------------------------------------#

-- Revenue Distribution by Customer

Select 
    CustomerID,
    Count(TransactionID) as Total_transactions,
    Sum(QuantityPurchased) as Total_units,
    Round(Sum(QuantityPurchased * Price), 2) as Total_Revenue
From Sales_transaction
Group By CustomerID
Order By Total_Revenue DESC;

#---------------------------------------------------------------------------------------#

-- Transactions Count by Date (Daily Trend)

Select 
    Transaction_Date_Updated,
    Count(TransactionID) as Total_transactions,
    Sum(QuantityPurchased) as Total_units,
    Round(Sum(QuantityPurchased * Price), 2) as Total_Revenue
From Sales_transaction
Group By Transaction_Date_Updated
Order By Transaction_Date_Updated;

#---------------------------------------------------------------------------------------#

-- Monthly Sales Distribution

Select 
    date_format(Transaction_Date_Updated, '%Y-%m') as Month,
    Count(TransactionID) as Total_transactions,
    Sum(QuantityPurchased) as Total_units,
    Round(Sum(QuantityPurchased * Price), 2) as Total_Revenue
From Sales_transaction
Group By Month
Order By Month;

#---------------------------------------------------------------------------------------#

-- Products by Revenue

Select 
   ProductID,
   Round(Sum(QuantityPurchased * Price), 2) as total_revenue
From sales_transaction
Group by ProductID
Order By total_revenue DESC
Limit 5;

-- Repeat Customers (Customers who purchased more than 1 time)

Select 
    CustomerID, ProductID,
    Count(TransactionID) as Total_transaction
From Sales_transaction
Group By CustomerID, ProductID
Having Count(TransactionID) > 1
Order By Total_transaction Desc;

-- using SubQuery 
Select 
    Count(*) as Repeat_customers
From ( 
     Select CustomerID
     From sales_transaction
     Group by CustomerID
     having Count(TransactionID) > 1
	 ) t;

-- Transaction Value Distribution (Low, Medium, High)
Select
    Case 
       When (QuantityPurchased * Price) < 500 Then 'Low'
       When (QuantityPurchased * Price) between 500 and 2000 Then 'Medium'
       Else 'High'
	End as Order_value_bucket,
    Count(*) as Total_Transaction
From Sales_transaction
Group by Order_value_bucket;

#---------------------------------------------------------------------------------------#

-- Price Distribution (Min, Max, Avg Price)

Select
    Round(Max(Price), 2) as Max_Price,
    Round(Min(Price), 2) as Min_Price,
    Round(Avg(Price), 2) as Avg_Price
From sales_transaction;

#---------------------------------------------------------------------------------------#

-- Category-wise Distribution (If you have products table)

Select 
    pi.Category,
    sum(st.QuantityPurchased) as total_units,
    Round(Sum(st.QuantityPurchased * st.Price), 2) total_revenue
    From sales_transaction st
Join product_inventory pi
On st.ProductID = pi.ProductID
Group By pi.Category
Order By total_revenue desc;

#---------------------------------------------------------------------------------------#

-- Get a summary of total sales and quantities sold per product.

Select 
    pi.Category,
    pi.ProductName,
    Round(sum(st.QuantityPurchased * st.Price), 2) as total_sales,
    Sum(st.QuantityPurchased) as Total_Purchase
From Sales_transaction st
Join Product_inventory pi
On st.ProductID = pi.ProductID
Group By pi.Category, pi.ProductName;

#---------------------------------------------------------------------------------------#

-- Calculate the category wise total sales and total purchase

Select 
    pi.Category,
    Round(sum(st.QuantityPurchased * st.Price), 2) as total_sales,
    Sum(st.QuantityPurchased) as total_purchase,
    Round(Avg(st.Price),2) as Avg_price
From Sales_transaction st
Join Product_inventory pi
On st.ProductID = pi.ProductID
Group By pi.Category
order by total_sales desc; -- category wise only

#---------------------------------------------------------------------------------------#

-- Customer Purchase Frequency

select * from sales_transaction;

Select 
   CustomerID,
   Count(*) as Total_transaction
From Sales_transaction
Group By CustomerID
Order By Total_transaction desc;

#---------------------------------------------------------------------------------------#

-- Product Categories Performance

Select 
    pi.Category,
    Round(sum(st.QuantityPurchased * st.Price), 2) as total_sales,
    Sum(st.QuantityPurchased) as total_Qty,
    Round(Avg(st.Price),2) as Avg_price
From Sales_transaction st
Join Product_inventory pi
On st.ProductID = pi.ProductID
Group By pi.Category
order by total_sales desc;

#---------------------------------------------------------------------------------------#

 -- High Sales Products  top 10 -- top 5 
 
Select 
   ProductID,
   Round(Sum(QuantityPurchased * Price), 2) as total_sales
From sales_transaction
Group by ProductID
Order By total_sales DESC
Limit 5;

#---------------------------------------------------------------------------------------#

-- Low Sales Products

Select 
   ProductID,
   Round(Sum(QuantityPurchased * Price), 2) as total_sales
From sales_transaction
Group by ProductID
Order By total_sales
Limit 5;

#---------------------------------------------------------------------------------------#

-- Sales Trends

Select 
    Year(Transaction_Date_Updated) as Years,
    Month(Transaction_Date_Updated) as Months,
    Count(*) as Total_transactions,
    Round(Sum(QuantityPurchased * Price), 2) as Total_Revenue
From Sales_transaction
Group By Years, Months;

#---------------------------------------------------------------------------------------#

-- Growth rate of sales M-o_M --

-- Write a SQL query to understand the month on month growth rate of sales of the company 
-- which will help understand the growth trend of the company.

-- (Current-Previous/Previous) * 100

Create View MoM_Sales As 
With Monthly_sales as (
Select 
    extract(Month from Transaction_Date_Updated) as Monthh,
    Round(Sum(QuantityPurchased * Price), 2) as Total_Sales
From sales_transaction
Group By extract(Month from Transaction_Date_Updated)
)
Select 
     Monthh,
     Total_Sales,
     lag(Total_Sales) Over(order by Monthh) as Previous_month_sales,
     round((Total_Sales - lag(Total_Sales) Over(order by Monthh)) /
     lag(Total_Sales) Over(order by Monthh) * 100, 2) as MoM_Growth
From Monthly_sales
Order By Monthh; -- -- (Current-Previous/Previous) * 100 

Select * from Mom_sales;

-- Using Sub Query --

Select 
    Monthh,
	Total_Sales,
    Lag(Total_Sales) Over(Order By Monthh) as Previous_month_sales,
    Round(((Total_sales - lag(Total_Sales) Over(Order By Monthh)) / lag(Total_Sales) Over(Order By Monthh)) * 100, 2) as MoM_Growth_Percentage
From (                                                                            
      Select                                                                            
           extract(Month from Transaction_Date_Updated) as Monthh,
           Round(sum(QuantityPurchased * Price), 2) as Total_sales
	  From 
      Sales_transaction
      Group by
      extract(Month from Transaction_Date_Updated)
      ) as Monthly_sales
Order By Monthh;

#---------------------------------------------------------------------------------------#

-- Customers - High Purchase Frequency and Revenue

-- Frequency > 10, Revenue > 1500 (assumed)

Select * from sales_transaction;

Select CustomerID, 
Count(*) as Purchase_Frequency,
Round(Sum(QuantityPurchased * Price), 2) as Total_Sales
From sales_transaction
group by CustomerID
Having Purchase_Frequency > 10 and Total_Sales > 1000 -- we can modify it by replacing values
order by Purchase_Frequency Desc;

#---------------------------------------------------------------------------------------#

-- Occasional Customers - Low Purchase Frequency

-- Frequency < 10 or 2 or 3 (assumed)

Select * from sales_transaction;

Select CustomerID, 
Count(*) as Purchase_Frequency,
Round(Sum(QuantityPurchased * Price), 2) as Total_Sales
From sales_transaction
group by CustomerID
Having Purchase_Frequency <= 2 -- we can modify it by replacing values
order by Purchase_Frequency Desc;

#---------------------------------------------------------------------------------------#

-- Repeat Purchase Patterns

Select * from sales_transaction;

Select CustomerID, ProductID,
Count(*) as Repeat_Purchase
From Sales_transaction
Group by CustomerID, ProductID
order by CustomerID;
  
 Select CustomerID,
Count(ProductID) as Count_of_products
From Sales_transaction
Group by CustomerID
Having Count_of_products > 1
order by Count_of_products DESC; 

#---------------------------------------------------------------------------------------#

-- Loyalty Indicators

Select * from sales_transaction;

With Tran_date As (
Select CustomerID, TransactionID, 
str_to_date(Transaction_Date_Updated, '%Y-%m-%d') as TransactionDate
From sales_transaction
)
Select 
CustomerID,
    min(TransactionDate) as FirstPurchase,
    Max(TransactionDate) as LastPurchase,
    Max(TransactionDate) - min(TransactionDate) as DayBetween,
    Count(TransactionID) as Total_transaction
From Tran_date
Group by CustomerID
Having DayBetween > 365
order by DayBetween DESC;

#---------------------------------------------------------------------------------------#

-- Customer Segmentation based on quantity purchased  (31156)-(31554)

Select * from sales_transaction;

Create Table Cust_Segment AS
Select CustomerID,
       Case 
           When TotalQuantity > 30 Then 'High'
           When TotalQuantity between 10 and 30 Then 'Medium'
           When TotalQuantity between 1 and 10 Then 'Low'
           Else 'None'
           End as customer_Segment
From (
     Select CustomerID,
     Sum(QuantityPurchased) as TotalQuantity
	from sales_transaction
    Group By CustomerID
    ) as t;
    
    Select Count(*), Customer_Segment from Cust_Segment
    Group By Customer_Segment;
    
#Created view function below (for simplifying complex data)

Create View Vw_Customer_Segment AS
Select CustomerID,
       Case 
           When TotalQuantity > 30 Then 'High'
           When TotalQuantity between 10 and 30 Then 'Medium'
           When TotalQuantity between 1 and 10 Then 'Low'
           Else 'None'
           End as customer_Segment
From (
     Select a.CustomerID,
     Sum(b.QuantityPurchased) as TotalQuantity
	from customer_profiles a
    Join sales_transaction b
    On a.CustomerID=b.CustomerID
    Group By a.CustomerID
    ) as t;
    
Select * from Vw_Customer_Segment
Where customer_segment = 'Medium';

#---------------------------------------------------------------------------------------#

-- Sales Contribution by Top 20% Customers (Pareto Principle)

-- Find what portion of a  revenue is coming from top spenders.

Select * from sales_transaction;

With Customer_sales as (
Select 
    CustomerID,
	Round(Sum(QuantityPurchased * Price),2) as Total_sales
    From sales_transaction
    Group By CustomerID
 ),   
ranked as (
      Select CustomerID,
	  Total_sales,
      Sum(Total_sales) OVER() as Overall_sales,
      Round(sum(Total_sales) over(order by Total_sales Desc),2) as running_sales
From customer_sales
)
Select CustomerID, 
	   Total_sales,
       Round((running_sales / Overall_sales) * 100,2) as cumulative_percent
From ranked
Where (running_sales / Overall_sales) <= 0.20;

#---- Created view for customer Sales -----

Create View Cust_sales_cumulative_percent as
With Customer_sales as (
Select 
    CustomerID,
	Round(Sum(QuantityPurchased * Price),2) as Total_sales
    From sales_transaction
    Group By CustomerID
 ),   
ranked as (
      Select CustomerID,
	  Total_sales,
      Sum(Total_sales) OVER() as Overall_sales,
      Round(sum(Total_sales) over(order by Total_sales Desc),2) as running_sales
From customer_sales
)
Select CustomerID, 
	   Total_sales,
       Round((running_sales / Overall_sales) * 100,2) as cumulative_percent
From ranked
Where (running_sales / Overall_sales) <= 0.20;

Select * from cust_sales_cumulative_percent;

#---------------------------------------------------------------------------------------#

-- Basket Size Analysis (Avg Items per Transaction)

-- Understand how many items are typically purchased per transaction.

Select * from sales_transaction;

Select
TransactionID,
Round(avg(QuantityPurchased), 2) as Avg_items 
From Sales_transaction
Group by TransactionID
order by Avg_items Desc;

select
Round(avg(total_items), 2) as Avg_basket_size
From (
      Select TransactionID,
      Sum(QuantityPurchased) as total_items
      From sales_transaction
      Group by TransactionID
      ) as t; -- overall average_basket_size
      
-- View for Avg Basket size -- 
Create View Avg_Basket_size as
select
Round(avg(total_items), 2) as Avg_basket_size
From (
      Select TransactionID,
      Sum(QuantityPurchased) as total_items
      From sales_transaction
      Group by TransactionID
      ) as t;
      
Select * from avg_basket_size;

#---------------------------------------------------------------------------------------#

#RFM Analysis

-- RFM (Recency, Frequency, Monetory) Preparation
-- Prepares for customer segmentation using RFM logic
-- Recency- days since last purchase
-- Frequency- total transaction by customer
-- Monetary- total money spent by customer

Select * from sales_transaction; 
Select * from product_inventory;
Select * from customer_profiles;

WITH Txn_query AS (
    SELECT 
        CustomerID, 
        TransactionID,
        STR_TO_DATE(Transaction_Date_Updated, '%Y-%m-%d') AS txn_date,
        (QuantityPurchased * Price) AS Amount
    FROM sales_transaction
),
rfm_logic AS (
    SELECT  
        CustomerID,
        MAX(txn_date) AS last_purchase_date,
        COUNT(DISTINCT TransactionID) AS Frequency,
        ROUND(SUM(Amount), 2) AS Monetary
    FROM Txn_query
    GROUP BY CustomerID
)
SELECT 
    CustomerID,
    DATEDIFF(CURDATE(), last_purchase_date) AS recency_days,
    Frequency,
    Monetary
FROM rfm_logic
ORDER BY Monetary DESC;

#---------------------------------------------------------------------------------------#

Create View RFM_Analysis As
WITH Txn_query AS (
    SELECT 
        CustomerID, 
        TransactionID,
        STR_TO_DATE(Transaction_Date_Updated, '%Y-%m-%d') AS txn_date,
        (QuantityPurchased * Price) AS Amount
    FROM sales_transaction
),
rfm_logic AS (
    SELECT  
        CustomerID,
        MAX(txn_date) AS last_purchase_date,
        COUNT(DISTINCT TransactionID) AS Frequency,
        ROUND(SUM(Amount), 2) AS Monetary
    FROM Txn_query
    GROUP BY CustomerID
)
SELECT 
    CustomerID,
    DATEDIFF(CURDATE(), last_purchase_date) AS recency_days,
    Frequency,
    Monetary
FROM rfm_logic
ORDER BY Monetary DESC;

Select * from rfm_analysis;

#---------------------------------------------------------------------------------------#
#Added additional random column to calculate Hourly Sales trend

ALTER TABLE sales_transaction
ADD COLUMN sale_date_time DATETIME;

select * from sales_transaction;

UPDATE sales_transaction
SET Transaction_Date_Updated = 
    TIMESTAMP(
        DATE(sale_date_time),
        SEC_TO_TIME(FLOOR(RAND() * 86400))
    );

-- Time-of-Day or Hourly Sales Trend 

-- Adds Behvioral insight if your datetime has a time component
Select * from product_inventory;

SELECT 
    HOUR(sale_date_time) AS Sales_hour,
    COUNT(TransactionID) AS total_orders,
    round(SUM(QuantityPurchased * Price),0) AS total_sales
FROM sales_transaction
GROUP BY HOUR(sale_date_time)
ORDER BY Sales_hour;

#View of Hourly Sales Trend

Create View Hourly_Sales_Trend As
SELECT 
    HOUR(sale_date_time) AS Sales_hour,
    COUNT(TransactionID) AS total_orders,
    round(SUM(QuantityPurchased * Price),0) AS total_sales
FROM sales_transaction
GROUP BY HOUR(sale_date_time)
ORDER BY Sales_hour;

Select * from hourly_sales_trend;

#Sales trend using bucket analysis
Select 
    Hour(sale_date_time) as Sales_hour,
    Count(TransactionID) as total_orders,
    round(sum(QuantityPurchased*Price),0) as total_sales,
        Case 
           When Hour(sale_date_time) between 0 and 5 Then "Late Night"
           When Hour(sale_date_time) between 6 and 11 Then "Morning"
           When Hour(sale_date_time) between 12 and 16 Then "Afternoon"
           When Hour(sale_date_time) between 17 and 21 Then "Evening"
           Else "Night"
           End as Bucket_Category
From sales_transaction
group by 
Hour(sale_date_time),
Bucket_Category
Order by Sales_hour;

-- Created View of Sales Bucket Analysis

Create View Sales_Bucket As 
Select 
    Hour(sale_date_time) as Sales_hour,
    Count(TransactionID) as total_orders,
    round(sum(QuantityPurchased*Price),0) as total_sales,
        Case 
           When Hour(sale_date_time) between 0 and 5 Then "Late Night"
           When Hour(sale_date_time) between 6 and 11 Then "Morning"
           When Hour(sale_date_time) between 12 and 16 Then "Afternoon"
           When Hour(sale_date_time) between 17 and 21 Then "Evening"
           Else "Night"
           End as Bucket_Category
From sales_transaction
group by 
Hour(sale_date_time),
Bucket_Category
Order by Sales_hour;

Select * from Sales_Bucket;

#-----------------------------------------------------------------------------------#