use wall_mart;

SELECT * FROM walmartSales;

---------------------------------------------------------------------------------

---CREATE A NEW COLUMN(TIME OF DATE)---
ALTER TABLE walmartSales
ADD time_of_day VARCHAR(10);


UPDATE walmartSales
SET time_of_day = CASE
		WHEN DATEPART(hour,Time) BETWEEN 6 AND 11 THEN 'Morning'
		WHEN DATEPART(hour,Time) BETWEEN 12 AND 17 THEN 'Afternoon'
		WHEN DATEPART(hour,Time) BETWEEN 18 AND 23 THEN 'Evening'
		ELSE 'Night'
	END;

---------------------------------------------------------------------------------------

---CREATE A NEW COLUMN(DAY NAME)---
ALTER TABLE walmartSales
ADD day_name VARCHAR(20);

UPDATE walmartSales
SET day_name = LEFT(DATENAME(weekday, Date), 3);

---------------------------------------------------------------------------------------
---CREATE A NEW COLUMN(MONTH NAME)---
ALTER TABLE walmartSales
ADD month_name VARCHAR(20);

UPDATE walmartSales
SET month_name = LEFT(DATENAME(MONTH, Date), 3);

---------------------------------------------------------------------------------------

-------REVENUE AND PROFIT CALCULATION-------

--COGS(COST OF GOODS SERVICE) = Units Price * quantity 👍

--VAT(VALUE ADDED TAX)= 5% * COGS 👍

--VAT is added to the COGS and this is what is billed to the customer.
--Total (gross_sales) = VAT + COGS  👍

--Gross Profit = Total - COGS 👍

--Gross Margin is gross profit expressed in percentage of the
--total(gross profit/revenue)
--Gross Margin = gross income / total revenue 👍
---------------------------------------------------------------------
-----EXAMPLE---------
--Data given:
--Unite Price = 45.79 $
--Quantity = 7 $

--COGS = 45.79 * 7 = 320.53 $ 👍

--VAT = 5% * COGS = 5% * 320.53 = 16.0265 $ 👍

--Total = VAT + COGS = 16.0265 + 320.53 = 336.5565 $ 👍

--Gross profit=Total-COGS=336.5565-320.53 👍

--Gross Margin Percentage = gross income / total revenue = 16.0265 /
--336.5565  👍
--= 0.047619 approx
--= 4.7619 %

------------------------------------------------------------------------------
SELECT * FROM walmartSales;

--How many unique cities does the data have?

SELECT count(DISTINCT CITY) AS 'UNIQUE CITIES' FROM walmartSales;

--In which city is each branch?
SELECT CITY,BRANCH, COUNT(BRANCH) AS COUNT_OF_BRANCHES
FROM walmartSales
GROUP BY  CITY,BRANCH
ORDER BY BRANCH;

---------------------------------------------------------------------------

--                            PRODUCT ANALYSIS


SELECT * FROM walmartSales;

--  1. How many unique product lines does the data have?

SELECT COUNT(DISTINCT product_line) AS TOTAL_UNIQUE_PRODUCT_LINES
FROM walmartSales;

--  2. What is the most common payment method?

SELECT TOP 1 PAYMENT, COUNT(PAYMENT) AS COUNT_OF_PAYMENT
FROM walmartSales
GROUP BY PAYMENT
ORDER BY COUNT_OF_PAYMENT DESC;

--3. What is the most selling product line?

SELECT TOP 1 PRODUCT_LINE, COUNT(QUANTITY) AS COUNT_OF_QUANTITY 
FROM walmartSales
GROUP BY PRODUCT_LINE
ORDER BY COUNT_OF_QUANTITY DESC;

--4. What is the total revenue by month?

