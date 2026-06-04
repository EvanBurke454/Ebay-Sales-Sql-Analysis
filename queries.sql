-- Query 1: Total Profit by LEGO Category
SELECT 
    CASE 
        WHEN LOWER("Product Discription") LIKE '%ninjago%' THEN 'Ninjago'
        WHEN LOWER("Product Discription") LIKE '%star wars%' THEN 'Star Wars'
        WHEN LOWER("Product Discription") LIKE '%marvel%' THEN 'Marvel'
        WHEN LOWER("Product Discription") LIKE '%jurassic%' THEN 'Jurassic'
        WHEN LOWER("Product Discription") LIKE '%batman%' OR LOWER("Product Discription") LIKE '%dc %' THEN 'DC'
        WHEN LOWER("Product Discription") LIKE '%cmf%' OR LOWER("Product Discription") LIKE '%minifigure%' THEN 'CMF/Minifigs'
        ELSE 'Other'
    END AS Category,
    COUNT(*) AS Total_Sales,
    ROUND(SUM(CAST(REPLACE(REPLACE(Profit, '$', ''), ',', '') AS REAL)), 2) AS Total_Profit,
    ROUND(AVG(CAST(REPLACE(REPLACE(Profit, '$', ''), ',', '') AS REAL)), 2) AS Avg_Profit_Per_Sale
FROM "BricksAhoy616 Ebay Tracker (Original)(Sheet1)"
WHERE Profit IS NOT NULL 
AND Profit != ''
AND Profit != 'Profit'
GROUP BY Category
ORDER BY Total_Profit DESC;
-- Query 2: Average Profit Margin by Price Tier
SELECT 
    CASE 
        WHEN CAST(REPLACE(REPLACE("Listing Price", '$', ''), ',', '') AS REAL) < 25 THEN 'Under $25'
        WHEN CAST(REPLACE(REPLACE("Listing Price", '$', ''), ',', '') AS REAL) < 50 THEN '$25-50'
        WHEN CAST(REPLACE(REPLACE("Listing Price", '$', ''), ',', '') AS REAL) < 100 THEN '$50-100'
        WHEN CAST(REPLACE(REPLACE("Listing Price", '$', ''), ',', '') AS REAL) < 200 THEN '$100-200'
        ELSE '$200+'
    END AS Price_Tier,
    COUNT(*) AS Total_Sales,
    ROUND(AVG(CAST(REPLACE(REPLACE(Profit, '$', ''), ',', '') AS REAL) / 
        CAST(REPLACE(REPLACE("Listing Price", '$', ''), ',', '') AS REAL) * 100), 2) AS Avg_Margin_Pct
FROM "BricksAhoy616 Ebay Tracker (Original)(Sheet1)"
WHERE Profit IS NOT NULL AND Profit != '' AND Profit != 'Profit'
AND "Listing Price" IS NOT NULL AND "Listing Price" != ''
AND CAST(REPLACE(REPLACE("Listing Price", '$', ''), ',', '') AS REAL) > 0
GROUP BY Price_Tier
ORDER BY Avg_Margin_Pct DESC;

-- Query 3: Profit by Partner
SELECT 
    Owner,
    COUNT(*) AS Total_Sales,
    ROUND(SUM(CAST(REPLACE(REPLACE(Profit, '$', ''), ',', '') AS REAL)), 2) AS Total_Profit,
    ROUND(AVG(CAST(REPLACE(REPLACE(Profit, '$', ''), ',', '') AS REAL)), 2) AS Avg_Profit_Per_Sale
FROM "BricksAhoy616 Ebay Tracker (Original)(Sheet1)"
WHERE Profit IS NOT NULL AND Profit != '' AND Profit != 'Profit'
AND Owner IS NOT NULL AND Owner != ''
GROUP BY Owner
ORDER BY Total_Profit DESC;

-- Query 4: Top 5 Most Profitable Sales
SELECT 
    "Product Discription",
    Owner,
    REPLACE(REPLACE("Listing Price", '$', ''), ',', '') AS Listing_Price,
    ROUND(CAST(REPLACE(REPLACE(Profit, '$', ''), ',', '') AS REAL), 2) AS Profit,
    ROUND(CAST(REPLACE(REPLACE(Profit, '$', ''), ',', '') AS REAL) / 
        CAST(REPLACE(REPLACE("Listing Price", '$', ''), ',', '') AS REAL) * 100, 2) AS Margin_Pct
FROM "BricksAhoy616 Ebay Tracker (Original)(Sheet1)"
WHERE Profit IS NOT NULL AND Profit != '' AND Profit != 'Profit'
AND "Listing Price" IS NOT NULL AND "Listing Price" != ''
ORDER BY CAST(REPLACE(REPLACE(Profit, '$', ''), ',', '') AS REAL) DESC
LIMIT 5;

-- Query 5: Monthly Sales Performance
SELECT 
    SUBSTR("Date Sold", 1, 7) AS Month,
    COUNT(*) AS Total_Sales,
    ROUND(SUM(CAST(REPLACE(REPLACE(Profit, '$', ''), ',', '') AS REAL)), 2) AS Total_Profit
FROM "BricksAhoy616 Ebay Tracker (Original)(Sheet1)"
WHERE Profit IS NOT NULL AND Profit != '' AND Profit != 'Profit'
AND "Date Sold" IS NOT NULL AND "Date Sold" != ''
GROUP BY Month
ORDER BY Month ASC;

-- Query 6: Business Summary Statistics
SELECT
    COUNT(*) AS Total_Sales,
    ROUND(SUM(CAST(REPLACE(REPLACE(Profit, '$', ''), ',', '') AS REAL)), 2) AS Total_Profit,
    ROUND(AVG(CAST(REPLACE(REPLACE(Profit, '$', ''), ',', '') AS REAL)), 2) AS Avg_Profit_Per_Sale,
    ROUND(MAX(CAST(REPLACE(REPLACE(Profit, '$', ''), ',', '') AS REAL)), 2) AS Best_Sale,
    ROUND(MIN(CAST(REPLACE(REPLACE(Profit, '$', ''), ',', '') AS REAL)), 2) AS Worst_Sale,
    ROUND(AVG(CAST(REPLACE(REPLACE(Profit, '$', ''), ',', '') AS REAL) / 
        CAST(REPLACE(REPLACE("Listing Price", '$', ''), ',', '') AS REAL) * 100), 2) AS Avg_Margin_Pct
FROM "BricksAhoy616 Ebay Tracker (Original)(Sheet1)"
WHERE Profit IS NOT NULL AND Profit != '' AND Profit != 'Profit'
AND "Listing Price" IS NOT NULL AND "Listing Price" != ''
AND CAST(REPLACE(REPLACE("Listing Price", '$', ''), ',', '') AS REAL) > 0;