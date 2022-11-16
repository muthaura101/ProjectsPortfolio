--- ABOUT WALMART DATASET
-- About this file- from Kaggle* link: https://www.kaggle.com/yasserh/walmart-dataset This is the historical data that covers sales from 2010-02-05 to 2012-11-01, 
--in the file WalmartStoresales. Within this file you will find the following fields;
--Store - the store number 
--Date - the week of sales 
--Weekly_Sales - sales for the given store 
--Holiday_Flag - whether the week is a special holiday week 1 – Holiday week 0 – Non-holiday week 
--Temperature - Temperature on the day of sale 
--Fuel_Price - Cost of fuel in the region 
--CPI – Prevailing consumer price index 

-- Holiday Events are;
--Unemployment - Prevailing unemployment rate Holiday Events
--Super Bowl: 12-Feb-10, 11-Feb-11, 10-Feb-12, 8-Feb-13
--Labour Day: 10-Sep-10, 9-Sep-11, 7-Sep-12, 6-Sep-13
--Thanksgiving: 26-Nov-10, 25-Nov-11, 23-Nov-12, 29-Nov-13
--Christmas: 31-Dec-10, 30-Dec-11, 28-Dec-12, 27-Dec-13

-- View data
SELECT *
FROM
	WalmartSales.dbo.Walmart$

-- Changing DateTime data to date only
SELECT
	Store, Weekly_Sales, Holiday_Flag, Temperature, Fuel_Price, CPI, Unemployment,
	CAST(Date AS date) AS Date_Month
FROM	
	WalmartSales.dbo.Walmart$
WHERE
 Date is not NULL
Order By Date_Month DESC

-- Which year had the Highest Sales?
SELECT
	SUM(Weekly_Sales) AS Sum_Weekly_Sales,
	YEAR(Date) AS Year_of_Sales
FROM
	WalmartSales.dbo.Walmart$
GROUP BY
	YEAR(Date)
ORDER BY
	SUM(Weekly_Sales) DESC

--Top Holiday Holiday Sales
--Holiday_Flag 1 is an index for Holiday week and Holiday_Flag 0 is an index for Non-Holiday Week.
SELECT
	CAST(Date AS date) AS Year_Month_Day,
	SUM(Weekly_Sales) AS Sum_Weekly_Sales,
	AVG(Weekly_Sales) AS Avg_Weekly_Sales
FROM
	WalmartSales.dbo.Walmart$
WHERE
	Holiday_Flag = 1
GROUP BY
	CAST(Date AS date)
ORDER BY
	AVG(Weekly_Sales) DESC

--- KEY INSIGHTS
-- The top most profitable holidays are Thanksgiving which happens on November and Followed by Super Bowl which happens on February. It seems that Christmas Day of all
-- holidays has the lowest sales. 
 
-- Top Non-Holiday Sales
SELECT
	CAST(Date AS date) AS Year_Month_Day,
	SUM(Weekly_Sales) AS Sum_Weekly_Sales,
	AVG(Weekly_Sales) AS Avg_Weekly_Sales
FROM
	WalmartSales.dbo.Walmart$
WHERE
	Holiday_Flag = 0
GROUP BY
	CAST(Date AS date)
ORDER BY
	CAST(Date AS date)
	
-- Top Stores by Total Weekly_Sales And Average Weekly_Sales
SELECT
	Store,
	SUM(Weekly_Sales) AS Sum_Weekly_Sales,
	AVG(Weekly_Sales) AS Avg_Weekly_Sales
FROM	
	WalmartSales.dbo.Walmart$
GROUP BY
	Store
ORDER BY
	AVG(Weekly_Sales) DESC

---- Calculating Percentage of Total Sales for Each Store
SELECT 
	Store,
	ROUND(SUM(Weekly_Sales)*100 / SUM(SUM(Weekly_Sales)) OVER (),2) AS Percentage_of_Total_Sales,
	SUM(Weekly_Sales) AS Sum_Weekly_Sales
FROM
	WalmartSales.dbo.Walmart$
GROUP BY
	Store
ORDER BY
	SUM(Weekly_Sales)*100 / SUM(SUM(Weekly_Sales)) OVER () DESC

--- KEY INSIGHTS	
-- Store 20 has the Highest Sales of $301,397,792.46 which is 4.5% of the Total Sales while Store Store 33 has the least Sales of $37,160,221.96, which is 0.55% of the Total Sales.
-- The Top 5 Stores are Stores 20, 4, 14, 13 and 2 while the bottom 5 are Stores 38, 36, 5, 44 and 33  
-- Why does Store 20 have the highest Sales and Store 33 has the least? I shall Analyze the relationship between Sales and different Macro-Economic Variables
-- that are found in the dataset such as Fuel_Price, Unemployment and CPI. I will also look ate the relationship between Average Temperature readings and the Sales
SELECT
	Store,
	SUM(Weekly_Sales) AS Sum_Weekly_Sales,
	ROUND(SUM(Weekly_Sales)*100 / SUM(SUM(Weekly_Sales)) OVER (),2) AS Percentage_of_Total_Sales,
	ROUND(AVG(Weekly_Sales),2) AS Avg_Weekly_Sales,
	ROUND(AVG(Temperature),2) AS Avg_Temperature,
	ROUND(AVG(Fuel_Price),2) AS Avg_Fuel_Price,
	ROUND(AVG(CPI),2) AS Avg_CPI,
	ROUND(AVG(Unemployment),2) AS Avg_Unemployment
FROM	
	WalmartSales.dbo.Walmart$
GROUP BY
	Store
ORDER BY
	AVG(Weekly_Sales) DESC

SELECT
	SUM(Weekly_Sales) AS Total_Sales, 
	ROUND(AVG(Temperature),2) AS Avg_Temperature,
	ROUND(AVG(Fuel_Price),2) AS Avg_Fuel_Price,
	ROUND(AVG(CPI),2) AS Avg_CPI,
	ROUND(AVG(Unemployment),2) AS Avg_Unemployment
	FROM
	WalmartSales.dbo.Walmart$

--- KEY INSIGHTS
-- It is hard to clearly see wether there are relationships between Sales and the different Macro-Economic variables as well as Temperature in the dataset.
-- This relationship can be clearly seen using a scatterplot when visualizing the data.