SELECT MONTH_NAME,ROUND(SUM(TOTAL),2) AS 'TOTAL REVENUE' 
FROM walmartSales
GROUP BY MONTH_NAME
ORDER BY CASE 
           WHEN MONTH_NAME = 'Jan' THEN 1
           WHEN MONTH_NAME = 'Feb' THEN 2
           WHEN MONTH_NAME = 'Mar' THEN 3
           WHEN MONTH_NAME = 'Apr' THEN 4
           WHEN MONTH_NAME = 'May' THEN 5
           WHEN MONTH_NAME = 'Jun' THEN 6
           WHEN MONTH_NAME = 'Jul' THEN 7
           WHEN MONTH_NAME = 'Aug' THEN 8
           WHEN MONTH_NAME = 'Sep' THEN 9
           WHEN MONTH_NAME = 'Oct' THEN 10
           WHEN MONTH_NAME = 'Nov' THEN 11
           WHEN MONTH_NAME = 'Dec' THEN 12
         END;

--5.What month had the largest COGS?

SELECT TOP 1 MONTH_NAME,ROUND(MAX(COGS),2) AS "LARGEST_COGS"
FROM walmartSales
GROUP BY MONTH_NAME
ORDER BY LARGEST_COGS DESC;

--6. What product line had the largest revenue?

SELECT TOP 1 PRODUCT_LINE,ROUND(MAX(TOTAL),2) AS TOTAL_REVENUE
FROM walmartSales
GROUP BY PRODUCT_LINE
ORDER BY TOTAL_REVENUE DESC;

--7. What is the city with the largest revenue?

SELECT TOP 1 CITY,ROUND(SUM(TOTAL),2) AS TOTAL_SALES
FROM walmartSales
GROUP BY CITY
ORDER BY TOTAL_SALES DESC;

--8.What product line had the largest VAT?

SELECT TOP 1 PRODUCT_LINE,ROUND(MAX(TAX_5),2) AS LARGEST_VAT
FROM walmartSales
GROUP BY PRODUCT_LINE
ORDER BY LARGEST_VAT DESC;

--9. Fetch each product line and add a column to those product line showing 
--    "Good", "Bad". Good if its greater than average sales 

---CREATE A NEW COLUMN(REVIEW)---
ALTER TABLE walmartSales
ADD REVIEW VARCHAR(10);

UPDATE walmartSales
SET REVIEW = CASE
		WHEN TOTAL>(SELECT ROUND(AVG(TOTAL),2) FROM walmartSales) THEN 'GOOD'
		ELSE 'BAD'
	END;

--10.Which branch sold more products than average product sold? 

SELECT TOP 1 BRANCH,SUM(QUANTITY) AS TOTAL_QUANTITY 
FROM walmartSales
WHERE QUANTITY>(SELECT AVG(QUANTITY)FROM walmartSales)
GROUP BY BRANCH
ORDER BY TOTAL_QUANTITY DESC;

--11. What is the most common product line by gender? 

select  Gender,PRODUCT_LINE,count(product_line) AS COUNT_PRODUCT_LINE
from walmartSales
group by Gender,PRODUCT_LINE
ORDER BY COUNT_PRODUCT_LINE DESC;

--12. What is the average rating of each product line?

SELECT PRODUCT_LINE,ROUND(AVG(Rating),2)AS AVG_RATING 
FROM walmartSales
GROUP BY PRODUCT_LINE
ORDER BY AVG_RATING DESC;

-----------------------------------------------------------------------------
--                           Customer Analysis  


SELECT * FROM walmartSales;

--1. How many unique customer types does the data have?  

SELECT COUNT (DISTINCT (CUSTOMER_TYPE)) AS TOTAL_UNIQUE_CUSTOMER
FROM walmartSales;

--2. How many unique payment methods does the data have? 

SELECT COUNT(DISTINCT(PAYMENT)) AS TOTAL_UNIQUE_PAYMENT_METHOD
FROM walmartSales;

--3. Which customer type buys the most?

SELECT TOP 1 CUSTOMER_TYPE,SUM(QUANTITY) AS BUYS_THE_MOST
FROM walmartSales
GROUP BY CUSTOMER_TYPE
ORDER BY BUYS_THE_MOST DESC;

--4. What is the gender of most of the customers? 

SELECT TOP 1 GENDER,COUNT(CUSTOMER_TYPE) AS COUNT_OF_CUSTOMER_TYPE
FROM walmartSales
GROUP BY GENDER
ORDER BY COUNT_OF_CUSTOMER_TYPE DESC;

--5. What is the gender distribution per branch?  

SELECT GENDER,BRANCH,COUNT(GENDER)AS distribution_per_branch
FROM walmartSales
GROUP BY GENDER,BRANCH
ORDER BY BRANCH;

--6. Which time of the day do customers give most ratings?

SELECT TOP 1 TIME_OF_DAY,COUNT(RATING)AS MAX_RATING
FROM walmartSales
GROUP BY TIME_OF_DAY
ORDER BY MAX_RATING DESC;

--7.Which time of the day do customers give most ratings per branch?

WITH RatingsCount AS (
    SELECT BRANCH,TIME_OF_DAY,ROUND(AVG(RATING),2) AS RATING_COUNT
    FROM walmartSales
    GROUP BY BRANCH,TIME_OF_DAY
),
MaxRatings AS (
    SELECT BRANCH,MAX(RATING_COUNT) AS MAX_RATING_COUNT
    FROM RatingsCount
    GROUP BY BRANCH
)
SELECT rc.BRANCH,rc.TIME_OF_DAY,rc.RATING_COUNT AS MAX_RATING
FROM RatingsCount rc
INNER JOIN
    MaxRatings mr 
    ON rc.BRANCH = mr.BRANCH 
    AND rc.RATING_COUNT = mr.MAX_RATING_COUNT
ORDER BY rc.RATING_COUNT DESC;

--8. Which day for the week has the best avg ratings? 

select top 1 day_name,round(avg(rating),2) as average_rating
FROM walmartSales
group by day_name
order by average_rating desc;

--9. Which day of the week has the best average ratings per branch? #ERROR

WITH RatingsCount AS (
    SELECT BRANCH,day_name,cast(AVG(RATING) as decimal(10,2)) AS RATING_COUNT
    FROM walmartSales
    GROUP BY BRANCH,day_name
),
MaxRatings AS (
    SELECT BRANCH,MAX(RATING_COUNT) AS MAX_RATING_COUNT
    FROM RatingsCount
    GROUP BY BRANCH
)
SELECT rc.BRANCH,rc.day_name,rc.RATING_COUNT AS MAX_RATING
FROM RatingsCount rc
INNER JOIN
    MaxRatings mr 
    ON rc.BRANCH = mr.BRANCH 
    AND rc.RATING_COUNT = mr.MAX_RATING_COUNT
ORDER BY rc.BRANCH ;
-------------------------------------------------------------------------------
--                           Sales Analysis  

SELECT * FROM walmartSales;

--1. Number of sales made in each time of the day per weekday  

SELECT DAY_NAME,TIME_OF_DAY,COUNT(TOTAL) AS NUMBER_OF_SALES
FROM walmartSales
GROUP BY DAY_NAME,TIME_OF_DAY
ORDER BY CASE
			WHEN DAY_NAME='SUN'  THEN 1
			WHEN DAY_NAME='MON'  THEN 2
			WHEN DAY_NAME='TUE'  THEN 3
			WHEN DAY_NAME='WED'  THEN 4
			WHEN DAY_NAME='THU'  THEN 5
			WHEN DAY_NAME='FRI'  THEN 6
			ELSE 7
		END,
		CASE
			WHEN TIME_OF_DAY='MORNING' THEN 1
			WHEN TIME_OF_DAY='AFTERNOON' THEN 2
			ELSE 3
		END;

--2.Which of the customer types brings the most revenue?  

SELECT TOP 1 CUSTOMER_TYPE,ROUND(SUM(TOTAL),2) AS MOST_REVENUE
FROM walmartSales
GROUP BY CUSTOMER_TYPE
ORDER BY MOST_REVENUE DESC;

--3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?

SELECT * FROM walmartSales;

SELECT TOP 1 CITY,MAX(TAX_5) AS MAX_VAT
FROM walmartSales
GROUP BY CITY
ORDER BY MAX_VAT DESC;


--4. Which customer type pays the most in VAT? 

SELECT TOP 1 CUSTOMER_TYPE,ROUND(MAX(TAX_5),2) AS MAX_VAT_PAYS
FROM walmartSales
GROUP BY CUSTOMER_TYPE
ORDER BY MAX_VAT_PAYS DESC;
